import '../../domain/entity/instructor_profile_ui_model.dart';

abstract class ProfileInstructorState {}

class ProfileInstructorInitial extends ProfileInstructorState {}

class ProfileInstructorLoading extends ProfileInstructorState {}

class ProfileInstructorLoaded extends ProfileInstructorState {
  final InstructorProfileUIModel profile;

  ProfileInstructorLoaded({required this.profile});
}

class ProfileInstructorError extends ProfileInstructorState {
  final String message;

  ProfileInstructorError({required this.message});
}

class ProfileInstructorUpdateSuccess extends ProfileInstructorState {
  final InstructorProfileUIModel profile;
  final String message;

  ProfileInstructorUpdateSuccess({
    required this.profile,
    required this.message,
  });
}
