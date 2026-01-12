import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

// ignore: must_be_immutable
class ShowDeletingDialoge extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var id;

   ShowDeletingDialoge({super.key, required this.id});

  @override
  State<ShowDeletingDialoge> createState() => _ShowDeletingDialogeState();
}

class _ShowDeletingDialogeState extends State<ShowDeletingDialoge> {
    final FolderRepository _repo = FolderRepository(supabase);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue"],
      content: SizedBox(
        width: getWidth(context) / 4,
        height: getHeight(context) / 8,
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
                BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () async {
                        if (await checkConnection()) {
                          // ignore: use_build_context_synchronously
                          context.read<LunchLoadingCubit>().lunchLoading(true);
                          // ignore: use_build_context_synchronously
                          await _repo.deleteFolder(widget.id, null, context);
                          // ignore: use_build_context_synchronously
                          context.read<LunchLoadingCubit>().lunchLoading(false);

                          // ignore: use_build_context_synchronously
                          context.read<RefreshFolderCubit>().refreshPage();
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
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
                      child: state is LunchLoading && state.loading
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
                            ),
                    );
                  },
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
