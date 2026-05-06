import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../cubits/menu_app_cubit.dart';
import '../cubits/menu_app_state.dart';

class AppDialogs {
  static Future<void> showTaskDetailsDialog(BuildContext context, Task task, MenuAppCubit cubit) async {
    
    return showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: cubit,
        child: BlocBuilder<MenuAppCubit, MenuAppState>(
          builder: (context, state) {
            final currentTask = state.selectedTask ?? task;
            
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Detalhes da Tarefa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () => cubit.deleteTask(),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text(
                        'ID: ${currentTask.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: currentTask.title,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onBackground,
                        ),
                        onChanged: (value) => cubit.updateTaskTitle(value),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: currentTask.isImportant,
                            activeColor: AppColors.error,
                            shape: const CircleBorder(),
                            onChanged: (value) => cubit.updateTaskImportance(value ?? false),
                          ),
                          const Text('Marcar como importante'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primary),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          currentTask.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        initialValue: currentTask.description,
                        decoration: const InputDecoration(
                          labelText: 'Descrição',
                          labelStyle: TextStyle(color: AppColors.primary),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                        ),
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onBackground,
                        ),
                        onChanged: (value) => cubit.updateTaskDescription(value),
                      ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: currentTask.dueDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: AppColors.primary,
                                    onPrimary: Colors.white,
                                    onSurface: AppColors.onBackground,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            cubit.updateTaskDate(picked);
                          }
                        },
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Data: ${currentTask.dueDate.day}/${currentTask.dueDate.month}/${currentTask.dueDate.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.onBackground,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Realizada',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onBackground,
                            ),
                          ),
                          Switch(
                            value: currentTask.isDone,
                            activeThumbColor: AppColors.primary,
                            onChanged: (value) => cubit.updateTaskStatus(value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => cubit.closeDialog(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Fechar'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
