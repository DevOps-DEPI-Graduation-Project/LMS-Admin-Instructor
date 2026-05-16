import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_admin_instructor/features/students/domain/repository/students_repository.dart';

part 'student_details_event.dart';
part 'student_details_state.dart';

class StudentDetailsBloc extends Bloc<StudentDetailsEvent, StudentDetailsState> {
  final StudentsRepository studentsRepository;
  StudentDetailsBloc({required this.studentsRepository})
    : super(StudentDetailsInitial()) {
    on<StudentDetailsEvent>(_onEvent);
  }

  void _onEvent(StudentDetailsEvent event, Emitter<StudentDetailsState> emit) {
    emit(StudentDetailsInitial());
  }
}
