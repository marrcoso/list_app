import 'package:equatable/equatable.dart';
import '../models/task.dart';

enum MenuAppDialog { none, taskDetails }

class MenuAppState extends Equatable {
  final MenuAppDialog dialogType;
  final Task? selectedTask;

  const MenuAppState({
    this.dialogType = MenuAppDialog.none,
    this.selectedTask
  });

  MenuAppState copyWith({
    MenuAppDialog? dialogType,
    Task? selectedTask,
    bool? isDialogOpen,
  }) {
    return MenuAppState(
      dialogType: dialogType ?? this.dialogType,
      selectedTask: selectedTask ?? this.selectedTask,
    );
  }

  @override
  List<Object?> get props => [dialogType, selectedTask];
}
