import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/upload_video_cubit/upload_video_cubit.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/widgets/video_upload.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

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
  var choice = 0;
  var once = true;
  UploadVideo({required this.folder});
  String path = "video/init.mp4";
  // final MathFieldEditingController _controller1 = MathFieldEditingController();
  // final MathFieldEditingController _controller2 = MathFieldEditingController();
  // final MathFieldEditingController _controller3 = MathFieldEditingController();
  // final MathFieldEditingController _controller4 = MathFieldEditingController();
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
        title: Text(
          widget.folder
              .toString()
              .split("/")[widget.folder.toString().split("/").length - 1],
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () async {
                        context.read<LunchLoadingCubit>().lunchLoading(true);
                        final ImagePicker picker = ImagePicker();
                        var pickedVideo =
                            await picker.pickVideo(source: ImageSource.gallery);
                        setState(() {
                          widget.videoPath = pickedVideo!.path;
                          widget.videoFiles = pickedVideo;
                        });
                        var tumb = await getTumb(pickedVideo);
                        setState(() {
                          widget.uint8list = tumb;
                        });
                        context.read<LunchLoadingCubit>().lunchLoading(false);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: getWidth(context),
                        height: getHeight(context) / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                mode ? nightBar["buttons"] : dayBar["blue2"]),
                        child: Center(
                            child: widget.videoPath.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.ondemand_video_sharp,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        getDeviceLocale() == "ar"
                                            ? "اضغط لاختيار فيديو"
                                            : "Click to select a video",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                : state is LunchLoading
                                    ? state.loading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: widget.controller.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                  getDeviceLocale() == "ar"
                                                      ? "اسم الملف : ${widget.videoFiles.name.toString()}"
                                                      : "Name : ${widget.videoFiles.name.toString()}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  getDeviceLocale() == "ar"
                                                      ? "حجم الملف : ${formatFileSize(widget.names[0])}"
                                                      : "Size : ${formatFileSize(widget.names[0])}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                leading: Container(
                                                  width: getWidth(context) / 3,
                                                  child: widget
                                                          .controller[index]
                                                          .value
                                                          .isInitialized
                                                      ? AspectRatio(
                                                          aspectRatio: widget
                                                              .controller[index]
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () async {
                        context.read<LoadingPdfCubit>().loadingPdf(true);
                        final ImagePicker picker = ImagePicker();
                        var pickedPdf = await picker.pickMultipleMedia();
                        setState(() {
                          widget.pdfFiles.clear();
                          widget.pdfPath.clear();
                          for (var i = 0; i < pickedPdf.length; i++) {
                            widget.pdfPath.add(pickedPdf[i].path);
                            widget.pdfFiles.add(pickedPdf[i]);
                          }
                        });
                        await initPdf(widget.pdfFiles);

                        context.read<LoadingPdfCubit>().loadingPdf(false);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: getWidth(context),
                        height: getHeight(context) / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                mode ? nightBar["buttons"] : dayBar["blue2"]),
                        child: Center(
                            child: widget.pdfPath.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.picture_as_pdf_outlined,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        getDeviceLocale() == "ar"
                                            ? "اضغط لاختيار الملفات"
                                            : "Click to select a pdf",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )
                                : state is LoadingPdf
                                    ? state.loading
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          )
                                        : ListView.builder(
                                            itemCount: widget.pdfPath.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                  getDeviceLocale() == "ar"
                                                      ? "اسم الملف : ${widget.pdfFiles[index].name.toString()}"
                                                      : "Name : ${widget.pdfFiles[index].name.toString()}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                subtitle: Text(
                                                  getDeviceLocale() == "ar"
                                                      ? "حجم الملف : ${formatFileSize(widget.pdfLengths[index])}"
                                                      : "Size : ${formatFileSize(widget.pdfLengths[index])}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                leading: Container(
                                                    width:
                                                        getWidth(context) / 3,
                                                    child: Icon(
                                                      Icons.picture_as_pdf,
                                                      size: 50,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 116, 16, 9),
                                                    )),
                                              );
                                            },
                                          )
                                    : Container()),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: getWidth(context),
                  height: getHeight(context) / 3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: mode ? nightBar["buttons"] : dayBar["blue2"]),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.que.length,
                          itemBuilder: (context, index) => widget.que[index],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      Text(
                                        getDeviceLocale() == "ar"
                                            ? "إضافة سؤال نصّي"
                                            : "Add a text question",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  )),
                              // ElevatedButton(
                              //     style: ElevatedButton.styleFrom(
                              //         backgroundColor: mode
                              //             ? nightBar["buttons"]
                              //             : dayBar["blue"]),
                              //     onPressed: () {
                              //       setState(() {
                              //         widget.que.add(quation_text());
                              //       });
                              //     },
                              //     child: Row(
                              //       children: [
                              //         Icon(
                              //           Icons.one_x_mobiledata_rounded,
                              //           color: Colors.white,
                              //         ),
                              //         Text(
                              //           getDeviceLocale() == "ar"
                              //               ? "إضافة معادلة "
                              //               : "Add equation",
                              //           style: TextStyle(color: Colors.white),
                              //         )
                              //       ],
                              //     )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: getWidth(context) / 3,
                height: getHeight(context) / 15,
                child: BlocConsumer<UploadVideoCubit, UploadVideoState>(
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
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(),
                        onPressed: () async {
                          if (widget.controller.isEmpty ||
                              widget.que.isEmpty ||
                              widget.questions.isEmpty ||
                              widget.answers.isEmpty ||
                              widget.choices.isEmpty ||
                              widget.pdfFiles.isEmpty) {
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
                            await context.read<UploadVideoCubit>().saveCourse(
                                videoPath: widget.videoFiles.path,
                                courseName: widget.folder,
                                pdfPaths: widget.pdfFiles,
                                questions: widget.questions,
                                choices: widget.choices,
                                answers: widget.answers,
                                videoName: widget.videoPath,
                                context: context);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => MainScreen(),),
                                (Route<dynamic> route) => false);
                            context.read<RefreshFolderCubit>().refreshPage();
                            
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload,
                              color: Colors.white,
                            ),
                            Text(
                              getDeviceLocale() == "ar" ? "نشر" : "Upload",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Column quation_text() {
  //   var index = widget.que.length;
  //   return Column(
  //     children: [
  //       Text(
  //         getDeviceLocale() == "ar"
  //             ? "السؤال رقم ${widget.que.length + 1}"
  //             : "َQuestion number ${widget.que.length + 1}",
  //         style: TextStyle(color: Colors.white),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MathField(
  //           key: ValueKey(index),
  //           // No parameters are required.
  //           keyboardType: MathKeyboardType
  //               .expression, // Specify the keyboard type (expression or number only).
  //           variables: const [
  //             'x',
  //             'y',
  //             'z',
  //             " = ",
  //             "->"
  //           ], // Specify the variables the user can use (only in expression mode).
  //           decoration: InputDecoration(
  //               hintText: getDeviceLocale() == "ar"
  //                   ? "اكتب المعادلة هنا..."
  //                   : "Write the equation here...",
  //               hintStyle: TextStyle(color: Colors.white.withOpacity(.5)),
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(20)),
  //                   borderSide: BorderSide(width: .5, color: Colors.white)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.all(Radius.circular(20)),
  //                   borderSide: BorderSide(
  //                       width: .5,
  //                       color: Colors
  //                           .white))), // Decorate the input field using the familiar InputDecoration.
  //           onChanged: (value) {
  //             if ((widget.questions.length < index + 1)) {
  //               setState(() {
  //                 widget.currentValue = value;

  //                 widget.questions.add(widget.currentValue);
  //               });
  //             } else {
  //               widget.currentValue = value;
  //               widget.questions[index] = widget.currentValue;
  //             }
  //           },

  //           autofocus: true, // Enable or disable autofocus of the input field.
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MathField(
  //           onChanged: (value) {
  //             if ((widget.choices.length < (((index + 1) * 3) - 2)) ||
  //                 widget.choices.isEmpty) {
  //               widget.choices.add(value);
  //             } else {
  //               widget.choices[(((index + 1) * 3) - 3)] = value;
  //             }
  //           },
  //           decoration: InputDecoration(
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: .5, color: Colors.white)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: 1, color: Colors.white)),
  //               hintText: getDeviceLocale() == "ar"
  //                   ? "اكتب الخيار الأول هنا ..."
  //                   : "Write the first answer here ...",
  //               hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MathField(
  //           onChanged: (value) {
  //             if ((widget.choices.length < (((index + 1) * 3) - 1)) ||
  //                 widget.choices.isEmpty) {
  //               widget.choices.add(value);
  //             } else {
  //               widget.choices[(((index + 1) * 3) - 2)] = value;
  //             }
  //           },
  //           decoration: InputDecoration(
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: .5, color: Colors.white)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: 1, color: Colors.white)),
  //               hintText: getDeviceLocale() == "ar"
  //                   ? "اكتب الخيار الثاني هنا ..."
  //                   : "Write the second answer here ...",
  //               hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: MathField(
  //           onChanged: (value) {
  //             if ((widget.choices.length < (((index + 1) * 3))) ||
  //                 widget.choices.isEmpty) {
  //               widget.choices.add(value);
  //             } else {
  //               widget.choices[(((index + 1) * 3) - 1)] = value;
  //             }
  //           },
  //           decoration: InputDecoration(
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: .5, color: Colors.white)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: 1, color: Colors.white)),
  //               hintText: getDeviceLocale() == "ar"
  //                   ? "اكتب الخيار الثالث هنا ..."
  //                   : "Write the third answer here ...",
  //               hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
  //         ),
  //       ),
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: TextField(
  //           keyboardType: TextInputType.numberWithOptions(),
  //           onChanged: (value) {
  //             if ((widget.answers.length < index + 1)) {
  //               setState(() {
  //                 widget.currentValue = value;
  //                 widget.answers.add(widget.currentValue);
  //               });
  //             } else {
  //               widget.answers[index] = value;
  //             }
  //           },
  //           decoration: InputDecoration(
  //               enabledBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: .5, color: Colors.white)),
  //               focusedBorder: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                   borderSide: BorderSide(width: 1, color: Colors.white)),
  //               hintText: getDeviceLocale() == "ar"
  //                   ? "اكتبر رقم الجواب الصحيح هنا ..."
  //                   : "Write the correct answer here ...",
  //               hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Column text_question() {
    var index = widget.que.length;
    return Column(
      children: [
        Text(
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
              if ((widget.choices.length < (((index + 1) * 3) - 2)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 3) - 3)] = value;
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
              if ((widget.choices.length < (((index + 1) * 3) - 1)) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 3) - 2)] = value;
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
              if ((widget.choices.length < (((index + 1) * 3))) ||
                  widget.choices.isEmpty) {
                widget.choices.add(value);
              } else {
                widget.choices[(((index + 1) * 3) - 1)] = value;
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
      print("++++++++++++++++++++++++++++++++++++++++");
      print(e);
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
      print("++++++++++++++++++++++++++++++++++++++++0000");
      print(e);
    }

    return widget.names;
  }
}
