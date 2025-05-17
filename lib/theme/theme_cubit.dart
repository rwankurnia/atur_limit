import 'package:atur_limit/utils/shared_prefs_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  Future<void> init() async {
    final theme = await SharedPrefsHelper.getTheme();
    emit(theme);
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.light) {
      await SharedPrefsHelper.setTheme(ThemeMode.dark);
      emit(ThemeMode.dark);
    } else {
      await SharedPrefsHelper.setTheme(ThemeMode.light);
      emit(ThemeMode.light);
    }
  }
}