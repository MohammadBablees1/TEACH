part of 'open_popular_curse_loading_cubit.dart';

@immutable
sealed class OpenPopularCurseLoadingState {}

final class OpenPopularCurseLoadingInitial
    extends OpenPopularCurseLoadingState {}

final class OpenPopularCurseLoading extends OpenPopularCurseLoadingState {
  final bool loading;

  OpenPopularCurseLoading({required this.loading});
}
