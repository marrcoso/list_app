import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_app/components/item_list.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';
import '../models/task.dart';
import '../database/database_helper.dart';
import '../cubits/menu_app_cubit.dart';
import '../cubits/menu_app_state.dart';
import '../components/app_dialogs.dart';

@RoutePage()
class MenuAppPage extends StatelessWidget {
  const MenuAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuAppCubit(),
      child: const Scaffold(
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
      ),
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
  bool isDialogOpen = false;

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
    return BlocListener<MenuAppCubit, MenuAppState>(
      listener: (context, state) {
        final cubit = context.read<MenuAppCubit>();
        switch (state.dialogType) {
          case MenuAppDialog.taskDetails:
            if (!isDialogOpen) {
              isDialogOpen = true;
              AppDialogs.showTaskDetailsDialog(
                context,
                state.selectedTask!,
                cubit,
              ).then((_) {
                _loadTasks();
              });
            }
            break;
          case MenuAppDialog.taskEdit:
            if (!isDialogOpen) {
              isDialogOpen = true;
              AppDialogs.showTaskEditDialog(
                context,
                state.selectedTask!,
                cubit,
              ).then((_) {
                _loadTasks();
              });
            }
            break;
          case MenuAppDialog.none:
            if (isDialogOpen) {
              isDialogOpen = false;
              context.router.pop();
            }
            break;
        }
      },
      child: Column(
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
                  if (context.mounted) {
                    context.read<MenuAppCubit>().showTaskEdit(newTask);
                  }
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
                      onTap: () {
                        context.read<MenuAppCubit>().showTaskDetails(task);
                      },
                      child: ItemList(
                        currentTask: task,
                        backgroundColor: task.isDone ? Colors.grey : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
