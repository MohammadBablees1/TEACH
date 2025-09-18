import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/managerScreen/manager_screen_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class AddFolder extends StatefulWidget {
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  State<AddFolder> createState() => _AddFolderState();
}

class _AddFolderState extends State<AddFolder> {
  var selectedImage = "";

  XFile imageFile = XFile("images/icon.jpg");

  var title = "";

  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mode ? nightBar["orange"] : dayBar["blue3"],
      child: WillPopScope(
        onWillPop: () {
          context.read<ManagerScreenCubit>().changeIndex(0);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getWidth(context) * .4,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getWidth(context) * .05),
                      child: SizedBox(
                          width: getWidth(context) * .15,
                          height: getWidth(context) * .15,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "images/add-folder.png",
                                width: getWidth(context),
                                fit: BoxFit.cover,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Center(
                          child: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "إنشاء مجلّد جديد"
                                : "Create new folder",
                            style: TextStyle(
                                fontSize: getWidth(context) * .05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getHeight(context) - (getWidth(context) * .4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: mode ? Colors.black : Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          var pickedImage = await picker.pickImage(
                              source: ImageSource.gallery);

                          setState(() {
                            selectedImage = pickedImage!.path;

                            imageFile = pickedImage;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: getWidth(context),
                          height: getHeight(context) * .3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: mode ? nightBar["buttons"] : dayBar["blue3"],
                          ),
                          child: Center(
                            child: selectedImage == ""
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "اضغط لاختيار صورة للملف"
                                            : "Click to select an image for the folder",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      width: getWidth(context),
                                      File(selectedImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (value) {
                          return nameValidator(value!);
                        },
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        cursorColor: mode ? Colors.white : dayBar["blue"],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: .5,
                                  color: mode ? Colors.white : dayBar["blue"])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: .5,
                                  color: mode ? Colors.white : dayBar["blue"])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: mode ? Colors.white : dayBar["blue"])),
                          hintText: getDeviceLocale() == "ar"
                              ? "اكتب الاسم المجلّد هنا  ..."
                              : "Write file name here...",
                          prefixIcon: Icon(
                            Icons.person,
                            color: mode ? Colors.white : dayBar["blue2"],
                          ),
                        ),
                        style: TextStyle(
                            color: mode ? Colors.white : dayBar["blue"]),
                      ),
                    ),
                    BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () async {
                              if (selectedImage.isEmpty || nameController.text.isEmpty) {
                                lunchAwesomDialoge(
                                    DialogType.error,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "يرجى تعبئة جميع الحقول"
                                        : "Please fill in all fields.",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              } else {
                                try {
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(true);

                                  FolderRepository repo =
                                      FolderRepository(supabase);
                                  await repo.createFolder(
                                      selectedImage: selectedImage,
                                      // ignore: use_build_context_synchronously
                                      nameController.text.trim(),
                                      // ignore: use_build_context_synchronously
                                      context);
                                  // ignore: use_build_context_synchronously
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  lunchAwesomDialoge(
                                      DialogType.success,
                                      "s",
                                      getDeviceLocale() == "ar"
                                          ? "تمّت العملية بنجاح"
                                          : "The operation was successful.",
                                      context,
                                      getWidth(context),
                                      getHeight(context));
                                } catch (e) {
                                  // ignore: use_build_context_synchronously
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  if (kDebugMode) {
                                    print(e);
                                  }
                                }
                              }
                            },
                            child: state is LoadingPdf && state.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "ترفيع"
                                        : "upload",
                                    style: const TextStyle(color: Colors.white),
                                  ));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
