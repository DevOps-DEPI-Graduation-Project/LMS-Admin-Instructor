import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/localization/app_localizations.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/instructor/add_new_video/presentation/screens/widgets/dashed_rect_painter.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';
import 'package:lms_admin_instructor/features/widgets/custon_text_form_field.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_event.dart';
import 'package:lms_admin_instructor/features/instructor/course_details/presentation/bloc/course_material_bloc/course_material_state.dart';
import 'package:lms_admin_instructor/features/instructor/common/data/model/materials_model/upload_material_request_model.dart';

class UploadMaterialDialog extends StatefulWidget {
  final String courseSlug;
  const UploadMaterialDialog({super.key, required this.courseSlug});

  @override
  State<UploadMaterialDialog> createState() => _UploadMaterialDialogState();
}

class _UploadMaterialDialogState extends State<UploadMaterialDialog> {
  final _nameController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'txt',
        'zip',
        'rar',
        '7z',
      ],
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
        if (_nameController.text.isEmpty) {
          _nameController.text = _selectedFile!.name;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CourseMaterialsBloc, CourseMaterialsState>(
      listener: (context, state) {
        if (state is UploadMaterialSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          Navigator.of(context).pop(true);
        } else if (state is UploadMaterialError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: context.colorScheme.surface,
          child: Container(
            width: context.isDesktop ? 500.w : 400.w,
            padding: EdgeInsets.all(48.r),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('upload_new_material'),
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Upload course slides, documents or other resources.',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildLabel(context, 'Material Name'),
                  CustomTextFormField(
                    txt: 'Enter material name',
                    hint: 'Enter material name',
                    controller: _nameController,
                  ),
                  SizedBox(height: 24.h),
                  _buildLabel(context, 'File Resource'),
                  GestureDetector(
                    onTap: _pickFile,
                    child: _buildUploadBox(context),
                  ),
                  SizedBox(height: 32.h),
                  CustomPrimaryButton(
                    text: state is UploadMaterialLoading
                        ? 'Uploading...'
                        : context.tr('upload_new_material'),
                    prefixIcon: state is UploadMaterialLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: context.colorScheme.surface,
                            ),
                          )
                        : Icon(
                            Icons.upload_outlined,
                            color: context.colorScheme.onPrimary,
                            size: 20.sp,
                          ),
                    width: double.infinity,
                    onTap: state is UploadMaterialLoading
                        ? null
                        : () {
                            if (_nameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a material name'),
                                ),
                              );
                              return;
                            }
                            if (_selectedFile == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please select a file to upload',
                                  ),
                                ),
                              );
                              return;
                            }
                            context.read<CourseMaterialsBloc>().add(
                              UploadMaterialEvent(
                                requestModel: UploadMaterialRequestModel(
                                  materialName: _nameController.text,
                                  file: _selectedFile!,
                                  courseSlug: widget.courseSlug,
                                ),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: context.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: context.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildUploadBox(BuildContext context) {
    return CustomPaint(
      painter: DashedRectPainter(
        color: context.colorScheme.outline.withValues(alpha: 0.5),
        strokeWidth: 1.5,
        gap: 6.0,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 32.h),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _selectedFile != null
                    ? Icons.check_circle_outline
                    : Icons.file_present_outlined,
                size: 28.sp,
                color: context.colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _selectedFile != null
                  ? _selectedFile!.name
                  : 'Click to select material file',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _selectedFile != null
                  ? '${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB'
                  : 'PDF, DOCX, ZIP or any other file',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
