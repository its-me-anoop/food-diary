import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animations/animations.dart';
import '../theme/app_theme.dart';
import '../blocs/food_entry/food_entry_bloc.dart';
import 'home_page.dart';
import 'symptoms_page.dart';
import 'analysis_page.dart';
import 'profile_page.dart';
import 'add_food_entry_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabScaleAnimation;
  late FoodEntryBloc _foodEntryBloc;

  Widget _buildCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return BlocProvider.value(
          value: _foodEntryBloc,
          child: const HomePage(),
        );
      case 1:
        return const SymptomsPage();
      case 2:
        return const AnalysisPage();
      case 3:
        return const ProfilePage();
      default:
        return BlocProvider.value(
          value: _foodEntryBloc,
          child: const HomePage(),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeOutBack,
    ));
    _fabAnimationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _foodEntryBloc = context.read<FoodEntryBloc>();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _fabAnimationController.reverse().then((_) {
      _fabAnimationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _buildCurrentPage(),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabScaleAnimation,
        child: _buildFloatingActionButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _foodEntryBloc,
                child: AddFoodEntryPage(selectedDate: DateTime.now()),
              ),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, size: 28),
        label: const Text('Add Meal'),
        elevation: 4,
      );
    } else if (_selectedIndex == 1) {
      return FloatingActionButton.extended(
        onPressed: () {
          // Navigate to add symptom
          Navigator.pushNamed(context, '/add-symptom');
        },
        backgroundColor: AppTheme.warningColor,
        icon: const Icon(Icons.add_alert, size: 28),
        label: const Text('Log Symptom'),
        elevation: 4,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildNavItem(Icons.restaurant_menu, 'Meals', 0),
                _buildNavItem(Icons.warning_amber_rounded, 'Symptoms', 1),
                const SizedBox(width: 80), // Space for FAB
                _buildNavItem(Icons.analytics_outlined, 'Analysis', 2),
                _buildNavItem(Icons.person_outline, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? AppTheme.primaryColor : Colors.grey.shade600;

    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 56, // Fixed height to prevent overflow
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Icon(
                    icon,
                    color: color,
                    size: 18,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 8,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}