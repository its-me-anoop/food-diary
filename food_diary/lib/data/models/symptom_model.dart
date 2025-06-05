import '../../domain/entities/symptom.dart';

class SymptomModel extends Symptom {
  const SymptomModel({
    required super.id,
    required super.name,
    required super.severity,
    required super.occurredAt,
    super.notes,
    required super.potentialTriggerIds,
  });

  factory SymptomModel.fromEntity(Symptom symptom) {
    return SymptomModel(
      id: symptom.id,
      name: symptom.name,
      severity: symptom.severity,
      occurredAt: symptom.occurredAt,
      notes: symptom.notes,
      potentialTriggerIds: symptom.potentialTriggerIds,
    );
  }

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    return SymptomModel(
      id: json['id'],
      name: json['name'],
      severity: SeverityLevel.values[json['severity']],
      occurredAt: DateTime.parse(json['occurredAt']),
      notes: json['notes'],
      potentialTriggerIds: List<String>.from(json['potentialTriggerIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'severity': severity.index,
      'occurredAt': occurredAt.toIso8601String(),
      'notes': notes,
      'potentialTriggerIds': potentialTriggerIds,
    };
  }
}
