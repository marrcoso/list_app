import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import 'menu_app_state.dart';
import '../database/database_helper.dart';

class MenuAppCubit extends Cubit<MenuAppState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  MenuAppCubit() : super(const MenuAppState()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    emit(state.copyWith(isLoading: true));
    final tasks = await _dbHelper.getTasks();
    emit(state.copyWith(tasks: tasks, isLoading: false));
  }

  Future<void> addNewTask() async {
    final newTask = Task(
      titulo: '',
      descricao: '',
      dataVencimento: DateTime.now(),
      isImportante: false,
      isConcluido: false,
      categoria: 'Geral',
    );
    showTaskEdit(newTask);
  }

  void showTaskDetails(Task task) {
    if (state.dialogType != MenuAppDialog.none && state.dialogType != MenuAppDialog.taskDetails) closeDialog();
    emit(state.copyWith(
      dialogType: MenuAppDialog.taskDetails,
      selectedTask: task.copyWith(),
    ));
  }

  void showTaskEdit(Task task) {
    if (state.dialogType != MenuAppDialog.none && state.dialogType != MenuAppDialog.taskEdit) closeDialog();
    emit(state.copyWith(
      dialogType: MenuAppDialog.taskEdit,
      selectedTask: task.copyWith(),
    ));
  }

  void closeDialog() {
    emit(state.copyWith(
      dialogType: MenuAppDialog.none,
      selectedTask: null,
    ));
  }

  void updateTaskTitle(String title) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(titulo: title),
    ));
  }

  void updateTaskDescription(String description) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(descricao: description),
    ));
  }

  void updateTaskImportance(bool isImportant) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(isImportante: isImportant),
    ));
  }

  void updateTaskStatus(bool isDone) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(isConcluido: isDone),
    ));
  }

  void updateTaskDate(DateTime date) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(dataVencimento: date),
    ));
  }

  void updateTaskCategory(String category) {
    if (state.selectedTask == null) return;
    emit(state.copyWith(
      selectedTask: state.selectedTask!.copyWith(categoria: category),
    ));
  }

  Future<void> deleteTask() async {
    if (state.selectedTask?.id == null) return;
    await _dbHelper.deleteTask(state.selectedTask!.id!);
    closeDialog();
    await loadTasks();
  }

  Future<void> saveSelectedTask() async {
    if (state.selectedTask == null) return;
    
    if (state.selectedTask!.id == null) {
      await _dbHelper.insertTask(state.selectedTask!);
    } else {
      await _dbHelper.updateTask(state.selectedTask!);
    }
    
    closeDialog();
    await loadTasks();
  }

  void updateFilterCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }
}
