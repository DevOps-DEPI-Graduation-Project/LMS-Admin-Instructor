import 'package:lms_admin_instructor/features/instructor/common/data/model/materials_model/upload_material_request_model.dart';

abstract class CourseMaterialsEvent {}

class GetCourseMaterialsEvent extends CourseMaterialsEvent {
  final String slug;
  final int? page;
  final int? pageSize;

  GetCourseMaterialsEvent({
    required this.slug,
    this.page,
    this.pageSize,
  });
}

class UploadMaterialEvent extends CourseMaterialsEvent {
  final UploadMaterialRequestModel requestModel;

  UploadMaterialEvent({required this.requestModel});
}
