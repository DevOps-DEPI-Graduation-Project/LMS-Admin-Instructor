import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/profile_instructor_repository.dart';
import 'profile_instructor_event.dart';
import 'profile_instructor_state.dart';

class ProfileInstructorBloc
    extends Bloc<ProfileInstructorEvent, ProfileInstructorState> {
  final ProfileInstructorRepository repository;

  ProfileInstructorBloc({required this.repository})
    : super(ProfileInstructorInitial()) {
    on<GetProfileInstructorEvent>(_onGetProfileInstructorEvent);
  }

  Future<void> _onGetProfileInstructorEvent(
    GetProfileInstructorEvent event,
    Emitter<ProfileInstructorState> emit,
  ) async {
    emit(ProfileInstructorLoading());

    final response = await repository.getInstructorProfile(event.slug);

    response.fold((failure) => emit(ProfileInstructorError(message: failure)), (
      profileModel,
    ) {
      if (profileModel.data != null) {
        emit(ProfileInstructorLoaded(profile: profileModel.data!.toEntity()));
      } else {
        emit(
          ProfileInstructorError(
            message: profileModel.message ?? 'Unknown error occurred',
          ),
        );
      }
    });
  }
}
