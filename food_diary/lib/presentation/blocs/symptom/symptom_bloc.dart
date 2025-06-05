import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/add_symptom.dart';
import '../../../domain/usecases/delete_symptom.dart';
import '../../../domain/usecases/get_symptoms_by_date.dart';
import '../../../domain/usecases/update_symptom.dart';
import 'symptom_event.dart';
import 'symptom_state.dart';

class SymptomBloc extends Bloc<SymptomEvent, SymptomState> {
  final GetSymptomsByDate getSymptomsByDate;
  final AddSymptom addSymptom;
  final UpdateSymptom updateSymptom;
  final DeleteSymptom deleteSymptom;

  SymptomBloc({
    required this.getSymptomsByDate,
    required this.addSymptom,
    required this.updateSymptom,
    required this.deleteSymptom,
  }) : super(SymptomInitial()) {
    on<LoadSymptomsByDate>(_onLoad);
    on<AddSymptomEvent>(_onAdd);
    on<UpdateSymptomEvent>(_onUpdate);
    on<DeleteSymptomEvent>(_onDelete);
  }

  Future<void> _onLoad(
    LoadSymptomsByDate event,
    Emitter<SymptomState> emit,
  ) async {
    emit(SymptomLoading());
    try {
      final symptoms = await getSymptomsByDate(event.date);
      emit(SymptomLoaded(symptoms: symptoms, selectedDate: event.date));
    } catch (e) {
      emit(SymptomError(e.toString()));
    }
  }

  Future<void> _onAdd(
    AddSymptomEvent event,
    Emitter<SymptomState> emit,
  ) async {
    try {
      await addSymptom(event.symptom);
      if (state is SymptomLoaded) {
        final current = state as SymptomLoaded;
        add(LoadSymptomsByDate(current.selectedDate));
      }
    } catch (e) {
      emit(SymptomError(e.toString()));
    }
  }

  Future<void> _onUpdate(
    UpdateSymptomEvent event,
    Emitter<SymptomState> emit,
  ) async {
    try {
      await updateSymptom(event.symptom);
      if (state is SymptomLoaded) {
        final current = state as SymptomLoaded;
        add(LoadSymptomsByDate(current.selectedDate));
      }
    } catch (e) {
      emit(SymptomError(e.toString()));
    }
  }

  Future<void> _onDelete(
    DeleteSymptomEvent event,
    Emitter<SymptomState> emit,
  ) async {
    try {
      await deleteSymptom(event.id);
      if (state is SymptomLoaded) {
        final current = state as SymptomLoaded;
        add(LoadSymptomsByDate(current.selectedDate));
      }
    } catch (e) {
      emit(SymptomError(e.toString()));
    }
  }
}
