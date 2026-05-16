import 'package:dartz/dartz.dart';
import 'package:lms_admin_instructor/features/students/data/model/students_response_model.dart';

abstract class StudentsRepository {
  Future<Either<String, StudentsResponseModel>> getStudents({
    int? page,
    int? pageSize,
  });

  Future<Either<String, Unit>> deleteStudent(String slug);
}
