import 'package:file_picker/file_picker.dart';

abstract class AddNewVideoEvent {}

class AddVideoEvent extends AddNewVideoEvent {
  final String courseSlug;
  final String title;
  final String course;
  final String? videoUrl;
  final PlatformFile? videoFile;
  final String duration;

  AddVideoEvent({
    required this.courseSlug,
    required this.title,
    required this.course,
    this.videoUrl,
    this.videoFile,
    required this.duration,
  });
}
