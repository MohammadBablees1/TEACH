part of 'whate_to_uploade_cubit.dart';

@immutable
sealed class WhateToUploadeState {}

final class WhateToUploadeInitial extends WhateToUploadeState {}

final class SelectToUploade extends WhateToUploadeState {
  bool all, video, pdf, questionBank, folder, teacher;
  SelectToUploade(
      {required this.all,
      required this.video,
      required this.pdf,
      required this.questionBank,
      required this.folder,
      required this.teacher});
}
