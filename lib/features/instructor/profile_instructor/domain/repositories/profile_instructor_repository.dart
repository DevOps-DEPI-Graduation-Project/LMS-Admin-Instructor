import 'package:dartz/dartz.dart';
import '../../data/models/instructor_profile_response_model.dart';
import '../../data/models/update_instructor_request_model.dart';

abstract class ProfileInstructorRepository {
  Future<Either<String, InstructorProfileResponseModel>> getInstructorProfile(
    String slug,
  );

  Future<Either<String, InstructorProfileResponseModel>> updateInstructorProfile({
    required String slug,
    required UpdateInstructorRequestModel requestModel,
  });
}
