import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/animatedContainerTow/animated_container_tow_cubit.dart';
import 'package:teach/cubit/changeOpacity/change_opacity_cubit.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/check_connection/check_connection_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/home_search/home_search_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/search/search_cubit.dart';
import 'package:teach/cubit/selected_value/selected_value_cubit.dart';
import 'package:teach/cubit/slelecte_class/selecte_class_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/cubit/timer_cubit/timer_cubit_cubit.dart';
import 'package:teach/cubit/upload_video_cubit/upload_video_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/screens/check_connection.dart' as ch;
import 'package:teach/screens/main_screen.dart';
import 'package:teach/screens/page_veiw.dart';
import 'package:teach/screens/pages/student_main_screen.dart';
import 'package:teach/screens/pages/update_screen.dart';
import 'package:teach/screens/waiting_screen.dart';
import 'firebase_options.dart';

void main() async {
  // TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.mathjax();

  // if (!kIsWeb) {
  //   await TeXRederingServer.run();
  //   await TeXRederingServer.initController();}

  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://acqtlcyjhmrzacbjgwrv.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFjcXRsY3lqaG1yemFjYmpnd3J2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ1NzMxMTIsImV4cCI6MjA2MDE0OTExMn0.KKVyL8IwuEKRrnNUjkbfut6_GLF3gyJCy0As5LyH4p4",
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings = const Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED, persistenceEnabled: true);

  await Hive.initFlutter();
  await Hive.openBox(hiveBoxName);

  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(create: (_) => TeachCubit()..checkConnection()),
      BlocProvider(create: (_) => RefreshFolderCubit()),
      BlocProvider(create: (_) => UploadVideoCubit()),
      BlocProvider(create: (_) => ClauserIndexCubit()),
      BlocProvider(create: (_) => LunchLoadingCubit()),
      BlocProvider(create: (_) => TimerCubitCubit()),
      BlocProvider(create: (_) => LoadingPdfCubit()),
      BlocProvider(create: (_) => PasswordCubit()),
      BlocProvider(create: (_) => AnimatedContainerTowCubit()),
      BlocProvider(create: (_) => SearchCubit()),
      BlocProvider(create: (_) => ThemModeCubit()),
      BlocProvider(create: (_) => CodeChangedCubit()),
      BlocProvider(create: (_) => CheckConnectionCubit()),
      BlocProvider(create: (_) => HomeSearchCubit()),
      BlocProvider(create: (_) => ChangeOpacityCubit()),
      BlocProvider(create: (_) => SelecteClassCubit()),
      BlocProvider(create: (_) => SelectedValueCubit())
    ], child: const MyApp()),
  );
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   var lan = getDeviceLocale();
  //   super.initState();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Color(0xFF121212),
      bottomAppBarTheme: BottomAppBarTheme(
        color: nightBar["orange"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: nightBar["buttons"])),
      appBarTheme: AppBarTheme(
        color: nightBar["orange"],
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
          color: dayBar["blue"],
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: dayBar["blue2"],
      )),
      bottomAppBarTheme: BottomAppBarTheme(
        color: dayBar["blue"],
      ),
      primarySwatch: dayBar["blue"],
      extensions: <ThemeExtension<dynamic>>[],
    );
    return BlocBuilder<ThemModeCubit, ThemModeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state is ChangeLanguage
              ? state.language
                  ? Locale("en")
                  : Locale("ar")
              : Locale("ar"),
          supportedLocales: [
            Locale('en'), // الإنجليزية
            Locale('ar'), // العربية
          ],
          localizationsDelegates: [
            // AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          title: getDeviceLocale() == "ar" ? appNameInArabic : appNameInEnglish,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode ? ThemeMode.dark : ThemeMode.light,

          // theme: ThemeData(
          //   // colorScheme: ColorScheme.fromSeed(seed dayBar["blue"]),
          //   // useMaterial3: true,
          // ),
          home: BlocBuilder<TeachCubit, TeachState>(
            builder: (context, state) {
              // if (state is NotConnected) {
              //   return ch.CheckConnection();
              // } else
              if (state is NoUSerFound) {
                return PageVeiwScreen();
              } else if (state is UpdateApp) {
                return UpdateScreen();
              } else if (state is UserFound) {
                var box = Hive.box(hiveBoxName);
                var student = box.get(isStudent);
                if (student) {
                  return StudentMainScreen();
                } else {
                  return MainScreen();
                }
              } else {
                return WaitingScreen();
              }
            },
          ),
        );
      },
    );
  }
}
