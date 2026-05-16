part of 'student_details_bloc.dart';

abstract class StudentDetailsState {}

class StudentDetailsInitial extends StudentDetailsState {}

class StudentDetailsStateError extends StudentDetailsState {
  final String message;
  StudentDetailsStateError({required this.message});
}