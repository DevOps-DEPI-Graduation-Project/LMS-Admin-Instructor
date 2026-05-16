class StudentEvent {}

class GetStudentsEvent extends StudentEvent {
  final int? page;
  final int? pageSize;
  GetStudentsEvent({this.page, this.pageSize});
}

class DeleteStudentEvent extends StudentEvent {
  final String slug;
  DeleteStudentEvent({required this.slug});
}
