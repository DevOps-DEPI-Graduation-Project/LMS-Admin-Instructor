abstract class ProfileInstructorEvent {}

class GetProfileInstructorEvent extends ProfileInstructorEvent {
  final String slug;

  GetProfileInstructorEvent({required this.slug});
}
