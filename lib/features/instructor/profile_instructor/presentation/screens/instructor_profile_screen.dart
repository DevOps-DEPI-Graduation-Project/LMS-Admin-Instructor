import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_state.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_bio_details.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_profile_header.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_social_media.dart';

class InstructorProfileScreen extends StatelessWidget {
  const InstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.isDesktop ? 64.w : 8.w,
          ),
          child: InkWell(
            onTap: () => context.pop(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios_new,
                  size: 16.sp,
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 8.w),
                Text(
                  context.tr('back'),
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: context.isDesktop ? 80.h : 60.h,
      ),
      body: BlocBuilder<ProfileInstructorBloc, ProfileInstructorState>(
        builder: (context, state) {
          if (state is ProfileInstructorLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileInstructorError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileInstructorLoaded) {
            final instructor = state.profile;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: context.isDesktop ? 80.w : 20.w,
                vertical: 40.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (context.isDesktop)
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InstructorProfileHeader(
                              instructor: instructor,
                            ),
                          ),
                          SizedBox(width: 32.w),
                          Expanded(
                            flex: 2,
                            child: InstructorBioDetails(
                              instructor: instructor,
                              expand: true,
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    InstructorProfileHeader(instructor: instructor),
                    SizedBox(height: 32.h),
                    InstructorBioDetails(instructor: instructor),
                  ],
                  SizedBox(height: 32.h),
                  InstructorSocialMedia(
                    key: ValueKey('social_${instructor.links.length}'),
                    links: instructor.links,
                    slug: instructor.slug,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
