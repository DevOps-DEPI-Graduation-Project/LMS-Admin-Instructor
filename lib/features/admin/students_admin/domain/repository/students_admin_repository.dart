import 'package:dartz/dartz.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/data/model/students_admin_response_model.dart';

abstract class StudentsAdminRepository {
  Future<Either<String, StudentsAdminResponseModel>> getStudentsAdmin({
    int? page,
    int? pageSize,
    String? search,
  });

  Future<Either<String, Unit>> deleteStudent(String slug);
}
