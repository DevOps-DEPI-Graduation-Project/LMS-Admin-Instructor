import '../../data/models/update_instructor_request_model.dart';

abstract class ProfileInstructorEvent {}

class GetProfileInstructorEvent extends ProfileInstructorEvent {
  final String slug;

  GetProfileInstructorEvent({required this.slug});
}

class UpdateProfileInstructorEvent extends ProfileInstructorEvent {
  final String slug;
  final UpdateInstructorRequestModel requestModel;

  UpdateProfileInstructorEvent({
    required this.slug,
    required this.requestModel,
  });
}
