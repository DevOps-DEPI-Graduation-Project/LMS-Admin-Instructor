import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/routing/app_routes.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/domain/entity/course_materials_ui_model.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_details_bloc/course_details_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_details_bloc/course_details_event.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_stats_bloc/course_stats_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_stats_bloc/course_stats_event.dart';
import 'package:lms_admin_instructor/features/instructor/manage_materials_instructor/presentation/bloc/course_material_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/manage_materials_instructor/presentation/bloc/course_material_event.dart';
import 'package:lms_admin_instructor/features/instructor/manage_materials_instructor/presentation/bloc/course_material_state.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/screens/widgets/course_material_section/custom_course_sidebar.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';

class CourseMaterialSection extends StatelessWidget {
  final String slug;
  final String courseName;
  const CourseMaterialSection({
    super.key,
    required this.slug,
    required this.courseName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseMaterialsBloc, CourseMaterialsState>(
      builder: (context, state) {
        return CustomCourseSidebar(
          title: context.tr('course_materials'),
          icon: Icons.folder_outlined,
          color: context.colorScheme.primary,
          onManage: () async {
            final result = await context.pushNamed<bool>(
              AppRoutes.courseMaterials,
              pathParameters: {'slug': slug},
              extra: courseName,
            );

            if (result == true && context.mounted) {
              _refreshData(context);
            }
          },
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
                ...state.materialsListUIModel.materials
                    .take(3)
                    .map((material) => _buildMaterialItem(context, material)),
              SizedBox(height: 16.h),
              CustomPrimaryButton(
                onTap: () async {
                  final result = await context.pushNamed<bool>(
                    AppRoutes.courseMaterials,
                    pathParameters: {'slug': slug},
                    extra: courseName,
                  );

                  if (result == true && context.mounted) {
                    _refreshData(context);
                  }
                },
                text: context.tr('show_more'),
                width: double.infinity,
                height: 45.h,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  side: BorderSide(
                    color: context.colorScheme.onSecondary.withValues(
                      alpha: .2,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                textStyle: context.textTheme.labelLarge?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
              ),
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

  void _refreshData(BuildContext context) {
    context.read<CourseDetailsBloc>().add(GetCourseDetailsEvent(slug: slug));
    context.read<CourseStatsBloc>().add(GetCourseStatsEvent(slug: slug));
    context.read<CourseMaterialsBloc>().add(
      GetCourseMaterialsEvent(slug: slug),
    );
  }
}
