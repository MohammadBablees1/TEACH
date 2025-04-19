import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/slelecte_class/selecte_class_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/add_ads.dart';
import 'package:teach/screens/pages/upload_video.dart';
import 'package:uuid/uuid.dart';

class AddChoice extends StatefulWidget {
  List<dynamic> main = [false];
  var loading = false;
  AddChoice({required this.main});

  @override
  State<AddChoice> createState() => _AddChoiceState();
}

class _AddChoiceState extends State<AddChoice> {
  GlobalKey<FormState> folderKey = GlobalKey();
  final FolderRepository _repo = FolderRepository(supabase);
  var selectedClass = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          mode ? nightBar["orange"] : const Color.fromARGB(255, 223, 222, 222),
      content: Container(
        width: getWidth(context) * 0.8,
        height: getWidth(context) * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                width: getWidth(context) * 0.2,
                height: getWidth(context) * 0.2,
                child: CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 201, 201, 201),
                    child: Image.asset(
                      "images/add_book.png",
                      width: getWidth(context) * 0.1,
                      height: getWidth(context) * 0.1,
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () async {
                    if (widget.main[0]) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => AddAds(),
                      ));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) =>
                            UploadVideo(folder: widget.main[1]),
                      ));
                    }
                  },
                  child: Container(
                    width: getWidth(context) * 0.3,
                    height: getHeight(context) * 0.15,
                    decoration: BoxDecoration(
                      color: mode ? nightBar["buttons"] : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          widget.main[0]
                              ? "images/add_ads.png"
                              : "images/video.png",
                          width: getWidth(context) * .1,
                          height: getWidth(context) * .1,
                        ),
                        Text(
                          widget.main[0]
                              ? getDeviceLocale() == "ar"
                                  ? Translation()
                                      .translateMe["Arabic"]!["add_ads"]
                                  : Translation()
                                      .translateMe["English"]!["add_ads"]
                              : getDeviceLocale() == "ar"
                                  ? "إضافة فيديو"
                                  : "Add video",
                          style: TextStyle(
                            color: mode ? Colors.white : Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {
                    var name = "";
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor:
                            mode ? nightBar["orange"] : Colors.white,
                        content: PopScope(
                          canPop: false,
                          child: Container(
                            width: getWidth(context) * .8,
                            height: getWidth(context) * .5,
                            child: Form(
                              key: folderKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: getWidth(context) * 2 / 15,
                                    height: getWidth(context) * 2 / 15,
                                    child: CircleAvatar(
                                      backgroundColor: const Color.fromARGB(
                                          255, 201, 201, 201),
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
                                      color:
                                          mode ? Colors.white : dayBar["blue2"],
                                    ),
                                    cursorColor:
                                        mode ? Colors.white : dayBar["blue2"],
                                    onChanged: (folderName) {
                                      name = folderName;
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              width: .5,
                                              color: mode
                                                  ? Colors.white
                                                  : dayBar["blue2"],
                                            )),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              width: .5,
                                              color: mode
                                                  ? Colors.white
                                                  : dayBar["blue2"],
                                            )),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            borderSide: BorderSide(
                                              width: 1,
                                              color: mode
                                                  ? Colors.white
                                                  : dayBar["blue2"],
                                            )),
                                        hintText: getDeviceLocale() == "ar"
                                            ? Translation().translateMe[
                                                "Arabic"]!["save_folder"]
                                            : Translation().translateMe[
                                                "English"]!["save_folder"],
                                        hintStyle: TextStyle(
                                          color: mode
                                              ? Colors.white.withOpacity(.5)
                                              : dayBar["blue2"].withOpacity(.4),
                                        )),
                                  ),
                                  BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                                    builder: (context, state) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (folderKey.currentState!
                                                  .validate()) {
                                                try {
                                                  context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(true);
                                              var check = await  _repo.createFolder(name,context, parentId: widget.main[2]);
                                                    if(check){
                                                           context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(false);
                                                  Navigator.pop(context);
                                                  if (!widget.main[0]) {
                                                    context
                                                        .read<
                                                            RefreshFolderCubit>()
                                                        .refreshPage();
                                                  }else{
                                                     context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(false);
                                                  }
                                                    }else{
                                                        context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(false);
                                                    }
                                             
                                                } catch (e) {
                                                   context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(false);

                                                 
                                                  context
                                                      .read<LoadingPdfCubit>()
                                                      .loadingPdf(false);
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
                                            },
                                            child: state is LoadingPdf
                                                ? state.loading
                                                    ? Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                    : Text(
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? Translation()
                                                                        .translateMe[
                                                                    "Arabic"]![
                                                                "save_button"]
                                                            : Translation()
                                                                        .translateMe[
                                                                    "English"]![
                                                                "save_button"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                : Text(
                                                    getDeviceLocale() == "ar"
                                                        ? Translation()
                                                                    .translateMe[
                                                                "Arabic"]![
                                                            "save_button"]
                                                        : Translation()
                                                                    .translateMe[
                                                                "English"]![
                                                            "save_button"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: mode
                                                  ? nightBar["buttons"]
                                                  : dayBar["blue"],
                                            ),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: mode
                                                    ? nightBar["buttons"]
                                                    : dayBar["blue"],
                                              ),
                                              onPressed: () {
                                                if (!(state is LoadingPdf &&
                                                    state.loading)) {
                                                  Navigator.pop(context);
                                                }
                                              },
                                              child: Text(
                                                getDeviceLocale() == "ar"
                                                    ? "إلغاء"
                                                    : "Cancel",
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
                      ),
                    );
                  },
                  child: Container(
                    width: getWidth(context) * 0.3,
                    height: getHeight(context) * 0.15,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: mode ? nightBar["buttons"] : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/add_book.png",
                          width: getWidth(context) * 1 / 10,
                          height: getWidth(context) * 1 / 10,
                        ),
                        Text(
                          getDeviceLocale() == "ar"
                              ? !school.contains(widget.main[1]) &&
                                      widget.main[1]
                                              .toString()
                                              .split("/")
                                              .length ==
                                          1
                                  ? "إضافة كلية"
                                  : Translation()
                                      .translateMe["Arabic"]!["add_folder"]
                              : !school.contains(widget.main[1]) &&
                                      widget.main[1]
                                              .toString()
                                              .split("/")
                                              .length ==
                                          1
                                  ? "Add college"
                                  : Translation()
                                      .translateMe["English"]!["add_folder"],
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: mode ? Colors.white : Colors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
