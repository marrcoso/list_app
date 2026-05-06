import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import 'menu_app_state.dart';
import '../database/database_helper.dart';

class MenuAppCubit extends Cubit<MenuAppState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  Timer? _debounceTimer;

  MenuAppCubit() : super(const MenuAppState());

  void showTaskDetails(Task task) {
    if (state.dialogType != MenuAppDialog.none && state.dialogType != MenuAppDialog.taskDetails) closeDialog();
    emit(state.copyWith(
      dialogType: MenuAppDialog.taskDetails,
      selectedTask: task,
    ));
  }

  void showTaskEdit(Task task) {
    if (state.dialogType != MenuAppDialog.none && state.dialogType != MenuAppDialog.taskEdit) closeDialog();
    emit(state.copyWith(
      dialogType: MenuAppDialog.taskEdit,
      selectedTask: task,
    ));
  }

  void closeDialog() {
    _debounceTimer?.cancel();
    emit(state.copyWith(
      dialogType: MenuAppDialog.none,
      selectedTask: null,
    ));
  }

  void updateTaskTitle(String title) {
    if (state.selectedTask == null) return;
    state.selectedTask!.title = title;
    _onTaskChanged();
  }

  void updateTaskDescription(String description) {
    if (state.selectedTask == null) return;
    state.selectedTask!.description = description;
    _onTaskChanged();
  }

  void updateTaskImportance(bool isImportant) {
    if (state.selectedTask == null) return;
    state.selectedTask!.isImportant = isImportant;
    _onTaskChanged(immediate: true);
    emit(state.copyWith()); // Trigger rebuild
  }

  void updateTaskStatus(bool isDone) {
    if (state.selectedTask == null) return;
    state.selectedTask!.isDone = isDone;
    _onTaskChanged(immediate: true);
    emit(state.copyWith()); // Trigger rebuild
  }

  void updateTaskDate(DateTime date) {
    if (state.selectedTask == null) return;
    state.selectedTask!.dueDate = date;
    _onTaskChanged(immediate: true);
    emit(state.copyWith()); // Trigger rebuild
  }

  Future<void> deleteTask() async {
    if (state.selectedTask?.id == null) return;
    await _dbHelper.deleteTask(state.selectedTask!.id!);
    closeDialog();
  }

  void _onTaskChanged({bool immediate = false}) {
    _debounceTimer?.cancel();
    if (immediate) {
      _saveTask();
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 500), _saveTask);
    }
  }

  Future<void> _saveTask() async {
    if (state.selectedTask != null) {
      await _dbHelper.updateTask(state.selectedTask!);
    }
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
