import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../theme/app_colors.dart';
import '../cubits/menu_app_cubit.dart';
import '../cubits/menu_app_state.dart';

class AppDialogs {
  static Future<void> showTaskEditDialog(BuildContext context, Task task, MenuAppCubit cubit) async {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
        },
        child: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<MenuAppCubit, MenuAppState>(
            builder: (context, state) {
              final currentTask = state.selectedTask ?? task;
              
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close, color: AppColors.onBackground),
                                    onPressed: () => cubit.closeDialog(),
                                  ),
                                  Text(
                                    task.titulo.isEmpty ? 'Nova Tarefa' : 'Editar Tarefa',
                                    style: const TextStyle(
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
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              Text(
                                'ID: ${currentTask.id ?? "Novo"}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: currentTask.titulo,
                                decoration: const InputDecoration(
                                  labelText: 'Título',
                                  hintText: 'Ex: Comprar mantimentos',
                                  labelStyle: TextStyle(color: AppColors.primary),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                ),
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'O título é obrigatório';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackground,
                                ),
                                onChanged: (value) => cubit.updateTaskTitle(value),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Checkbox(
                                    value: currentTask.isImportante,
                                    activeColor: AppColors.primary,
                                    shape: const CircleBorder(),
                                    onChanged: (value) => cubit.updateTaskImportance(value ?? false),
                                  ),
                                  const Text('Marcar como importante'),
                                ],
                              ),
                              const SizedBox(height: 12),
                              DropdownButtonFormField<String>(
                                initialValue: ['Geral', 'Casa', 'Trabalho', 'Outros'].contains(currentTask.categoria) 
                                    ? currentTask.categoria 
                                    : 'Geral',
                                decoration: const InputDecoration(
                                  labelText: 'Categoria',
                                  labelStyle: TextStyle(color: AppColors.primary),
                                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                                ),
                                items: ['Geral', 'Casa', 'Trabalho', 'Outros'].map((String category) {
                                  return DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    cubit.updateTaskCategory(newValue);
                                  }
                                },
                              ),
                              const SizedBox(height: 12),
                              TextFormField(
                                initialValue: currentTask.descricao,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição',
                                  hintText: 'Ex: Ir ao mercado no sábado de manhã...',
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
                                    initialDate: currentTask.dataVencimento,
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
                                      'Data: ${currentTask.dataVencimento.day}/${currentTask.dataVencimento.month}/${currentTask.dataVencimento.year}',
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
                              if (currentTask.titulo.trim().isEmpty)
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    'O título é obrigatório para salvar.',
                                    style: TextStyle(color: AppColors.error, fontSize: 12),
                                  ),
                                ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (currentTask.titulo.trim().isEmpty) {
                                      setDialogState(() {});
                                      return;
                                    }
                                    cubit.saveSelectedTask();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Salvar e Fechar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static Future<void> showTaskDetailsDialog(BuildContext context, Task task, MenuAppCubit cubit) async {
    return showDialog(
      context: context,
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
        },
        child: BlocProvider.value(
          value: cubit,
          child: BlocBuilder<MenuAppCubit, MenuAppState>(
            builder: (context, state) {
              final currentTask = state.selectedTask ?? task;
              
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return Dialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close, color: AppColors.primary),
                                    onPressed: () => cubit.closeDialog(),
                                  ),
                                  const Text(
                                    'Detalhes da Tarefa',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: AppColors.primary),
                                    onPressed: () => cubit.showTaskEdit(currentTask),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 16),
                              if (currentTask.isImportante)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(alpha: 0.1),
                                      border: Border.all(color: AppColors.error),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'IMPORTANTE',
                                      style: TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              Text(
                                'ID: ${currentTask.id}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentTask.titulo,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onBackground,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                currentTask.descricao,
                                style: const TextStyle(fontSize: 16, color: AppColors.onBackground),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Data: ${currentTask.dataVencimento.day}/${currentTask.dataVencimento.month}/${currentTask.dataVencimento.year}',
                                    style: const TextStyle(fontSize: 14, color: AppColors.onBackground),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Concluir Tarefa',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onBackground,
                                    ),
                                  ),
                                  Switch(
                                    value: currentTask.isConcluido,
                                    activeThumbColor: AppColors.primary,
                                    onChanged: (value) => cubit.updateTaskStatus(value),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => cubit.saveSelectedTask(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Salvar e Fechar'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
