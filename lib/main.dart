import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teach/core/auth_gate.dart';
import 'package:teach/features/student-main-screen/presentation/manager/logout_loading/logout_loading_cubit.dart';
import 'package:teach/features/student-main-screen/presentation/student_main_screen.dart';
import 'package:teach/features/update_password/presentation/manager/crrent_password_visibility/current_password_visibility_cubit.dart';
import 'package:teach/features/update_password/presentation/manager/new_password_visibility/new_password_visibility_cubit.dart';
import 'package:teach/features/update_password/presentation/manager/update_password_loading/update_password_loading_cubit.dart';
import 'package:teach/features/user_profile/presentation/manager/change_name/change_name_cubit.dart';
import 'package:teach/cubit/color_me/color_me_cubit.dart';
import 'package:teach/features/bar_code_scanner/presentation/manager/catch_code_for_sign_in/catch_code_for_sign_in_cubit.dart';
import 'package:teach/features/login/presentation/manager/login_confirm_password_visibility/login_confirm_password_visibility_cubit.dart';
import 'package:teach/features/login/presentation/manager/login_loading/login_loading_cubit.dart';
import 'package:teach/features/login/presentation/manager/login_password_visibility/login_password_visibility_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/add_ad_loading/add_ad_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/add_folder_loading/add_folder_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/add_phone_number_loading/add_phone_number_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/phone_number/phone_number_cubit.dart';
import 'package:teach/cubit/search_code/selected_code_search_cubit.dart';

  import 'package:hive_flutter/adapters.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:teach/cubit/animatedContainerTow/animated_container_tow_cubit.dart';
import 'package:teach/cubit/changeOpacity/change_opacity_cubit.dart';
import 'package:teach/cubit/change_code/code_changed_cubit.dart';
import 'package:teach/cubit/check_connection/check_connection_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/features/recorded_code/presentation/manager/home_search/home_search_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/password/password_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';
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
import 'package:teach/features/sign_in/presentation/manager/sign_in_loading/sign_in_loading_cubit.dart';
import 'package:teach/features/student-main-screen/presentation/manager/manual_code_loading/manual_code_loading_cubit.dart';
import 'package:teach/features/student-main-screen/presentation/manager/open_popular_curse_loading/open_popular_curse_loading_cubit.dart';
import 'package:teach/features/user_profile/presentation/manager/student_profile_loading/student_profile_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/main_screen.dart';
import 'package:teach/features/welcom_screen/presentation/page_veiw.dart';
import 'package:teach/screens/pages/update_screen.dart';

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
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce, // IMPORTANT
    ),
  );

 
  runApp(
    MultiBlocProvider(
      
      providers: [
      BlocProvider(
        lazy: true,
        create: (_) => TeachCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => RefreshFolderCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => UploadVideoCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ClauserIndexCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LunchLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => TimerCubitCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LoadingPdfCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => PasswordCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => AnimatedContainerTowCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => SearchCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ThemModeCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => CodeChangedCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => CheckConnectionCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => HomeSearchCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ChangeOpacityCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => SelecteClassCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => SelectedValueCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => SelectedCodeSearchCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => PhoneNumberCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => WhateToUploadeCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ColorMeCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ManagerScreenCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ChangeNameCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => AddFolderLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => AddAdLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => AddPhoneNumberCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => SignInLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => CatchCodeForSignInCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LoginPasswordVisibilityCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LoginConfirmPasswordVisibilityCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LoginLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => ManualCodeLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => OpenPopularCurseLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => StudentProfileLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => UpdatePasswordLoadingCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => CurrentPasswordVisibilityCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => NewPasswordVisibilityCubit()),
      BlocProvider(
        lazy: true,
        create: (_) => LogoutLoadingCubit()),
    ], child: const MyApp()),
  );
}



final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      bottomAppBarTheme: BottomAppBarTheme(
        color: nightBar["orange"],
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: nightBar["buttons"])),
      appBarTheme: AppBarTheme(
        color: nightBar["orange"],
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
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
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: dayBar["blue3"],
      )),
      bottomAppBarTheme: BottomAppBarTheme(
        color: dayBar["blue"],
      ),
      primarySwatch: dayBar["blue"],
      extensions: const <ThemeExtension<dynamic>>[],
    );
    return BlocBuilder<ThemModeCubit, ThemModeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: state is ChangeLanguage
              ? state.language
                  ? const Locale("en")
                  : const Locale("ar")
              : const Locale("ar"),
          supportedLocales: const [
            Locale('en'), // الإنجليزية
            Locale('ar'), // العربية
          ],
          localizationsDelegates: const [
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
                return const PageVeiwScreen();
              } else if (state is UpdateRecomended) {
                return const UpdateScreen();
              } else if (state is UserFound) {
                var box = Hive.box(hiveBoxName);
                var student = box.get(isStudent);
                if (student != null && student) {
                  
                  return const StudentMainScreen();
                } else {
                  return const MainScreen();
                }
              } else {
                return const AuthGate();
              }
            },
          ),
        );
      },
    );
  }
}
