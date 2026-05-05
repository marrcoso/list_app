import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:list_app/models/task.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../database/database_helper.dart';

@RoutePage()
class TaskDetailsPage extends StatefulWidget {
  final Task task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late bool _isDone;
  late bool _isImportant;
  late DateTime _selectedDate;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  Timer? _timerBanco;

  @override
  void initState() {
    super.initState();
    _isDone = widget.task.isDone;
    _isImportant = widget.task.isImportant;
    _selectedDate = widget.task.dueDate;
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _timerBanco?.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detalhes da Tarefa',
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: () async {
              if (widget.task.id != null) {
                await _dbHelper.deleteTask(widget.task.id!);
                if (context.mounted) context.router.back();
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${widget.task.id}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(color: AppColors.primary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
              onChanged: (value) {
                widget.task.title = value;
                _onChanged();
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'A tarefa é importante?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
            ),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isImportant,
                  activeColor: AppColors.error,
                  onChanged: (value) {
                    setState(() {
                      _isImportant = value!;
                      widget.task.isImportant = value;
                    });
                    _saveTask();
                  },
                ),
                const Text('Sim'),
                const SizedBox(width: 16),
                Radio<bool>(
                  value: false,
                  groupValue: _isImportant,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _isImportant = value!;
                      widget.task.isImportant = value;
                    });
                    _saveTask();
                  },
                ),
                const Text('Não'),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.task.category.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(color: AppColors.primary),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
              maxLines: 3,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.onBackground,
              ),
              onChanged: (value) {
                widget.task.description = value;
                _onChanged();
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Data Prevista: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.onBackground,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tarefa Realizada',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                Switch(
                  value: _isDone,
                  activeColor: AppColors.primary,
                  onChanged: (value) {
                    setState(() {
                      _isDone = value;
                      widget.task.isDone = value;
                    });
                    _saveTask();
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _onChanged() {
    if (_timerBanco?.isActive ?? false) _timerBanco?.cancel();
    _timerBanco = Timer(const Duration(milliseconds: 500), () {
      _saveTask();
    });
  }

  void _saveTask() {
    _dbHelper.updateTask(widget.task);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.onBackground,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        widget.task.dueDate = picked;
      });
      _saveTask();
    }
  }
}
