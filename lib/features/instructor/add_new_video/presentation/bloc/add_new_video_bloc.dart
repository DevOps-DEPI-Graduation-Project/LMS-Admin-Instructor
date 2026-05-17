import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms_admin_instructor/features/instructor/add_new_video/data/model/add_video_request_model.dart';
import '../../../common/domain/repository/video_repository.dart';
import 'add_new_video_event.dart';
import 'add_new_video_state.dart';

class AddNewVideoBloc extends Bloc<AddNewVideoEvent, AddNewVideoState> {
  final VideoRepository videoRepository;

  AddNewVideoBloc({required this.videoRepository})
    : super(AddNewVideoInitial()) {
    on<AddVideoEvent>((event, emit) async {
      emit(AddNewVideoLoading());

      final requestModel = AddVideoRequestModel(
        title: event.title,
        course: event.course,
        duration: event.duration,
        videoUrl: event.videoUrl,
        videoFile: event.videoFile,
      );

      final data = await requestModel.toFormDataMap();

      final result = await videoRepository.addVideo(
        event.courseSlug,
        data,
        onSendProgress: (sent, total) {
          if (total > 0) {
            emit(
              AddNewVideoProgress(
                sent: sent,
                total: total,
                progress: sent / total,
              ),
            );
          }
        },
      );

      result.fold(
        (error) => emit(AddNewVideoError(message: error)),
        (video) => emit(AddNewVideoSuccess(video: video)),
      );
    });
    on<ResetAddVideoEvent>((event, emit) {
      emit(AddNewVideoInitial());
    });
  }
}
