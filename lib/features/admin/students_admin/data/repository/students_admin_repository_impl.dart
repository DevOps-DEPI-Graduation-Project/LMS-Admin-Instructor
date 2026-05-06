import 'package:dartz/dartz.dart';
import 'package:lms_admin_instructor/core/services/remote/api_consumer.dart';
import 'package:lms_admin_instructor/core/services/remote/endpoints.dart';
import 'package:lms_admin_instructor/core/utils/api_query_params.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/data/model/students_admin_response_model.dart';
import 'package:lms_admin_instructor/features/admin/students_admin/domain/repository/students_admin_repository.dart';

class StudentsAdminRepositoryImpl implements StudentsAdminRepository {
  final ApiConsumer apiConsumer;

  StudentsAdminRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, StudentsAdminResponseModel>> getStudentsAdmin({
    int? page,
    int? pageSize,
    String? search,
  }) async {
    return await apiConsumer.get<StudentsAdminResponseModel>(
      EndPoint.studentsAdmin,
      queryParameters: ApiQueryParams.pagination(
        page: page,
        pageSize: pageSize,
        search: search,
      ),
      fromJson: (json) => StudentsAdminResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, Unit>> deleteStudent(String slug) async {
    return await apiConsumer.delete<Unit>(
      EndPoint.deleteStudentAdmin(slug),
      fromJson: (json) => unit,
    );
  }
}
