import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/symptom.dart';
import 'package:intl/intl.dart';
import '../blocs/symptom/symptom_bloc.dart';
import '../blocs/symptom/symptom_event.dart';
import '../theme/app_theme.dart';

class AddSymptomPage extends StatefulWidget {
  final DateTime selectedDate;
  final Symptom? symptomToEdit;
  const AddSymptomPage({
    super.key,
    required this.selectedDate,
    this.symptomToEdit,
  });

  @override
  State<AddSymptomPage> createState() => _AddSymptomPageState();
}

class _AddSymptomPageState extends State<AddSymptomPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  SeverityLevel _severity = SeverityLevel.mild;
  late DateTime _occurredAt;
  final List<String> _commonSymptoms = SymptomType.common;

  @override
  void initState() {
    super.initState();
    _occurredAt = widget.selectedDate;
    if (widget.symptomToEdit != null) {
      final s = widget.symptomToEdit!;
      _nameController.text = s.name;
      _notesController.text = s.notes ?? '';
      _severity = s.severity;
      _occurredAt = s.occurredAt;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.symptomToEdit == null ? 'Add Symptom' : 'Edit Symptom',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Autocomplete<String>(
              optionsBuilder: (text) {
                if (text.text.isEmpty) return _commonSymptoms;
                return _commonSymptoms.where(
                  (s) => s.toLowerCase().contains(text.text.toLowerCase()),
                );
              },
              onSelected: (val) => _nameController.text = val,
              fieldViewBuilder: (
                context,
                controller,
                focusNode,
                onFieldSubmitted,
              ) {
                controller.text = _nameController.text;
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: const InputDecoration(hintText: 'Symptom name'),
                  validator:
                      (v) => v == null || v.isEmpty ? 'Enter symptom' : null,
                  onChanged: (val) => _nameController.text = val,
                );
              },
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<SeverityLevel>(
              value: _severity,
              decoration: const InputDecoration(labelText: 'Severity'),
              items:
                  SeverityLevel.values
                      .map(
                        (e) => DropdownMenuItem(value: e, child: Text(e.name)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _severity = val!),
            ),
            const SizedBox(height: 24),
            ListTile(
              tileColor: Colors.grey.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              title: const Text('When did it occur?'),
              subtitle: Text(DateFormat('MMM d, h:mm a').format(_occurredAt)),
              trailing: const Icon(Icons.schedule),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(hintText: 'Notes'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(widget.symptomToEdit == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final symptom = Symptom(
        id: widget.symptomToEdit?.id ?? const Uuid().v4(),
        name: _nameController.text,
        severity: _severity,
        occurredAt: _occurredAt,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        potentialTriggerIds: const [],
      );
      final bloc = context.read<SymptomBloc>();
      if (widget.symptomToEdit == null) {
        bloc.add(AddSymptomEvent(symptom));
      } else {
        bloc.add(UpdateSymptomEvent(symptom));
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
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
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_occurredAt),
      );
      if (time != null && mounted) {
        setState(() {
          _occurredAt = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }
}
