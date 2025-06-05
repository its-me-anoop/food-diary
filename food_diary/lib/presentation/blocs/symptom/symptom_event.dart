import 'package:equatable/equatable.dart';
import '../../../domain/entities/symptom.dart';

abstract class SymptomEvent extends Equatable {
  const SymptomEvent();
  @override
  List<Object?> get props => [];
}

class LoadSymptomsByDate extends SymptomEvent {
  final DateTime date;
  const LoadSymptomsByDate(this.date);
  @override
  List<Object?> get props => [date];
}

class AddSymptomEvent extends SymptomEvent {
  final Symptom symptom;
  const AddSymptomEvent(this.symptom);
  @override
  List<Object?> get props => [symptom];
}

class UpdateSymptomEvent extends SymptomEvent {
  final Symptom symptom;
  const UpdateSymptomEvent(this.symptom);
  @override
  List<Object?> get props => [symptom];
}

class DeleteSymptomEvent extends SymptomEvent {
  final String id;
  const DeleteSymptomEvent(this.id);
  @override
  List<Object?> get props => [id];
}
