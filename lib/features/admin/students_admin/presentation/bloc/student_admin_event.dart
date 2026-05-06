class StudentAdminEvent {}

class GetStudentsAdminEvent extends StudentAdminEvent {
  final int? page;
  final int? pageSize;
  final String? search;
  GetStudentsAdminEvent({this.page, this.pageSize, this.search});
}

class DeleteStudentAdminEvent extends StudentAdminEvent {
  final String slug;
  DeleteStudentAdminEvent({required this.slug});
}