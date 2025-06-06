import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_symptom_card.dart';
import '../../domain/entities/symptom.dart';
import 'add_symptom_page.dart';
import '../blocs/symptom/symptom_bloc.dart';
import '../blocs/symptom/symptom_event.dart';
import '../blocs/symptom/symptom_state.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime.now();
  late AnimationController _animationController;
  late SymptomBloc _symptomBloc;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _symptomBloc = context.read<SymptomBloc>();
    _symptomBloc.add(LoadSymptomsByDate(selectedDate));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDateSelector(),
            _buildSeverityFilter(),
            Expanded(child: _buildSymptomsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Symptom Tracker',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor your reactions',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _changeDate(-1),
            style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
          ),
          GestureDetector(
            onTap: _selectDate,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                DateFormat('EEEE, MMMM d').format(selectedDate),
                key: ValueKey(selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _changeDate(1),
            style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100),
          ),
        ],
      ),
    );
  }

  Widget _buildSeverityFilter() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          _buildFilterChip('All', true),
          const SizedBox(width: 8),
          _buildSeverityChip(SeverityLevel.mild),
          const SizedBox(width: 8),
          _buildSeverityChip(SeverityLevel.moderate),
          const SizedBox(width: 8),
          _buildSeverityChip(SeverityLevel.severe),
          const SizedBox(width: 8),
          _buildSeverityChip(SeverityLevel.critical),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {},
      backgroundColor: Colors.grey.shade100,
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildSeverityChip(SeverityLevel severity) {
    final color = AppTheme.getSeverityColor(severity);
    return FilterChip(
      label: Text(
        severity.name.substring(0, 1).toUpperCase() +
            severity.name.substring(1),
      ),
      selected: false,
      onSelected: (selected) {},
      backgroundColor: color.withOpacity(0.1),
      avatar: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }

  Widget _buildSymptomsList() {
    return BlocBuilder<SymptomBloc, SymptomState>(
      builder: (context, state) {
        if (state is SymptomLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Symptom> symptoms = [];
        if (state is SymptomLoaded) {
          symptoms = state.symptoms;
        }

        if (symptoms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'No symptoms recorded today',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "That's great news!",
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 100),
            itemCount: symptoms.length,
            itemBuilder: (context, index) {
              final symptom = symptoms[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: AnimatedSymptomCard(
                      symptom: symptom,
                      onEdit: () => _navigateToEditSymptom(context, symptom),
                      onDelete: () => _deleteSymptom(context, symptom.id),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _changeDate(int days) {
    setState(() {
      selectedDate = selectedDate.add(Duration(days: days));
    });
    _symptomBloc.add(LoadSymptomsByDate(selectedDate));
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate && mounted) {
      setState(() {
        selectedDate = picked;
      });
      _symptomBloc.add(LoadSymptomsByDate(selectedDate));
    }
  }

  void _navigateToEditSymptom(BuildContext context, Symptom symptom) {
    final bloc = context.read<SymptomBloc>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: bloc,
              child: AddSymptomPage(
                selectedDate: selectedDate,
                symptomToEdit: symptom,
              ),
            ),
      ),
    );
  }

  void _deleteSymptom(BuildContext context, String id) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Symptom'),
            content: const Text(
              'Are you sure you want to delete this symptom?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _symptomBloc.add(DeleteSymptomEvent(id));
                  Navigator.of(ctx).pop();
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
