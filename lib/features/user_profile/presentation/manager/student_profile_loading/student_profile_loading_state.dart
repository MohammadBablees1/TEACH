part of 'student_profile_loading_cubit.dart';

@immutable
sealed class StudentProfileLoadingState {}

final class StudentProfileLoadingInitial extends StudentProfileLoadingState {}

final class StudentProfileLoading extends StudentProfileLoadingState {
  final bool loadng;
  StudentProfileLoading({required this.loadng});
}
