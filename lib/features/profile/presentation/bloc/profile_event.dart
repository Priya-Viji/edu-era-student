import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentProfile extends ProfileEvent {
  final String studentId;
  const LoadStudentProfile(this.studentId);

  @override
  List<Object?> get props => [studentId];
}
class ListenToStudentProfile extends ProfileEvent {
  final String userId;
  const ListenToStudentProfile(this.userId);
}
class UpdateStudentProfile extends ProfileEvent {
  final String name;
  final String phone;
  final DateTime? dob;
  final String? gender;
  final String? education;

  const UpdateStudentProfile({
    required this.name,
    required this.phone,
    this.dob,
    this.gender,
    this.education,
  });
}

