import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/domain/entity/instructor_profile_ui_model.dart';

class InstructorBioDetails extends StatelessWidget {
  final InstructorProfileUIModel instructor;
  const InstructorBioDetails({super.key, required this.instructor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                context.tr('bio_and_details'),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.1),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDetailItem(
                  context,
                  Icons.person_2_outlined,
                  context.tr('bio'),
                  instructor.bio,
                ),
                _buildDetailItem(
                  context,
                  Icons.notes_rounded,
                  context.tr('description'),
                  instructor.description,
                ),
                _buildDetailItem(
                  context,
                  Icons.auto_awesome_outlined,
                  context.tr('joined_at'),
                  instructor.createdAt,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 22.sp,
            color: context.colorScheme.primary.withValues(alpha: 0.6),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: context.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
