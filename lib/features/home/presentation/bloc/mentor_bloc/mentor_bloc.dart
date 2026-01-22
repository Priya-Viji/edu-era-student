import 'package:eduera_student/features/home/data/models/mentor_model.dart';
import 'package:eduera_student/features/home/data/repositories/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// EVENTS
abstract class MentorEvent {}

class LoadMentorsEvent extends MentorEvent {} // ✅ all mentors

class LoadMentorEvent extends MentorEvent {
  //  single mentor
  final String mentorId;
  LoadMentorEvent(this.mentorId);
}

/// STATES
abstract class MentorState {}

class MentorInitial extends MentorState {}

class MentorLoading extends MentorState {}

class MentorsSuccess extends MentorState {
  //  list state
  final List<MentorModel> mentors;
  MentorsSuccess(this.mentors);
}

class MentorSuccess extends MentorState {
  //  single state
  final MentorModel mentor;
  MentorSuccess(this.mentor);
}

class MentorError extends MentorState {
  final String message;
  MentorError(this.message);
}

/// BLOC
class MentorBloc extends Bloc<MentorEvent, MentorState> {
  final HomeRepository repository;

  MentorBloc(this.repository) : super(MentorInitial()) {
    on<LoadMentorsEvent>(_onLoadMentors);
    on<LoadMentorEvent>(_onLoadMentor);
  }

  Future<void> _onLoadMentors(
    LoadMentorsEvent event,
    Emitter<MentorState> emit,
  ) async {
    emit(MentorLoading());
    try {
      final mentors = await repository.fetchMentors(); // ✅ List<MentorModel>
      emit(MentorsSuccess(mentors));
    } catch (e) {
      emit(MentorError('Failed to load mentors: $e'));
    }
  }

  Future<void> _onLoadMentor(
    LoadMentorEvent event,
    Emitter<MentorState> emit,
  ) async {
    emit(MentorLoading());
    try {
      final mentor = await repository.fetchMentorById(event.mentorId);
      // ✅ implement fetchMentorById in HomeRepository
      emit(MentorSuccess(mentor));
    } catch (e) {
      emit(MentorError('Failed to load mentor: $e'));
    }
  }
}
