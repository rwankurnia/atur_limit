import 'package:atur_limit/theme/theme.dart';
import 'package:atur_limit/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'providers/budget_provider.dart';
import 'screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  final themeCubit = ThemeCubit()..init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => BudgetProvider(),
      child: MyApp(themeCubit: themeCubit),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeCubit themeCubit;

  const MyApp({super.key, required this.themeCubit});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => themeCubit,
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Atur Limit',
            themeMode: state,
            theme: lightTheme,
            darkTheme: darkTheme,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}