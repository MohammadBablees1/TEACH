import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teach/cubit/change_name/change_name_cubit.dart';
import 'package:teach/cubit/color_me/color_me_cubit.dart';
import 'package:teach/cubit/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/phone_number/phone_number_cubit.dart';
import 'package:teach/cubit/search_code/selected_code_search_cubit.dart';

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
import 'package:teach/cubit/whate_to_uploade/whate_to_uploade_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/firebase_options.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/screens/page_veiw.dart';
import 'package:teach/screens/pages/student_main_screen.dart';
import 'package:teach/screens/pages/update_screen.dart';
import 'package:teach/screens/waiting_screen.dart';

void main() async {
  // TeXRederingServer.renderingEngine = const TeXViewRenderingEngine.mathjax();

  // if (!kIsWeb) {
  //   await TeXRederingServer.run();
  //   await TeXRederingServer.initController();}

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "api.env");
  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"].toString(),
    anonKey: dotenv.env["SUPABASE_KEY"].toString(),
  );

  await Hive.initFlutter();
  await Hive.openBox(hiveBoxName);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
 // FirebaseMessaging.instance.setAutoInitEnabled(false);
await AwesomeNotifications().initialize(
  null,
  [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      channelDescription: 'Channel for basic notifications',
      importance: NotificationImportance.High,
      defaultColor: Colors.blue,
      ledColor: Colors.white,
      playSound: true,
      enableVibration: true,
    ),
  ],
);

  // طلب إذن الإشعارات (لـ iOS)
  await AwesomeNotifications().requestPermissionToSendNotifications();
FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
  await  showNotification(message);
});
  // معالجة الإشعارات في الخلفية
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
      BlocProvider(create: (_) => SelectedValueCubit()),
      BlocProvider(create: (_) => SelectedCodeSearchCubit()),
      BlocProvider(create: (_) => PhoneNumberCubit()),
      BlocProvider(create: (_) => WhateToUploadeCubit()),
      BlocProvider(create: (_) => ColorMeCubit()),
      BlocProvider(create: (_) => ManagerScreenCubit()),
      BlocProvider(create: (_) => ChangeNameCubit()),
    ], child: const MyApp()),
  );
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await showNotification(message);
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
          color: dayBar["blue3"],
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: dayBar["blue3"],
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
              } else if (state is UpdateRecomended) {
                return UpdateScreen();
              } else if (state is UserFound) {
                var box = Hive.box(hiveBoxName);
                var student = box.get(isStudent);
                if (student != null && student) {
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
