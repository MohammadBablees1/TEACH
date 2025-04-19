part of 'them_mode_cubit.dart';

@immutable
sealed class ThemModeState {}

final class ThemModeInitial extends ThemModeState {
  
}

class IsDarkMode extends ThemModeState {
  var isDark = false;

  IsDarkMode({
    required this.isDark,
  });
}

class ChangeLanguage extends ThemModeState {
  var language = false;
  var isDark = false;
  ChangeLanguage({required this.language, required this.isDark});
}
