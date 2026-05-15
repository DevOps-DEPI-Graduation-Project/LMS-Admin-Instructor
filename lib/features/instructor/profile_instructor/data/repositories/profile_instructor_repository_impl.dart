import 'package:dartz/dartz.dart';
import 'package:lms_admin_instructor/core/services/remote/api_consumer.dart';
import 'package:lms_admin_instructor/core/services/remote/endpoints.dart';
import '../models/instructor_profile_response_model.dart';
import '../models/update_instructor_request_model.dart';
import '../models/create_link_request_model.dart';
import '../../domain/repositories/profile_instructor_repository.dart';

class ProfileInstructorRepositoryImpl implements ProfileInstructorRepository {
  final ApiConsumer apiConsumer;

  ProfileInstructorRepositoryImpl({required this.apiConsumer});

  @override
  Future<Either<String, InstructorProfileResponseModel>> getInstructorProfile(
    String slug,
  ) async {
    return await apiConsumer.get<InstructorProfileResponseModel>(
      EndPoint.getInstructorBySlug(slug),
      fromJson: (json) => InstructorProfileResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, InstructorProfileResponseModel>> updateInstructorProfile({
    required String slug,
    required UpdateInstructorRequestModel requestModel,
  }) async {
    return await apiConsumer.patch<InstructorProfileResponseModel>(
      EndPoint.updateInstructor(slug),
      data: requestModel.toJson(),
      fromJson: (json) => InstructorProfileResponseModel.fromJson(json),
    );
  }

  @override
  Future<Either<String, List<InstructorLinkModel>>> getInstructorLinks(
    String slug,
  ) async {
    return await apiConsumer.get<List<InstructorLinkModel>>(
      EndPoint.getInstructorLinks(slug),
      fromJson: (json) =>
          (json as List).map((e) => InstructorLinkModel.fromJson(e)).toList(),
    );
  }

  @override
  Future<Either<String, InstructorLinkModel>> addInstructorLink({
    required String slug,
    required CreateLinkRequestModel requestModel,
  }) async {
    return await apiConsumer.post<InstructorLinkModel>(
      EndPoint.addInstructorLink(slug),
      data: requestModel.toJson(),
      fromJson: (json) => InstructorLinkModel.fromJson(json),
    );
  }
}
