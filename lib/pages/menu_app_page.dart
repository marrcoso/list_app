import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:list_app/components/item_list.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';
import '../models/task.dart';
import 'package:list_app/theme/router/router.gr.dart';
import '../database/database_helper.dart';

@RoutePage()
class MenuAppPage extends StatelessWidget {
  const MenuAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Menu App',
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: MenuPage(),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _dbHelper.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.onBackground, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: CustomButton(
              title: 'Adicionar',
              icon: Icons.add,
              backgroundColor: AppColors.secondaryVariant,
              onPressed: () async {
                final newTask = Task(
                  title: 'Nova Tarefa',
                  description: 'Insira a descrição aqui...',
                  dueDate: DateTime.now(),
                  isImportant: false,
                  isDone: false,
                  category: 'Geral',
                );
                final id = await _dbHelper.insertTask(newTask);
                newTask.id = id;
                await context.router.push(TaskDetailsRoute(task: newTask));
                _loadTasks();
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: InkWell(
                    onTap: () async {
                      await context.router.push(TaskDetailsRoute(task: task));
                      _loadTasks();
                    },
                    child: ItemList(
                      title: task.title,
                      isImportant: task.isImportant,
                      isDone: task.isDone,
                    ),
                  ),
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}
