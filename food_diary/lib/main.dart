import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection.dart';
import 'presentation/blocs/food_entry/food_entry_bloc.dart';
import 'presentation/blocs/symptom/symptom_bloc.dart';
import 'presentation/pages/main_page.dart';
import 'presentation/pages/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  final prefs = await SharedPreferences.getInstance();
  final completed = prefs.getBool('onboarding_completed') ?? false;
  runApp(MyApp(onboardingCompleted: completed));
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;
  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Allergy Tracker',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (context) => FoodEntryBloc(
                  getEntriesByDate: getIt(),
                  addFoodEntry: getIt(),
                  updateFoodEntry: getIt(),
                  deleteFoodEntry: getIt(),
                ),
          ),
          BlocProvider(
            create:
                (context) => SymptomBloc(
                  getSymptomsByDate: getIt(),
                  addSymptom: getIt(),
                  updateSymptom: getIt(),
                  deleteSymptom: getIt(),
                ),
          ),
        ],
        child: onboardingCompleted ? const MainPage() : const OnboardingPage(),
      ),
    );
  }
}
