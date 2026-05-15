import '../../data/models/update_instructor_request_model.dart';
import '../../data/models/create_link_request_model.dart';

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

class GetInstructorLinksEvent extends ProfileInstructorEvent {
  final String slug;

  GetInstructorLinksEvent({required this.slug});
}

class AddInstructorLinkEvent extends ProfileInstructorEvent {
  final String slug;
  final CreateLinkRequestModel requestModel;

  AddInstructorLinkEvent({
    required this.slug,
    required this.requestModel,
  });
}
