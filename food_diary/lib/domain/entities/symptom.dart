import 'package:equatable/equatable.dart';

class Symptom extends Equatable {
  final String id;
  final String name;
  final SeverityLevel severity;
  final DateTime occurredAt;
  final String? notes;
  final List<String> potentialTriggerIds; // Food entry IDs

  const Symptom({
    required this.id,
    required this.name,
    required this.severity,
    required this.occurredAt,
    this.notes,
    required this.potentialTriggerIds,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        severity,
        occurredAt,
        notes,
        potentialTriggerIds,
      ];
}

enum SeverityLevel { 
  mild, 
  moderate, 
  severe, 
  critical 
}

class SymptomType {
  static const List<String> common = [
    'Skin rash',
    'Itching',
    'Hives',
    'Swelling',
    'Stomach pain',
    'Nausea',
    'Vomiting',
    'Diarrhea',
    'Difficulty breathing',
    'Throat tightness',
    'Congestion',
    'Headache',
    'Fatigue',
    'Joint pain',
    'Other',
  ];
}