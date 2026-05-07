import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';
import 'theme/router/router.dart';
import 'theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubits/menu_app_cubit.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuAppCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'List App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
            error: AppColors.error,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
        ),
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
