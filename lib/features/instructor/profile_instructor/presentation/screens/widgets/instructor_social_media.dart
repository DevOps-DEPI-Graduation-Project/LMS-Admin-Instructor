import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/domain/entity/instructor_profile_ui_model.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructorSocialMedia extends StatelessWidget {
  final List<InstructorLinkUIModel> links;
  const InstructorSocialMedia({super.key, required this.links});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
          Text(
            context.tr('social_media'),
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colorScheme.onSurface,
            ),
          ),
          if (links.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18.sp,
                    color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    context.tr('no_social_media_links'),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface.withValues(
                        alpha: 0.4,
                      ),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 16.w,
              runSpacing: 16.h,
              children: links
                  .map((link) => _buildSocialIcon(context, link))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, InstructorLinkUIModel link) {
    IconData iconData;
    Color iconColor;

    switch (link.platformName.toLowerCase()) {
      case 'facebook':
        iconData = Icons.facebook;
        iconColor = const Color(0xFF1877F2);
        break;
      case 'instagram':
        iconData = Icons.camera_alt_rounded;
        iconColor = const Color(0xFFE4405F);
        break;
      case 'youtube':
        iconData = Icons.play_circle_fill;
        iconColor = const Color(0xFFFF0000);
        break;
      case 'twitter':
      case 'x':
        iconData = Icons.close;
        iconColor = Colors.black;
        break;
      case 'linkedin':
        iconData = Icons.business;
        iconColor = const Color(0xFF0A66C2);
        break;
      default:
        iconData = Icons.link;
        iconColor = context.colorScheme.primary;
    }

    return InkWell(
      onTap: () async {
        final url = Uri.parse(link.url);
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54.w,
            height: 54.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 26.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            link.platformName,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
