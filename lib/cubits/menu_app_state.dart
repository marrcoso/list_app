import 'package:equatable/equatable.dart';
import '../models/task.dart';

enum MenuAppDialog { none, taskDetails, taskEdit }

class MenuAppState extends Equatable {
  final MenuAppDialog dialogType;
  final Task? selectedTask;
  final List<Task> tasks;
  final bool isLoading;

  const MenuAppState({
    this.dialogType = MenuAppDialog.none,
    this.selectedTask,
    this.tasks = const [],
    this.isLoading = false,
  });

  MenuAppState copyWith({
    MenuAppDialog? dialogType,
    Task? selectedTask,
    List<Task>? tasks,
    bool? isLoading,
  }) {
    return MenuAppState(
      dialogType: dialogType ?? this.dialogType,
      selectedTask: selectedTask ?? this.selectedTask,
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [dialogType, selectedTask, tasks, isLoading];
}
