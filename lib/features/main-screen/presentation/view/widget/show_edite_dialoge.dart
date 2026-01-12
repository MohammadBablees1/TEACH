import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

// ignore: must_be_immutable
class ShowEditeDialoge extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var id;
  var name = "", loading = false;

  ShowEditeDialoge({super.key, required this.id});
  @override
  State<ShowEditeDialoge> createState() => _ShowEditeDialogeState();
}

class _ShowEditeDialogeState extends State<ShowEditeDialoge> {
  GlobalKey<FormState> folderKey = GlobalKey();
  final FolderRepository _repo = FolderRepository(supabase);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mode ? nightBar["orange"] : Colors.white,
      content: PopScope(
        canPop: false,
        child: Container(
          width: getWidth(context) * .8,
          height: getWidth(context) * .5,
          child: Form(
            key: folderKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: getWidth(context) * 2 / 15,
                  height: getWidth(context) * 2 / 15,
                  child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 201, 201, 201),
                    child: Image.asset(
                      "images/add_book.png",
                      width: getWidth(context) * 1 / 15,
                      height: getWidth(context) * 1 / 15,
                    ),
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    return nameValidator(value!);
                  },
                  style: TextStyle(
                    color: mode ? Colors.white : dayBar["blue2"],
                  ),
                  cursorColor: mode ? Colors.white : dayBar["blue2"],
                  onChanged: (folderName) {
                    widget.name = folderName;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: .5,
                            color: mode ? Colors.white : dayBar["blue2"],
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: .5,
                            color: mode ? Colors.white : dayBar["blue2"],
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 1,
                            color: mode ? Colors.white : dayBar["blue2"],
                          )),
                      hintText: getDeviceLocale() == "ar"
                          ? "اكتب الاسم الجديد هنا..."
                          : "Write the new name here...",
                      hintStyle: TextStyle(
                        color: mode
                            ? Colors.white.withOpacity(.5)
                            : dayBar["blue2"].withOpacity(.4),
                      )),
                ),
                BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                  builder: (context, state) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (await checkConnection()) {
                              if (folderKey.currentState!.validate()) {
                                try {
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(true);

                                  var check = await _repo.renameFolder(
                                     widget.id, widget.name, context);
                                  if (check) {
                                    context
                                        .read<LunchLoadingCubit>()
                                        .lunchLoading(false);
                                    context
                                        .read<RefreshFolderCubit>()
                                        .refreshPage();
                                    Navigator.pop(context);
                                  } else {
                                    context
                                        .read<LunchLoadingCubit>()
                                        .lunchLoading(false);
                                  }
                                } catch (e) {
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(false);
                                  setState(() {
                                    widget.loading = false;
                                  });
                                  lunchAwesomDialoge(
                                      DialogType.error,
                                      "e",
                                      getDeviceLocale() == "ar"
                                          ? "يوجد خطأ ما!"
                                          : "Somethig is wrong!",
                                      context,
                                      getWidth(context),
                                      getHeight(context));
                                }
                              }
                            } else {
                              lunchAwesomDialoge(
                                  DialogType.warning,
                                  "e",
                                  getDeviceLocale() == "ar"
                                      ? "تأكد من اتصالك بالإنترنت"
                                      : "Make sure you are connected to the Internet",
                                  context,
                                  getWidth(context),
                                  getHeight(context));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                mode ? nightBar["buttons"] : dayBar["blue3"],
                          ),
                          child: state is LunchLoading
                              ? state.loading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      getDeviceLocale() == "ar"
                                          ? Translation().translateMe[
                                              "Arabic"]!["save_button"]
                                          : Translation().translateMe[
                                              "English"]!["save_button"],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? Translation()
                                          .translateMe["Arabic"]!["save_button"]
                                      : Translation().translateMe["English"]![
                                          "save_button"],
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  mode ? nightBar["buttons"] : dayBar["blue3"],
                            ),
                            onPressed: () {
                              if (!(state is LunchLoading && state.loading)) {
                                Navigator.pop(context);
                              }
                            },
                            child: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar" ? "إلغاء" : "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ))
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
