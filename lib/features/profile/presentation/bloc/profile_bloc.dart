import 'package:eduera_student/features/profile/domain/models/student_model.dart';
import 'package:eduera_student/features/profile/domain/repository/student_repository.dart';
import 'package:eduera_student/features/profile/presentation/bloc/profile_event.dart';
import 'package:eduera_student/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StudentRepository studentRepository;

  ProfileBloc(this.studentRepository) : super(ProfileInitial()) {
    on<LoadStudentProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final student = await studentRepository.getStudentById(event.studentId);
        if (student != null) {
          emit(ProfileLoaded(student));
        } else {
          emit(ProfileError("Student not found"));
        }
      } catch (e) {
        emit(ProfileError("Failed to load profile: $e"));
      }
    });

    on<ListenToStudentProfile>((event, emit) async {
      emit(ProfileLoading());
      await emit.forEach<StudentModel>(
        studentRepository.getStudentStream(event.userId),
        onData: (student) => ProfileLoaded(student),
        onError: (_, _) => ProfileError("Failed to listen to profile"),
      );
    });
  }
}
