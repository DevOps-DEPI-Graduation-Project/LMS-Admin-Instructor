import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lms_admin_instructor/core/di/service_locator.dart';
import 'package:lms_admin_instructor/core/extensions/context_extensions.dart';
import 'package:lms_admin_instructor/core/utils/get_responsive_size.dart';
import 'package:lms_admin_instructor/features/widgets/custom_button.dart';
import 'package:lms_admin_instructor/features/widgets/custon_text_form_field.dart';
import 'package:lms_admin_instructor/features/instructor/add_new_video/presentation/bloc/add_new_video_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/add_new_video/presentation/bloc/add_new_video_event.dart';
import 'package:lms_admin_instructor/features/instructor/add_new_video/presentation/bloc/add_new_video_state.dart';
import 'widgets/dashed_rect_painter.dart';

class AddNewVideoScreen extends StatefulWidget {
  final String courseSlug;
  const AddNewVideoScreen({super.key, required this.courseSlug});

  @override
  State<AddNewVideoScreen> createState() => _AddNewVideoScreenState();
}

class _AddNewVideoScreenState extends State<AddNewVideoScreen> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _durationController = TextEditingController();
  PlatformFile? _selectedFile;

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.video,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('error in video file: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddNewVideoBloc>(),
      child: BlocConsumer<AddNewVideoBloc, AddNewVideoState>(
        listener: (context, state) {
          if (state is AddNewVideoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Video added successfully!')),
            );
            context.pop(true);
          } else if (state is AddNewVideoError) {
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
              width: context.isDesktop ? 600.w : 400.w,
              padding: EdgeInsets.all(24.r),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add New Video',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Fill out the details below to add a new video resource to your curriculum.',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildLabel(context, 'Video Title'),
                    CustomTextFormField(
                      txt: 'Enter video title',
                      hint: 'Enter video title',
                      controller: _titleController,
                    ),
                    SizedBox(height: 16.h),
                    _buildLabel(context, 'YouTube Video URL'),
                    CustomTextFormField(
                      txt: 'https://youtube.com/shorts/...',
                      hint: 'https://youtube.com/shorts/...',
                      controller: _urlController,
                      prefixIcon: Icons.link,
                      onChanged: (val) {
                        if (val.isNotEmpty) {
                          setState(() {
                            _selectedFile = null;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildLabel(context, 'Duration'),
                    CustomTextFormField(
                      txt: 'e.g. 10:30',
                      hint: 'e.g. 10:30',
                      controller: _durationController,
                      prefixIcon: Icons.timer_outlined,
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: context.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: context.textTheme.labelSmall?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: context.colorScheme.outline.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    _buildLabel(context, 'Upload Video from Device'),
                    GestureDetector(
                      onTap: _pickVideo,
                      child: _buildUploadBox(context),
                    ),
                    SizedBox(height: 32.h),
                    CustomPrimaryButton(
                      text: state is AddNewVideoLoading
                          ? 'Adding...'
                          : 'Add Video',
                      prefixIcon: state is AddNewVideoLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Icon(
                              Icons.file_upload_outlined,
                              color: context.colorScheme.onPrimary,
                              size: 20.sp,
                            ),
                      width: double.infinity,
                      onTap: state is AddNewVideoLoading
                          ? null
                          : () {
                              if (_titleController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a title'),
                                  ),
                                );
                                return;
                              }
                              if (_selectedFile == null && _urlController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please either provide a video URL or upload a video from your device.'),
                                  ),
                                );
                                return;
                              }
                              context.read<AddNewVideoBloc>().add(
                                AddVideoEvent(
                                  courseSlug: widget.courseSlug,
                                  title: _titleController.text,
                                  course: widget.courseSlug,
                                  duration: _durationController.text,
                                  videoUrl: _urlController.text.isNotEmpty
                                      ? _urlController.text
                                      : null,
                                  videoFile: _selectedFile,
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
      ),
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
                    : Icons.upload_file_outlined,
                size: 28.sp,
                color: context.colorScheme.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              _selectedFile != null
                  ? _selectedFile!.name
                  : 'Click or drag video to upload',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              _selectedFile != null
                  ? '${(_selectedFile!.size / 1024 / 1024).toStringAsFixed(2)} MB'
                  : 'MP4, MOV or AVI up to 2GB',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

    void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

}
