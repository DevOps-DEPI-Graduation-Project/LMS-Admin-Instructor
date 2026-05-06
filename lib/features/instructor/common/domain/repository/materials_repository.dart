import 'package:dartz/dartz.dart';
import '../../data/model/materials_model/course_materials_response_model.dart';
import '../../data/model/materials_model/course_material_model.dart';
import '../../data/model/materials_model/upload_material_request_model.dart';

abstract class MaterialsRepository {
  Future<Either<String, CourseMaterialsResponseModel>> getCourseMaterials({
    required String slug,
    int? page,
    int? pageSize,
  });

  Future<Either<String, CourseMaterialModel>> uploadMaterial({
    required UploadMaterialRequestModel requestModel,
  });
}
