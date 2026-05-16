import '../../data/models/update_instructor_request_model.dart';
import '../../data/models/create_link_request_model.dart';
import '../../data/models/update_link_request_model.dart';

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

class UpdateInstructorLinkEvent extends ProfileInstructorEvent {
  final String linkSlug;
  final UpdateLinkRequestModel requestModel;

  UpdateInstructorLinkEvent({
    required this.linkSlug,
    required this.requestModel,
  });
}

class DeleteInstructorLinkEvent extends ProfileInstructorEvent {
  final String linkSlug;
  final String instructorSlug;

  DeleteInstructorLinkEvent({
    required this.linkSlug,
    required this.instructorSlug,
  });
}
