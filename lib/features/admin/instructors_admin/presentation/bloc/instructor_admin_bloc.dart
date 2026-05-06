import 'package:bloc/bloc.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/domain/repository/instructor_admin_repoditory.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/bloc/instructor_admin_event.dart';
import 'package:lms_admin_instructor/features/admin/instructors_admin/presentation/bloc/instructor_admin_state.dart';

class InstructorAdminBloc
    extends Bloc<InstructorAdminEvent, InstructorAdminState> {
  final InstructorAdminRepository instructorAdminRepository;

  InstructorAdminBloc({required this.instructorAdminRepository})
    : super(InstructorAdminInitial()) {
    on<GetInstructorAdminEvent>(_onGetInstructorAdminEvent);
    on<AddInstructorEvent>(_onAddInstructorEvent);
    on<GetInstructorBySlugEvent>(_onGetInstructorBySlugEvent);
    on<DeleteInstructorEvent>(_onDeleteInstructorEvent);
  }

  Future<void> _onDeleteInstructorEvent(
    DeleteInstructorEvent event,
    Emitter<InstructorAdminState> emit,
  ) async {
    emit(DeleteInstructorLoading());
    final result = await instructorAdminRepository.deleteInstructor(event.slug);
    result.fold(
      (failure) => emit(DeleteInstructorError(message: failure)),
      (success) => emit(DeleteInstructorSuccess()),
    );
  }

  Future<void> _onGetInstructorAdminEvent(
    GetInstructorAdminEvent event,
    Emitter<InstructorAdminState> emit,
  ) async {
    final currentState = state;
    final int pageToFetch = event.page ?? 1;

    if (pageToFetch == 1) {
      if (currentState is! InstructorAdminLoaded) {
        emit(InstructorAdminLoading());
      }
    } else {
      if (currentState is InstructorAdminLoaded) {
        if (currentState.instructorAdminUiModel.currentPage >=
            currentState.instructorAdminUiModel.totalPages) {
          return;
        }
        emit(currentState.copyWith(isPaginationLoading: true));
      } else {
        emit(InstructorAdminLoading());
      }
    }

    final result = await instructorAdminRepository.getInstructorAdmin(
      pageToFetch,
      event.pageSize,
    );

    result.fold((failure) => emit(InstructorAdminError(message: failure)), (
      responseModel,
    ) {
      final newEntity = responseModel.toEntity();

      if (pageToFetch == 1 || currentState is! InstructorAdminLoaded) {
        emit(InstructorAdminLoaded(instructorAdminUiModel: newEntity));
      } else {
        final accumulatedInstructors = [
          ...currentState.instructorAdminUiModel.instructors,
          ...newEntity.instructors,
        ];
        emit(
          InstructorAdminLoaded(
            instructorAdminUiModel: newEntity.copyWith(
              instructors: accumulatedInstructors,
            ),
            isPaginationLoading: false,
          ),
        );
      }
    });
  }

  Future<void> _onAddInstructorEvent(
    AddInstructorEvent event,
    Emitter<InstructorAdminState> emit,
  ) async {
    emit(AddInstructorLoading());
    final result = await instructorAdminRepository.addInstructor(
      event.first_name,
      event.last_name,
      event.email,
    );
    result.fold(
      (failure) => emit(AddInstructorError(message: failure)),
      (responseModel) =>
          emit(AddInstructorSuccess(addInstructorModel: responseModel)),
    );
  }

  Future<void> _onGetInstructorBySlugEvent(
    GetInstructorBySlugEvent event,
    Emitter<InstructorAdminState> emit,
  ) async {
    emit(InstructorDetailsLoading());
    final result = await instructorAdminRepository.getInstructorBySlug(
      event.slug,
    );
    result.fold(
      (failure) => emit(InstructorDetailsError(message: failure)),
      (responseModel) => emit(
        InstructorDetailsLoaded(
          instructorDetailsUiModel: responseModel.toEntity(),
        ),
      ),
    );
  }
}
