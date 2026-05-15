import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/domain/entity/instructor_profile_ui_model.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_profile_header.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_bio_details.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/screens/widgets/instructor_social_media.dart';

class InstructorProfileScreen extends StatelessWidget {
  const InstructorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration
    final dummyInstructor = InstructorProfileUIModel(
      firstName: "Maria",
      lastName: "Fernanda",
      email: "maria.fernanda@example.com",
      slug: "maria-fernanda",
      bio: "Senior UI/UX Designer & Instructor",
      description:
          "Passionated about creating beautiful and functional user interfaces. Over 10 years of experience in the industry, working with top brands and startups.",
      image: "https://via.placeholder.com/300",
      links: [
        InstructorLinkUIModel(
          slug: "1",
          platformName: "YouTube",
          url: "https://youtube.com",
        ),
        InstructorLinkUIModel(
          slug: "2",
          platformName: "Instagram",
          url: "https://instagram.com",
        ),
        InstructorLinkUIModel(
          slug: "3",
          platformName: "TikTok",
          url: "https://tiktok.com",
        ),
        InstructorLinkUIModel(
          slug: "4",
          platformName: "Facebook",
          url: "https://facebook.com",
        ),
      ],
      createdAt: "2024-01-01",
    );

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.isDesktop ? 80.w : 20.w,
          vertical: 40.h,
        ),
        child: Column(
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
                        instructor: dummyInstructor,
                      ),
                    ),
                    SizedBox(width: 32.w),
                    Expanded(
                      flex: 2,
                      child: InstructorBioDetails(instructor: dummyInstructor),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  InstructorProfileHeader(instructor: dummyInstructor),
                  SizedBox(height: 32.h),
                  InstructorBioDetails(instructor: dummyInstructor),
                ],
              ),
            SizedBox(height: 32.h),
            InstructorSocialMedia(links: dummyInstructor.links),
          ],
        ),
      ),
    );
  }
}
