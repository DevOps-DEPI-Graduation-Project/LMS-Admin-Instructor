import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/data/models/update_instructor_request_model.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/domain/entity/instructor_profile_ui_model.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_event.dart';
import 'package:lms_admin_instructor/features/instructor/profile_instructor/presentation/bloc/profile_instructor_state.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';
import 'package:lms_admin_instructor/features/widgets/custon_text_form_field.dart';

class EditProfileDialog extends StatefulWidget {
  final InstructorProfileUIModel instructor;
  final String slug;

  const EditProfileDialog({
    super.key,
    required this.instructor,
    required this.slug,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.instructor.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.instructor.lastName,
    );
    _bioController = TextEditingController(text: widget.instructor.bio);
    _descriptionController = TextEditingController(
      text: widget.instructor.description,
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileInstructorBloc, ProfileInstructorState>(
      listener: (context, state) {
        if (state is ProfileInstructorUpdateSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Dialog(
        backgroundColor: context.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          width: context.isMobile ? double.infinity : 500.w,
          padding: EdgeInsets.all(context.isMobile ? 20.w : 32.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('edit_profile'),
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    context.tr('update_profile_subtitle'),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          txt: context.tr('first_name_label'),
                          hint: context.tr('first_name_hint'),
                          controller: _firstNameController,
                          validator: (value) => value!.isEmpty
                              ? context.tr('required_field')
                              : null,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomTextFormField(
                          txt: context.tr('last_name_label'),
                          hint: context.tr('last_name_hint'),
                          controller: _lastNameController,
                          validator: (value) => value!.isEmpty
                              ? context.tr('required_field')
                              : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  CustomTextFormField(
                    txt: context.tr('bio'),
                    hint: context.tr('bio_hint'),
                    controller: _bioController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 24.h),
                  CustomTextFormField(
                    txt: context.tr('description'),
                    hint: context.tr('description_hint'),
                    controller: _descriptionController,
                    maxLines: 5,
                  ),
                  SizedBox(height: 40.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          context.tr('cancel'),
                          style: context.textTheme.labelLarge?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      BlocBuilder<
                        ProfileInstructorBloc,
                        ProfileInstructorState
                      >(
                        builder: (context, state) {
                          return CustomPrimaryButton(
                            text: context.tr('save_changes'),
                            width: context.isMobile ? 150.w : 180.w,
                            height: 48.h,
                            onTap: state is ProfileInstructorLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<ProfileInstructorBloc>().add(
                                        UpdateProfileInstructorEvent(
                                          slug: widget.slug,
                                          requestModel:
                                              UpdateInstructorRequestModel(
                                                firstName:
                                                    _firstNameController.text,
                                                lastName:
                                                    _lastNameController.text,
                                                bio: _bioController.text,
                                                description:
                                                    _descriptionController.text,
                                              ),
                                        ),
                                      );
                                    }
                                  },
                          );
                        },
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
