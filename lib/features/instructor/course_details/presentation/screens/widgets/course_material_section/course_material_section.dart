import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/app_routes.dart'
    show AppRoutes;
import 'package:lms_admin_instructor/features/instructor/course_details/domain/entity/course_materials_ui_model.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_event.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_state.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/screens/widgets/course_material_section/custom_course_sidebar.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';
import 'upload_material_dialog.dart';

class CourseMaterialSection extends StatelessWidget {
  final String slug;
  const CourseMaterialSection({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseMaterialsBloc, CourseMaterialsState>(
      builder: (context, state) {
        return CustomCourseSidebar(
          title: context.tr('course_materials'),
          icon: Icons.folder_outlined,
          color: context.colorScheme.primary,
          onManage: () {},
          children: [
            if (state is CourseMaterialsLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state is CourseMaterialsError)
              Center(child: Text(state.message))
            else if (state is CourseMaterialsLoaded) ...[
              if (state.materialsListUIModel.materials.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Center(
                    child: Text(
                      context.tr('no_materials_found'),
                      style: context.textTheme.labelMedium,
                    ),
                  ),
                )
              else
                ...state.materialsListUIModel.materials.map(
                  (material) => _buildMaterialItem(context, material),
                ),
              SizedBox(height: 16.h),
              _buildUploadButton(context, context.tr('upload_new_material')),
            ] else
              const SizedBox(),
          ],
        );
      },
    );
  }

  Widget _buildMaterialItem(
    BuildContext context,
    CourseMaterialItemUIModel material,
  ) {
    return InkWell(
      onTap: () {
        if (material.file != null) {
          context.pushNamed(
            AppRoutes.pdfViewer,
            extra: {'url': material.file, 'title': material.materialName},
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.picture_as_pdf,
              size: 20.sp,
              color: context.colorScheme.secondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    material.materialName,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    material.fileSize ?? '',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14.sp,
              color: context.colorScheme.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton(BuildContext context, String text) {
    return CustomPrimaryButton(
      onTap: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<CourseMaterialsBloc>(),
            child: UploadMaterialDialog(courseSlug: slug),
          ),
        );

        if (result == true && context.mounted) {
          context.read<CourseMaterialsBloc>().add(
            GetCourseMaterialsEvent(slug: slug),
          );
        }
      },
      text: text,
      prefixIcon: Icon(
        Icons.upload_file,
        size: 18.sp,
        color: context.colorScheme.primary,
      ),
      width: double.infinity,
      height: 45.h,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        side: BorderSide(
          color: context.colorScheme.primary.withValues(alpha: 0.5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      textStyle: context.textTheme.labelLarge?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: context.colorScheme.primary,
      ),
    );
  }
}
