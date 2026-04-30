import 'package:flutter/material.dart';
import 'package:list_app/theme/app_colors.dart';
import 'custom_button.dart';

class ItemList {
  final String name;
  final Color? backgroundColor;

  ItemList({
    required this.name,
    this.backgroundColor,
  });

  build() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.onBackground, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: CustomButton(
          title: 'Adicionar',
          icon: Icons.add,
          backgroundColor: AppColors.secondaryVariant,
          onPressed: () {},
        ),
      ),
    );
  }
}