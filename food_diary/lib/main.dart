import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection.dart';
import 'presentation/blocs/food_entry/food_entry_bloc.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allergy Tracker',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => FoodEntryBloc(
          getEntriesByDate: getIt(),
          addFoodEntry: getIt(),
          updateFoodEntry: getIt(),
          deleteFoodEntry: getIt(),
        ),
        child: const MainPage(),
      ),
    );
  }
}