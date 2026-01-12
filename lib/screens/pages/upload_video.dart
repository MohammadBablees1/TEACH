import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/upload_video_cubit/upload_video_cubit.dart';
import 'package:teach/cubit/whate_to_uploade/whate_to_uploade_cubit.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

import 'package:teach/widgets/video_upload.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

// ignore: must_be_immutable
class UploadVideo extends StatefulWidget {
  var folder;
  var videoPath = "", videoFiles = XFile("");
  var pdfPath = [], pdfFiles = [], pdfLengths = [];
  var names = [];
  var uint8list = [];
  num totalSize = 0;
  List<dynamic> controller = [];
  List<Widget> que = [];
  List<String> questions = [];
  List<String> answers = [];
  List<String> choices = [];
  var currentValue = "";
  var selectedImage = "";
  XFile imageFile = XFile("images/icon.jpg");
  var choice = 0;
  var once = true;
  var parent_id;
  var nameController = TextEditingController();
  var priceController = TextEditingController(text: "");
  var curceFolder = false;
  var subjectFolder = false;
  var isFree = false;
  UploadVideo({required this.folder, required this.parent_id});
  String path = "video/init.mp4";
  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  @override
  void dispose() {
    // Dispose all video controllers
    for (var controller in widget.controller) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          widget.folder.toString(),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: BlocBuilder<WhateToUploadeCubit, WhateToUploadeState>(
            builder: (context, selected) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                true, false, false, false, false, false);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.all
                                        ? const Color.fromRGBO(41, 124, 44, 1)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selected is SelectToUploade && selected.all
                                        ? const Color.fromARGB(255, 47, 170, 52)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "الكل" : "All",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                false, true, false, false, false, false);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.video
                                        ? const Color.fromARGB(255, 41, 124, 44)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color: selected is SelectToUploade &&
                                        selected.video
                                    ? const Color.fromARGB(255, 47, 170, 52)
                                    : mode
                                        ? nightBar["orange"]
                                        : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "فيديو" : "Video",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                false, false, false, false, false, true);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.teacher
                                        ? const Color.fromARGB(255, 41, 124, 44)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color: selected is SelectToUploade &&
                                        selected.teacher
                                    ? const Color.fromARGB(255, 47, 170, 52)
                                    : mode
                                        ? nightBar["orange"]
                                        : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "مدرّس" : "Teacher",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                false, false, true, false, false, false);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.pdf
                                        ? const Color.fromARGB(255, 41, 124, 44)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    selected is SelectToUploade && selected.pdf
                                        ? const Color.fromARGB(255, 47, 170, 52)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "pdf" : "pdf",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                false, false, false, false, true, false);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.folder
                                        ? const Color.fromARGB(255, 41, 124, 44)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color: selected is SelectToUploade &&
                                        selected.folder
                                    ? const Color.fromARGB(255, 47, 170, 52)
                                    : mode
                                        ? nightBar["orange"]
                                        : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "مجلّد" : "file",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<WhateToUploadeCubit>().select(
                                false, false, false, true, false, false);
                          },
                          child: Container(
                            width: getWidth(context) * .1,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: selected is SelectToUploade &&
                                            selected.questionBank
                                        ? const Color.fromARGB(255, 41, 124, 44)
                                        : mode
                                            ? nightBar["orange"]
                                            : dayBar["blue2"]),
                                borderRadius: BorderRadius.circular(20),
                                color: selected is SelectToUploade &&
                                        selected.questionBank
                                    ? const Color.fromARGB(255, 47, 170, 52)
                                    : mode
                                        ? nightBar["orange"]
                                        : dayBar["blue"]),
                            child: Center(
                              child: AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar"
                                    ? "أسئلة"
                                    : "Questions",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        return nameValidator(value!);
                      },
                      controller: widget.nameController,
                      cursorColor: dayBar["blue"],
                      keyboardType: TextInputType.name,
                      onChanged: (folderName) {},
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: .5, color: dayBar["blue"])),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: .5, color: dayBar["blue"])),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 1, color: dayBar["blue"])),
                        hintText: getDeviceLocale() == "ar"
                            ? "اكتب اسم المجلد هنا..."
                            : "Type your folder name here...",
                        hintStyle: TextStyle(),
                        prefixIcon: Icon(
                          Icons.folder,
                          color: dayBar["blue2"],
                        ),
                      ),
                      style: TextStyle(color: dayBar["blue"]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        var pickedImage =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          widget.selectedImage = pickedImage!.path;
                          widget.imageFile = pickedImage;
                        });
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: getWidth(context),
                        height: getHeight(context) / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: mode ? nightBar["buttons"] : dayBar["blue3"],
                        ),
                        child: Center(
                          child: widget.selectedImage == ""
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
                                          ? "اضغط لاختيار صورة "
                                          : "Click to select an image",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    width: getWidth(context),
                                    File(widget.selectedImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  selected is SelectToUploade &&
                          (selected.all || selected.video)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  final ImagePicker picker = ImagePicker();
                                  var pickedVideo = await picker.pickVideo(
                                      source: ImageSource.gallery);
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(true);
                                  if (pickedVideo == null) {
                                    context
                                        .read<LunchLoadingCubit>()
                                        .lunchLoading(false);
                                  }
                                  setState(() {
                                    widget.videoPath = pickedVideo!.path;
                                    widget.videoFiles = pickedVideo;
                                  });
                                  var tumb = await getTumb(pickedVideo);
                                  setState(() {
                                    widget.uint8list = tumb;
                                  });
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(false);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: getWidth(context),
                                  height: getHeight(context) / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: mode
                                          ? nightBar["buttons"]
                                          : dayBar["blue3"]),
                                  child: Center(
                                      child: widget.videoPath.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.ondemand_video_sharp,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "اضغط لاختيار فيديو"
                                                      : "Click to select a video",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          : state is LunchLoading
                                              ? state.loading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount: widget
                                                          .controller.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "اسم الملف : ${widget.videoFiles.name.toString()}"
                                                                : "Name : ${widget.videoFiles.name.toString()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          subtitle:
                                                              AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "حجم الملف : ${formatFileSize(widget.names[0])}"
                                                                : "Size : ${formatFileSize(widget.names[0])}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          leading: Container(
                                                            width: getWidth(
                                                                    context) /
                                                                3,
                                                            child: widget
                                                                    .controller[
                                                                        index]
                                                                    .value
                                                                    .isInitialized
                                                                ? AspectRatio(
                                                                    aspectRatio: widget
                                                                        .controller[
                                                                            index]
                                                                        .value
                                                                        .aspectRatio,
                                                                    child: VideoPlayer(
                                                                        widget.controller[
                                                                            index]),
                                                                  )
                                                                : Center(
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                          ),
                                                        );
                                                      },
                                                    )
                                              : Container()),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade &&
                          (selected.folder || selected.teacher)
                      ? SwitchListTile(
                          value: widget.curceFolder,
                          activeColor: mode
                              ? nightBar["orange"]
                              : const Color.fromARGB(255, 11, 85, 145),
                          onChanged: (value) {
                            setState(() {
                              widget.curceFolder = value;
                            });
                          },
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? " مجلّد كورس"
                                : "Course folder",
                            style: TextStyle(),
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade && (selected.folder)
                      ? SwitchListTile(
                          value: widget.subjectFolder,
                          activeColor: mode
                              ? nightBar["orange"]
                              : const Color.fromARGB(255, 11, 85, 145),
                          onChanged: (value) {
                            setState(() {
                              widget.subjectFolder = value;
                            });
                          },
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? " مجلّد مادة"
                                : "Subject folder",
                            style: TextStyle(),
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade &&
                          (selected.folder || selected.teacher) &&
                          widget.curceFolder
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              return nameValidator(value!);
                            },
                            controller: widget.priceController,
                            cursorColor: dayBar["blue"],
                            keyboardType: TextInputType.name,
                            onChanged: (folderName) {},
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: .5, color: dayBar["blue"])),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: .5, color: dayBar["blue"])),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      width: 1, color: dayBar["blue"])),
                              hintText: getDeviceLocale() == "ar"
                                  ? "اكتب سعر المجلد هنا..."
                                  : "Type your folder price here...",
                              hintStyle: TextStyle(),
                              prefixIcon: Icon(
                                Icons.folder,
                                color: dayBar["blue2"],
                              ),
                            ),
                            style: TextStyle(color: dayBar["blue"]),
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade && (selected.all || selected.pdf)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                            builder: (context, state) {
                              return InkWell(
                                onTap: () async {
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(true);
                                  final ImagePicker picker = ImagePicker();
                                  var pickedPdf =
                                      await picker.pickMultipleMedia();
                                  setState(() {
                                    widget.pdfFiles.clear();
                                    widget.pdfPath.clear();
                                    for (var i = 0; i < pickedPdf.length; i++) {
                                      widget.pdfPath.add(pickedPdf[i].path);
                                      widget.pdfFiles.add(pickedPdf[i]);
                                    }
                                  });
                                  await initPdf(widget.pdfFiles);

                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  width: getWidth(context),
                                  height: getHeight(context) / 3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: mode
                                          ? nightBar["buttons"]
                                          : dayBar["blue3"]),
                                  child: Center(
                                      child: widget.pdfPath.isEmpty
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.picture_as_pdf_outlined,
                                                  size: 50,
                                                  color: Colors.white,
                                                ),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "اضغط لاختيار الملفات"
                                                      : "Click to select a pdf",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            )
                                          : state is LoadingPdf
                                              ? state.loading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : ListView.builder(
                                                      itemCount:
                                                          widget.pdfPath.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          title: AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "اسم الملف : ${widget.pdfFiles[index].name.toString()}"
                                                                : "Name : ${widget.pdfFiles[index].name.toString()}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          subtitle:
                                                              AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "حجم الملف : ${formatFileSize(widget.pdfLengths[index])}"
                                                                : "Size : ${formatFileSize(widget.pdfLengths[index])}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          leading: Container(
                                                              width: getWidth(
                                                                      context) /
                                                                  3,
                                                              child: Icon(
                                                                Icons
                                                                    .picture_as_pdf,
                                                                size: 50,
                                                                color: const Color
                                                                    .fromARGB(
                                                                    255,
                                                                    116,
                                                                    16,
                                                                    9),
                                                              )),
                                                        );
                                                      },
                                                    )
                                              : Container()),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade &&
                          !(selected.teacher || selected.folder)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: getWidth(context),
                            height: getHeight(context) / 3,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: mode
                                    ? nightBar["buttons"]
                                    : dayBar["blue3"]),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: widget.que.length,
                                    itemBuilder: (context, index) =>
                                        widget.que[index],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: mode
                                                    ? nightBar["buttons"]
                                                    : dayBar["blue"]),
                                            onPressed: () {
                                              setState(() {
                                                widget.que.add(
                                                  text_question(),
                                                );
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.text_fields,
                                                  color: Colors.white,
                                                ),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "إضافة سؤال نصّي"
                                                      : "Add a text question",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade &&
                          (selected.video ||
                              selected.pdf ||
                              selected.all ||
                              selected.questionBank)
                      ? SwitchListTile(
                          value: widget.isFree,
                          activeColor: mode
                              ? nightBar["orange"]
                              : const Color.fromARGB(255, 11, 85, 145),
                          onChanged: (value) {
                            setState(() {
                              widget.isFree = value;
                            });
                          },
                          title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar" ? "مجاني" : "free",
                            style: TextStyle(),
                          ),
                        )
                      : Container(),
                  selected is SelectToUploade
                      ? Container(
                          width: getWidth(context) / 3,
                          height: getHeight(context) / 15,
                          child:
                              BlocConsumer<UploadVideoCubit, UploadVideoState>(
                            listener: (context, state) {
                              if (widget.once) {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) => VideoUpload(),
                                );
                                widget.once = false;
                              }
                            },
                            builder: (context, state) {
                              return BlocBuilder<LunchLoadingCubit,
                                  LunchLoadingState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                      style: ElevatedButton.styleFrom(),
                                      onPressed: () async {
                                        if ((widget.controller.isEmpty &&
                                                (selected.all ||
                                                    selected.video)) ||
                                            ((selected.questionBank) &&
                                                (widget.nameController.text
                                                        .isEmpty ||
                                                    widget.questions.isEmpty ||
                                                    widget.choices.length !=
                                                        widget.questions
                                                                .length *
                                                            5 ||
                                                    widget.answers.isEmpty ||
                                                    widget.answers.length !=
                                                        widget.questions
                                                            .length)) ||
                                            (widget.pdfFiles.isEmpty &&
                                                (selected.all ||
                                                    selected.pdf)) ||
                                            (widget.pdfFiles.isNotEmpty &&
                                                (selected.pdf) &&
                                                widget.nameController.text
                                                    .isEmpty) ||
                                            (widget.choices.length !=
                                                widget.questions.length * 5) ||
                                            (await checkVedio() == 0 &&
                                                (widget.videoPath.isEmpty &&
                                                    widget.pdfPath.isEmpty &&
                                                    widget
                                                        .questions.isEmpty)) ||
                                            (await checkVedio() == 1 &&
                                                (widget.videoPath.isNotEmpty ||
                                                    widget.pdfPath.isNotEmpty ||
                                                    widget.questions
                                                        .isNotEmpty))) {
                                          lunchAwesomDialoge(
                                              DialogType.error,
                                              "e",
                                              getDeviceLocale() == "ar"
                                                  ? "لا يمكن تنفيذ العملية"
                                                  : "Chose a video file please!",
                                              context,
                                              getWidth(context),
                                              getHeight(context));
                                        } else {
                                          context
                                              .read<LunchLoadingCubit>()
                                              .lunchLoading(true);
                                          var size = "";
                                          if (widget.videoPath.isNotEmpty) {
                                            size =
                                                formatFileSize(widget.names[0])
                                                    .toString();
                                          }
                                          await context
                                              .read<UploadVideoCubit>()
                                              .saveCourse(
                                                  parent_id: widget.parent_id,
                                                  price:
                                                      widget
                                                          .priceController.text
                                                          .trim(),
                                                  videoPath: widget
                                                      .videoFiles.path,
                                                  courseName:
                                                      widget
                                                          .nameController.text,
                                                  pdfPaths: widget.pdfFiles,
                                                  questions: widget.questions,
                                                  choices: widget.choices,
                                                  answers: widget.answers,
                                                  videoName:
                                                      widget
                                                              .videoPath.isEmpty
                                                          ? widget
                                                              .nameController
                                                              .text
                                                              .trim()
                                                          : widget.videoPath,
                                                  context: context,
                                                  imagePath:
                                                      widget.selectedImage,
                                                  locked: widget.curceFolder,
                                                  isTeacher: selected.teacher,
                                                  isFolder: selected.folder,
                                                  isFree: widget.isFree,
                                                  size: size,
                                                  isSubject:
                                                      widget.subjectFolder);
                                          context
                                              .read<LunchLoadingCubit>()
                                              .lunchLoading(false);
                                          int count = 0;
                                          Navigator.popUntil(context, (route) {
                                            count++;
                                            return count ==
                                                3; // لأن الشرط يتحقق بعد 2 عملية pop
                                          });
                                          context
                                              .read<RefreshFolderCubit>()
                                              .refreshPage();
                                        }
                                      },
                                      child:
                                          state is LunchLoading && state.loading
                                              ? CircularProgressIndicator(
                                                  color: Colors.white,
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.upload,
                                                      color: Colors.white,
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      getDeviceLocale() == "ar"
                                                          ? "نشر"
                                                          : "Upload",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ));
                                },
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column text_question() {
    var index = widget.que.length;
    return Column(
      children: [
        AutoSizeText(
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          minFontSize: 10,
          maxFontSize: 15,
          getDeviceLocale() == "ar"
              ? "السؤال رقم ${widget.que.length + 1}"
              : "َQuestion number ${widget.que.length + 1}",
          style: TextStyle(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.questions.length < index + 1)) {
                setState(() {
                  widget.currentValue = value;
                  widget.questions.add(widget.currentValue);
                });
              } else {
                widget.currentValue = value;
                widget.questions[index] = widget.currentValue;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب السؤال هنا ..."
                    : "Write the question here ...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              
              if ((widget.choices.length < (((index + 1) * 5) - 4)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
                
              } else {
                widget.choices[(((index + 1) * 5) - 4) - 1] = value;
               
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب الخيار الأول هنا ..."
                    : "Write the first answer here ...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.choices.length < (((index + 1) * 5) - 3)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 5) - 3) - 1] = value;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب الخيار الثاني هنا ..."
                    : "Write the second answer here ...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.choices.length < (((index + 1) * 5) - 2)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 5) - 2) - 1] = value;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب الخيار الثالث هنا ..."
                    : "Write the third answer here ...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.choices.length < (((index + 1) * 5) - 1)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 5) - 1) - 1] = value;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب الخيار الرابع هنا ..."
                    : "Write the fourth option here...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.choices.length < (((index + 1) * 5))) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 5)) - 1] = value;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب الخيار الخامس هنا ..."
                    : "Write the fifth option here...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            keyboardType: TextInputType.number,
            key: ValueKey(index),
            onChanged: (value) {
              if ((widget.answers.length < index + 1)) {
                setState(() {
                  widget.currentValue = value;
                  widget.answers.add(widget.currentValue);
                });
              } else {
                widget.answers[index] = value;
              }
            },
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: .5, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(width: 1, color: Colors.white)),
                hintText: getDeviceLocale() == "ar"
                    ? "اكتب رقم الجواب الصحيح هنا ..."
                    : "Write the correct answer here ...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
          ),
        ),
      ],
    );
  }

  Future getTumb(pickedVideo) async {
//     var status = await Permission.storage.request();
// if (status.isGranted) {
//   print('Storage permission granted.');
// } else {
//   print('Storage permission denied.');
// }
    try {
      if (widget.controller.isNotEmpty) {
        widget.controller.clear();
      }
      widget.names.clear();
      widget.names.add(await pickedVideo.length());

      if (pickedVideo != null) {
        // Dispose old controllers
        for (var controller in widget.controller) {
          controller.dispose();
        }

        // Update picked videos and controllers

        final controller = VideoPlayerController.file(File(pickedVideo.path));

        await controller.initialize(); // Await initialization
        widget.controller.add(controller);

        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return widget.names;
  }

  Future initPdf(pickedPdf) async {
    try {
      widget.pdfLengths.clear();
      for (var i = 0; i < pickedPdf.length; i++) {
        widget.pdfLengths.add(await pickedPdf[i].length());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return widget.names;
  }

  Future<int> checkVedio() async {
    try {
      var data = await supabase
          .from("curces")
          .select()
          .eq("folder_id", widget.parent_id);

      var folders = await supabase
          .from("folders")
          .select()
          .eq("parent_id", widget.parent_id);

      if (data.isNotEmpty) {
        return 0;
      } else if (folders.isNotEmpty) {
        return 1;
      } else {
        return 2;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return 2;
  }
}
