import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/symptom.dart';
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
        title: Text(widget.symptomToEdit == null ? 'Add Symptom' : 'Edit Symptom'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Symptom name'),
              validator: (v) => v == null || v.isEmpty ? 'Enter symptom' : null,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<SeverityLevel>(
              value: _severity,
              decoration: const InputDecoration(labelText: 'Severity'),
              items: SeverityLevel.values
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _severity = val!),
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
}
