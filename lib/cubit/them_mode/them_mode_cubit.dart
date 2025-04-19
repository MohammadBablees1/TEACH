import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/main.dart';

part 'them_mode_state.dart';

class ThemModeCubit extends Cubit<ThemModeState> {
  ThemModeCubit() : super(ThemModeInitial()) {
    loadInfo();
  }

  loadInfo() async {
    var box = Hive.box(hiveBoxName);

    mode = box.get("mode") != null ? box.get("mode") : false;
    language = box.get("lan") != null ? box.get("lan") : false;
    emit(ChangeLanguage(language: language, isDark: mode));
  }

  isDarkMode(isDark) async {
    var box = Hive.box(hiveBoxName);
    box.put('mode', isDark);

    emit(ChangeLanguage(language: language, isDark: isDark));
  }

  changeLanguage(language) async {
    var box = Hive.box(hiveBoxName);
    box.put('lan', language);

    emit(ChangeLanguage(language: language, isDark: mode));
  }
}
