import 'package:flutter/material.dart';
import 'package:list_app/theme/app_colors.dart';

class ItemList extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final bool isImportant;
  final bool isDone;

  const ItemList({
    super.key,
    required this.title,
    this.backgroundColor,
    this.isImportant = false,
    this.isDone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: AppColors.onBackground, width: 2),
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  if (isImportant)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.error),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'IMPORTANTE',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}