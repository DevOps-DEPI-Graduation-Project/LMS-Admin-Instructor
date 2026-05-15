import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/data/models/create_link_request_model.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_event.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_state.dart';
import 'package:lms_admin_instructor/features/widgets/custon_text_form_field.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';

class AddLinkDialog extends StatefulWidget {
  final String slug;

  const AddLinkDialog({super.key, required this.slug});

  @override
  State<AddLinkDialog> createState() => _AddLinkDialogState();
}

class _AddLinkDialogState extends State<AddLinkDialog> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _otherPlatformController = TextEditingController();

  String _selectedPlatform = 'facebook';
  final List<String> _platforms = [
    'facebook',
    'linkedin',
    'twitter',
    'instagram',
    'youtube',
    'github',
    'tiktok',
    'whatsapp',
    'website',
    'other',
  ];

  IconData _getPlatformIcon(String platform) {
    switch (platform) {
      case 'facebook':
        return Icons.facebook;
      case 'linkedin':
        return Icons.business;
      case 'twitter':
        return Icons.close;
      case 'instagram':
        return Icons.camera_alt_rounded;
      case 'youtube':
        return Icons.play_circle_fill;
      case 'github':
        return Icons.code;
      case 'tiktok':
        return Icons.music_note;
      case 'whatsapp':
        return Icons.chat;
      case 'website':
        return Icons.language;
      default:
        return Icons.link;
    }
  }

  Color _getPlatformColor(String platform) {
    switch (platform) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'linkedin':
        return const Color(0xFF0A66C2);
      case 'twitter':
        return Colors.black;
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'github':
        return const Color(0xFF181717);
      case 'tiktok':
        return Colors.black;
      case 'whatsapp':
        return const Color(0xFF25D366);
      case 'website':
        return context.colorScheme.primary;
      default:
        return context.colorScheme.primary;
    }
  }

  @override
  void dispose() {
    _urlController.dispose();
    _otherPlatformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileInstructorBloc, ProfileInstructorState>(
      listener: (context, state) {
        if (state is AddInstructorLinkSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.tr('link_added_success')),
              backgroundColor: context.colorScheme.secondary,
            ),
          );
          context.read<ProfileInstructorBloc>().add(
            GetInstructorLinksEvent(slug: widget.slug),
          );
          context.pop();
        } else if (state is AddInstructorLinkError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: context.colorScheme.error,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Container(
          width: context.isMobile ? double.infinity : 450.w,
          padding: EdgeInsets.all(context.isMobile ? 24.w : 32.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: context.colorScheme.primaryContainer
                              .withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          Icons.add_link_rounded,
                          color: context.colorScheme.primary,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        context.tr('add_link'),
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    context.tr('platform_label'),
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surfaceVariant.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: context.colorScheme.outline.withValues(
                          alpha: 0.1,
                        ),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedPlatform,
                        isExpanded: true,
                        dropdownColor: context.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        items: _platforms.map((String platform) {
                          return DropdownMenuItem<String>(
                            value: platform,
                            child: Row(
                              children: [
                                Icon(
                                  _getPlatformIcon(platform),
                                  size: 20.sp,
                                  color: _getPlatformColor(platform),
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  context.tr(platform),
                                  style: context.textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedPlatform = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),

                  if (_selectedPlatform == 'other') ...[
                    SizedBox(height: 20.h),
                    CustomTextFormField(
                      txt: context.tr('other'),
                      hint: context.tr('platform_label'),
                      controller: _otherPlatformController,
                      validator: (value) =>
                          value!.isEmpty ? context.tr('required_field') : null,
                    ),
                  ],

                  SizedBox(height: 20.h),
                  CustomTextFormField(
                    txt: context.tr('url_label'),
                    hint: context.tr('url_hint'),
                    controller: _urlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('required_field');
                      }
                      if (!value.startsWith('http')) {
                        return 'URL must start with http:// or https://';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(context.tr('cancel')),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child:
                            BlocBuilder<
                              ProfileInstructorBloc,
                              ProfileInstructorState
                            >(
                              builder: (context, state) {
                                return CustomPrimaryButton(
                                  text: context.tr('submit'),
                                  height: 48.h,
                                  onTap: state is AddInstructorLinkLoading
                                      ? null
                                      : () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final platformName =
                                                _selectedPlatform == 'other'
                                                ? _otherPlatformController.text
                                                : context.tr(_selectedPlatform);

                                            context
                                                .read<ProfileInstructorBloc>()
                                                .add(
                                                  AddInstructorLinkEvent(
                                                    slug: widget.slug,
                                                    requestModel:
                                                        CreateLinkRequestModel(
                                                          platformName:
                                                              platformName,
                                                          url: _urlController
                                                              .text,
                                                        ),
                                                  ),
                                                );
                                          }
                                        },
                                );
                              },
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
