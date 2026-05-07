import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_app/components/item_list.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';
import '../models/task.dart';
import '../cubits/menu_app_cubit.dart';
import '../cubits/menu_app_state.dart';
import '../components/app_dialogs.dart';

@RoutePage()
class MenuAppPage extends StatelessWidget {
  const MenuAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Tarefas',
        ),
        body: const MenuPage(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'Todas'),
                Tab(icon: Icon(Icons.star), text: 'Import.'),
                Tab(icon: Icon(Icons.check_circle), text: 'Concl.'),
                Tab(icon: Icon(Icons.history), text: 'Atras.'),
              ],
            ),
          ),
        ),
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
  bool isDialogOpen = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuAppCubit, MenuAppState>(
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
              );
            }
            break;
          case MenuAppDialog.taskEdit:
            if (!isDialogOpen) {
              isDialogOpen = true;
              AppDialogs.showTaskEditDialog(
                context,
                state.selectedTask!,
                cubit,
              );
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
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: CustomButton(
                title: 'Adicionar',
                icon: Icons.add,
                backgroundColor: AppColors.primary,
                onPressed: () => context.read<MenuAppCubit>().addNewTask(),
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: ['Todas', 'Geral', 'Casa', 'Trabalho', 'Outros'].map((category) {
                  final isSelected = state.selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          context.read<MenuAppCubit>().updateFilterCategory(category);
                        }
                      },
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: state.isLoading 
                ? const Center(child: CircularProgressIndicator())
                : Builder(
                    builder: (context) {
                      final categoryTasks = state.selectedCategory == 'Todas'
                          ? state.tasks
                          : state.tasks.where((t) => t.categoria == state.selectedCategory).toList();
                      
                      return TabBarView(
                        children: [
                          _buildTaskList(categoryTasks),
                          _buildTaskList(categoryTasks.where((t) => t.isImportante).toList()),
                          _buildTaskList(categoryTasks.where((t) => t.isConcluido).toList()),
                          _buildTaskList(categoryTasks.where((t) {
                            final isDelayed = t.dataVencimento.isBefore(DateTime.now().subtract(const Duration(days: 1))) && !t.isConcluido;
                            return isDelayed;
                          }).toList()),
                        ],
                      );
                    }
                  ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskList(List<Task> filteredTasks) {
    if (filteredTasks.isEmpty) {
      return const Center(
        child: Text(
          'Nenhuma tarefa encontrada!',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: InkWell(
              onTap: () {
                context.read<MenuAppCubit>().showTaskDetails(task);
              },
              child: ItemList(
                currentTask: task,
                backgroundColor: task.isConcluido ? Colors.grey : Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
