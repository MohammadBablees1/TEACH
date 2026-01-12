import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/features/student-main-screen/presentation/manager/logout_loading/logout_loading_cubit.dart';
import 'package:teach/features/student-main-screen/repo/reuathnticate.dart';
import 'package:teach/features/welcom_screen/presentation/page_veiw.dart';

class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue"],
      content: SizedBox(
        width: getWidth(context) * .4,
        height: getHeight(context) * .15,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              getDeviceLocale() == "ar" ? "هل أنت متأكد ؟" : "Are you sure?",
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      // ignore: use_build_context_synchronously
                      context.read<LogoutLoadingCubit>().start();

                      try {
                        await Reuathnticate().reauthenticateAndDelete();
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        context.read<LogoutLoadingCubit>().stope();
                        Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PageVeiwScreen(),
                            ));

                        var box = Hive.box(hiveBoxName);
                        box.delete(isStudent);
                        box.delete(isMainManager);
                        box.delete(isManager);
                        box.delete(isCode);
                        box.delete(isFile);
                        box.delete("info");
                        mode = false;

                        // ignore: use_build_context_synchronously
                        BlocProvider.of<ThemModeCubit>(context)
                            .isDarkMode(mode);

                        // ignore: use_build_context_synchronously
                        BlocProvider.of<ThemModeCubit>(context)
                            .isDarkMode(false);
                        // ignore: use_build_context_synchronously
                        BlocProvider.of<ThemModeCubit>(context)
                            .changeLanguage(false);
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        context.read<LogoutLoadingCubit>().stope();
                        lunchAwesomDialoge(
                            DialogType.error,
                            "e",
                            e.toString(),
                            // ignore: use_build_context_synchronously
                            context,
                            // ignore: use_build_context_synchronously
                            getWidth(context),
                            // ignore: use_build_context_synchronously
                            getHeight(context));
                      }
                    } else {
                      lunchAwesomDialoge(
                          DialogType.warning,
                          "e",
                          getDeviceLocale() == "ar"
                              ? "تأكد من اتصالك بالإنترنت"
                              : "Make sure you are connected to the Internet",
                          // ignore: use_build_context_synchronously
                          context,
                          // ignore: use_build_context_synchronously
                          getWidth(context),
                          // ignore: use_build_context_synchronously
                          getHeight(context));
                    }
                  },
                  child: BlocBuilder<LogoutLoadingCubit, LogoutLoadingState>(
                    builder: (context, state) {
                      return state is LogoutLoading && state.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar" ? "نعم" : "Yes",
                              style: const TextStyle(color: Colors.white),
                            );
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: AutoSizeText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      maxFontSize: 15,
                      getDeviceLocale() == "ar" ? "إلغاء" : "Cancel",
                      style: const TextStyle(color: Colors.white),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
