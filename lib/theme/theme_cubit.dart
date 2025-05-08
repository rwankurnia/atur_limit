import 'package:atur_limit/theme/theme_local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeMode> {

  final ThemeLocalStorage themeLocalStorage;

  ThemeCubit(
    this.themeLocalStorage,
  ) : super(ThemeMode.light);

  void init() {
    final theme = themeLocalStorage.getTheme();
    emit(theme);
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      themeLocalStorage.setTheme(ThemeMode.dark);
      emit(ThemeMode.dark);
    } else {
      themeLocalStorage.setTheme(ThemeMode.light);
      emit(ThemeMode.light);
    }
  }

}