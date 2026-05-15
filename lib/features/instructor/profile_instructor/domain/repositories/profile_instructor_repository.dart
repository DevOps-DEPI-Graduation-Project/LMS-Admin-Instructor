import 'package:dartz/dartz.dart';
import '../../data/models/instructor_profile_response_model.dart';

abstract class ProfileInstructorRepository {
  Future<Either<String, InstructorProfileResponseModel>> getInstructorProfile(
    String slug,
  );
}
