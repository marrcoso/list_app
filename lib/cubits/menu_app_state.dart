import 'package:equatable/equatable.dart';
import '../models/task.dart';

enum MenuAppDialog { none, taskDetails, taskEdit }

class MenuAppState extends Equatable {
  final MenuAppDialog dialogType;
  final Task? selectedTask;
  final List<Task> tasks;
  final bool isLoading;
  final String selectedCategory;

  const MenuAppState({
    this.dialogType = MenuAppDialog.none,
    this.selectedTask,
    this.tasks = const [],
    this.isLoading = false,
    this.selectedCategory = 'Todas',
  });

  MenuAppState copyWith({
    MenuAppDialog? dialogType,
    Task? selectedTask,
    List<Task>? tasks,
    bool? isLoading,
    String? selectedCategory,
  }) {
    return MenuAppState(
      dialogType: dialogType ?? this.dialogType,
      selectedTask: selectedTask ?? this.selectedTask,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [dialogType, selectedTask, tasks, isLoading, selectedCategory];
}
