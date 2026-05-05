import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:list_app/components/item_list.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';

@RoutePage()
class MenuAppPage extends StatelessWidget {
  const MenuAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Menu App',
        actions: [
          IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
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
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ItemList(
                title: "Lista teste",
                isImportant: true,
              );
            }
          ),
        ),
      ],
    );
  }
}
