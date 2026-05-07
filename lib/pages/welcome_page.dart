import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:list_app/cubits/menu_app_cubit.dart';
import 'package:list_app/cubits/menu_app_state.dart';
import 'package:list_app/models/task.dart';
import 'package:list_app/theme/app_colors.dart';
import 'package:list_app/theme/router/router.gr.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool _isNavigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuAppCubit, MenuAppState>(
        builder: (context, state) {
          Task? urgentTask;
          final pendingTasks = state.tasks.where((t) => !t.isConcluido).toList();
          
          if (pendingTasks.isNotEmpty) {
            pendingTasks.sort((a, b) => a.dataVencimento.compareTo(b.dataVencimento));
            urgentTask = pendingTasks.first;
          }

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragUpdate: (details) {
              if (!_isNavigating && details.primaryDelta != null && details.primaryDelta! < -10) {
                _isNavigating = true;
                context.router.push(const MenuAppRoute()).then((_) {
                  _isNavigating = false;
                });
              }
            },
            onVerticalDragEnd: (details) {
              if (!_isNavigating && details.primaryVelocity != null && details.primaryVelocity! < -200) {
                _isNavigating = true;
                context.router.push(const MenuAppRoute()).then((_) {
                  _isNavigating = false;
                });
              }
            },
            child: Container(
              width: double.infinity,
              color: AppColors.primary,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Text(
                          'Bem-vindo!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          if (urgentTask != null)
                            _buildUrgentTaskCard(urgentTask)
                          else if (state.isLoading)
                            const CircularProgressIndicator(color: Colors.white)
                          else
                            const Text(
                              'Você não tem tarefas pendentes!',
                              style: TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          const SizedBox(height: 50),
                          _buildSwipeIndicator(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSwipeIndicator() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.keyboard_arrow_up_rounded,
            color: Colors.white70,
            size: 32,
          ),
          Text(
            'Arraste para cima para ver tudo',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTaskCard(Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 28),
              const SizedBox(width: 8),
              Text(
                'Tarefa Mais Urgente',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              task.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                'Vence em: ${task.dataVencimento.day}/${task.dataVencimento.month}/${task.dataVencimento.year}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (task.isImportante)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error),
                ),
                child: const Text(
                  'IMPORTANTE',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
