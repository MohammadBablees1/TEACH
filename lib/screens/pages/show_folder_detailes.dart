import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_firestorage/cached_firestorage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:pod_player/pod_player.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/cubit/timer_cubit/timer_cubit_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/consts/sql_const.dart';
import 'package:teach/data/modules/folders.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/check_connection.dart';
import 'package:teach/screens/pages/play_video.dart';
import 'package:teach/screens/pages/upload_video.dart';
import 'package:teach/widgets/add_choice.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail_imageview/video_thumbnail_imageview.dart';

class ShowFolderDetailes extends StatefulWidget {
  var loading = false;
  var folder;
  var vedio = false;
  List<dynamic> unit8List = [];
  List mp4Urls = [];
  var currentData = {};
  List localData = [];
  var parentId;
  ShowFolderDetailes({required this.folder, required this.parentId});

  @override
  State<ShowFolderDetailes> createState() => _ShowFolderDetailesState();
}

class _ShowFolderDetailesState extends State<ShowFolderDetailes> {
  static final customCachManager = CacheManager(Config(
    'customCacheKey1',
    stalePeriod: Duration(days: 7),
  ));
  // late final PodPlayerController controller;
  // @override
  // void initState() {
  //   init();
  //   super.initState();
  // }

  // init() async {
  //   controller =  PodPlayerController(
  //     podPlayerConfig: const PodPlayerConfig(
  //         autoPlay: false, isLooping: false, videoQualityPriority: [720, 360]),
  //     playVideoFrom: PlayVideoFrom.network(
  //       'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
  //     ),
  //   )
  //     ..initialise();
  // }
  final FolderRepository _repo = FolderRepository(supabase);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await initVideos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefreshFolderCubit, RefreshFolderState>(
      listener: (context, state) {
        // initVideos();
      },
      builder: (context, state) {
        return Scaffold(
          extendBody: true,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            centerTitle: true,
            title: Text(
              widget.folder.toString().split("/").last,
            ),
            leading: IconButton(
                onPressed: () {
                  if (!widget.loading) {
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                )),
          ),
          floatingActionButton: checkPermision()
              ? BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                  builder: (context, state) {
                    return FloatingActionButton(
                      backgroundColor:
                          mode ? nightBar["orange"] : dayBar["blue2"],
                      onPressed: () async {
                        context.read<LunchLoadingCubit>().lunchLoading(true);

                        await checkVideoPermision(parentId: widget.parentId);
                        context.read<LunchLoadingCubit>().lunchLoading(false);
                      },
                      child: state is LunchLoading && state.loading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.white,
                            ),
                    );
                  },
                )
              : Container(),
          body: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) => SafeArea(
              child: Column(
                children: [
                  FutureBuilder(
                      future: checkConnection(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: getWidth(context),
                            height: getHeight(context),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                      child: Image.asset("images/loading.gif")),
                                ],
                              ),
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data! == true) {
                          return FutureBuilder(
                            future: getChilde(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  width: getWidth(context),
                                  height: getHeight(context),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Image.asset(
                                                "images/loading.gif")),
                                      ],
                                    ),
                                  ),
                                );
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return Container(
                                  width: getWidth(context),
                                  height: getHeight(context),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: NoDataFound()),
                                    ],
                                  ),
                                );
                              } else {
                                var data = snapshot.data;

                                var box = Hive.box(hiveBoxName);

                                box.put("${widget.folder}_check", widget.vedio);

                                var copyData = List.from(data!);
                                if (widget.vedio) {
                                  var box = Hive.box(hiveBoxName);
                                  List localVedioName = [];
                                  for (var i = 0; i < copyData.length; i++) {
                                    var vedioName = copyData[i]["name"];
                                    localVedioName.add(vedioName);
                                  }
                                  box.put(
                                      "${widget.folder}_video", localVedioName);
                                }

                                return folders(copyData, data, false);
                              }
                            },
                          );
                        } else {
                          return Container(
                              width: getWidth(context),
                              height: getHeight(context),
                              child: Center(child: NoInternet()));
                        }
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AnimationLimiter folders(copyData, data, offline) {
    return AnimationLimiter(
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1.5,
        ),
        itemCount: widget.vedio
            ? copyData.length
            : offline
                ? data.length
                : data.length,
        itemBuilder: (context, index) {
          if (!widget.vedio && !offline) {
            var box = Hive.box(hiveBoxName);
            List q = [];
            for (var i = 0; i < data.length; i++) {
              q.add(data[i].name);
            }
            box.put(
                widget.folder
                    .toString()
                    .split("/")[widget.folder.toString().split("/").length - 1],
                q);
          }

          return widget.vedio
              ? AnimationConfiguration.staggeredGrid(
                  position: index,
                  columnCount: 2,
                  duration: Duration(milliseconds: 500),
                  child: ScaleAnimation(
                    duration: Duration(milliseconds: 800),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () async {
                          var data = await supabase
                              .from("current_user")
                              .select()
                              .eq("id", supabase.auth.currentUser!.id);
                          String code =
                              "${data[0]["category"]}-${data[0]["collage"] ?? ""}";
                          var codes = data[0]["codes"] ?? "";
                          var check = false;

                          if (code is List) {
                            for (var i = 0; i < codes.length; i++) {
                              if (codes[i]
                                  .toString()
                                  .contains("$code-${widget.folder}")) {
                                check = true;
                              }
                            }
                          } else if (codes != "") {
                            if (codes
                                .toString()
                                .contains("$code-${widget.folder}")) {
                              check = true;
                            }
                          }

                          var box = Hive.box(hiveBoxName);
                          if (check || index == 0 || box.get(isMainManager)) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlayVideo(
                                data: copyData[index],
                                name: offline
                                    ? copyData[index]
                                    : copyData[index]["name"],
                              ),
                            ));
                          } else {
                            lunchAwesomDialoge(
                                DialogType.info,
                                "i",
                                getDeviceLocale() == "ar"
                                    ? "الفيديو مغلق، يرجى زيارة نقاط البيع"
                                    : "Video is closed, please visit the points of sale",
                                context,
                                getWidth(context),
                                getHeight(context));
                          }
                        },
                        onLongPressStart: (details) {
                          if (checkPermision()) {
                            final RenderBox overlay = Overlay.of(context)
                                .context
                                .findRenderObject() as RenderBox;
                            final Offset position =
                                overlay.globalToLocal(details.globalPosition);
                            final RelativeRect positionRelativeToScreen =
                                RelativeRect.fromLTRB(
                              position.dx,
                              position.dy,
                              MediaQuery.of(context).size.width - position.dx,
                              MediaQuery.of(context).size.height - position.dy,
                            );
                            showMenu(
                                color: mode ? nightBar["orange"] : Colors.white,
                                context: context,
                                position: positionRelativeToScreen,
                                items: <PopupMenuEntry<dynamic>>[
                                  PopupMenuItem(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            backgroundColor: mode
                                                ? nightBar["orange"]
                                                : dayBar["blue"],
                                            content: Container(
                                              width: getWidth(context) / 4,
                                              height: getHeight(context) / 8,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    getDeviceLocale() == "ar"
                                                        ? "هل أنت متأكد ؟"
                                                        : "Are you sure?",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      BlocBuilder<
                                                          LoadingPdfCubit,
                                                          LoadingPdfState>(
                                                        builder:
                                                            (context, state) {
                                                          return ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              if (await checkConnection()) {
                                                                context
                                                                    .read<
                                                                        LoadingPdfCubit>()
                                                                    .loadingPdf(
                                                                        true);
                                                                await _repo.deleteVideo(
                                                                    copyData[
                                                                        index],
                                                                    context,
                                                                    widget
                                                                        .parentId);
                                                                context
                                                                    .read<
                                                                        LoadingPdfCubit>()
                                                                    .loadingPdf(
                                                                        false);

                                                                context
                                                                    .read<
                                                                        RefreshFolderCubit>()
                                                                    .refreshPage();
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                lunchAwesomDialoge(
                                                                    DialogType
                                                                        .warning,
                                                                    "e",
                                                                    getDeviceLocale() ==
                                                                            "ar"
                                                                        ? "تأكد من اتصالك بالإنترنت"
                                                                        : "Make sure you are connected to the Internet",
                                                                    context,
                                                                    getWidth(
                                                                        context),
                                                                    getHeight(
                                                                        context));
                                                              }
                                                            },
                                                            child: state
                                                                        is LoadingPdf &&
                                                                    state
                                                                        .loading
                                                                ? CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                  )
                                                                : Text(
                                                                    getDeviceLocale() ==
                                                                            "ar"
                                                                        ? "نعم"
                                                                        : "Yes",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                          );
                                                        },
                                                      ),
                                                      ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "إلغاء"
                                                                : "Cancel",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: mode
                                                ? Colors.white
                                                : dayBar["blue2"],
                                          ),
                                          Center(
                                            child: Text(
                                              getDeviceLocale() == "ar"
                                                  ? "حذف "
                                                  : "Delete folder",
                                              style: TextStyle(
                                                  color: mode
                                                      ? Colors.white
                                                      : dayBar["blue2"]),
                                            ),
                                          ),
                                        ],
                                      ))
                                ]);
                          }
                        },
                        child: Card(
                            child: Stack(
                          children: [
                            Container(
                                width: getWidth(context),
                                height: getHeight(context),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.asset(
                                    "images/icon.jpg",
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Opacity(
                              opacity: .5,
                              child: Container(
                                width: getWidth(context),
                                height: getHeight(context),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: mode
                                          ? [
                                              nightBar["orange"],
                                              nightBar["buttons"],
                                            ]
                                          : [
                                              const Color.fromARGB(
                                                  255, 93, 131, 163),
                                              const Color.fromARGB(
                                                  255, 13, 15, 17),
                                            ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.ondemand_video_outlined,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        offline
                                            ? copyData[index]
                                            : copyData[index]["name"],
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading: Icon(
                                      Icons.slow_motion_video_rounded,
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      getDeviceLocale() == "ar"
                                          ? copyData[index]["watchers"]
                                                  .contains(supabase
                                                      .auth.currentUser!.id)
                                              ? "تمت مشاهدته"
                                              : "لم تشاهده بعد"
                                          : copyData[index]["wathers"].contains(
                                                  supabase.auth.currentUser!.id)
                                              ? "ًWatched"
                                              : "Not watched",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                    ),
                  ),
                )
              : BlocBuilder<TimerCubitCubit, TimerCubitState>(
                  builder: (context, state) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      columnCount: 2,
                      duration: Duration(milliseconds: 500),
                      child: ScaleAnimation(
                        duration: Duration(milliseconds: 800),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ShowFolderDetailes(
                                        folder: offline
                                            ? data[index]
                                            : data[index].name,
                                        parentId: data[index].id,
                                      ),
                                    ));
                              },
                              onLongPressStart:
                                  (LongPressStartDetails details) {
                                if (checkPermision()) {
                                  final RenderBox overlay = Overlay.of(context)
                                      .context
                                      .findRenderObject() as RenderBox;
                                  final Offset position = overlay
                                      .globalToLocal(details.globalPosition);
                                  final RelativeRect positionRelativeToScreen =
                                      RelativeRect.fromLTRB(
                                    position.dx,
                                    position.dy,
                                    MediaQuery.of(context).size.width -
                                        position.dx,
                                    MediaQuery.of(context).size.height -
                                        position.dy,
                                  );
                                  showMenu(
                                      color: mode
                                          ? nightBar["orange"]
                                          : Colors.white,
                                      context: context,
                                      position: positionRelativeToScreen,
                                      items: <PopupMenuEntry<dynamic>>[
                                        PopupMenuItem(
                                            onTap: () async {
                                              GlobalKey<FormState> globalKey =
                                                  GlobalKey();
                                              var name = "";
                                              showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  backgroundColor: mode
                                                      ? nightBar["orange"]
                                                      : Colors.white,
                                                  content: PopScope(
                                                    canPop: false,
                                                    child: Container(
                                                      width: getWidth(context) *
                                                          .8,
                                                      height:
                                                          getWidth(context) *
                                                              .5,
                                                      child: Form(
                                                        key: globalKey,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Container(
                                                              width: getWidth(
                                                                      context) *
                                                                  2 /
                                                                  15,
                                                              height: getWidth(
                                                                      context) *
                                                                  2 /
                                                                  15,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        201,
                                                                        201,
                                                                        201),
                                                                child:
                                                                    Image.asset(
                                                                  "images/add_book.png",
                                                                  width: getWidth(
                                                                          context) *
                                                                      1 /
                                                                      15,
                                                                  height: getWidth(
                                                                          context) *
                                                                      1 /
                                                                      15,
                                                                ),
                                                              ),
                                                            ),
                                                            TextFormField(
                                                              validator: (value) =>
                                                                  nameValidator(
                                                                      value!),
                                                              style: TextStyle(
                                                                color: mode
                                                                    ? Colors
                                                                        .white
                                                                    : dayBar[
                                                                        "blue2"],
                                                              ),
                                                              cursorColor: mode
                                                                  ? Colors.white
                                                                  : dayBar[
                                                                      "blue2"],
                                                              onChanged:
                                                                  (folderName) {
                                                                name =
                                                                    folderName;
                                                              },
                                                              decoration: InputDecoration(
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      borderSide: BorderSide(
                                                                        width:
                                                                            .5,
                                                                        color: mode
                                                                            ? Colors.white
                                                                            : dayBar["blue2"],
                                                                      )),
                                                                  border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      borderSide: BorderSide(
                                                                        width:
                                                                            .5,
                                                                        color: mode
                                                                            ? Colors.white
                                                                            : dayBar["blue2"],
                                                                      )),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(20),
                                                                      borderSide: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: mode
                                                                            ? Colors.white
                                                                            : dayBar["blue2"],
                                                                      )),
                                                                  hintText: getDeviceLocale() == "ar" ? Translation().translateMe["Arabic"]!["save_folder"] : Translation().translateMe["English"]!["save_folder"],
                                                                  hintStyle: TextStyle(
                                                                    color: mode
                                                                        ? Colors
                                                                            .white
                                                                        : dayBar[
                                                                            "blue2"],
                                                                  )),
                                                            ),
                                                            BlocBuilder<
                                                                LoadingPdfCubit,
                                                                LoadingPdfState>(
                                                              builder: (context,
                                                                  state) {
                                                                return Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (globalKey
                                                                            .currentState!
                                                                            .validate()) {
                                                                          try {
                                                                            context.read<LoadingPdfCubit>().loadingPdf(true);

                                                                            var check = await _repo.renameFolder(
                                                                                copyData[index].id,
                                                                                name,
                                                                                context);
                                                                            if (check) {
                                                                              context.read<LoadingPdfCubit>().loadingPdf(false);
                                                                              Navigator.pop(context);

                                                                              context.read<RefreshFolderCubit>().refreshPage();
                                                                            } else {
                                                                              context.read<LoadingPdfCubit>().loadingPdf(false);
                                                                            }
                                                                          } catch (e) {
                                                                            setState(() {
                                                                              widget.loading = false;
                                                                            });
                                                                            lunchAwesomDialoge(
                                                                                DialogType.error,
                                                                                "e",
                                                                                getDeviceLocale() == "ar" ? "يوجد خطأ ما!" : "Somethig is wrong!",
                                                                                context,
                                                                                getWidth(context),
                                                                                getHeight(context));
                                                                          }
                                                                        }
                                                                      },
                                                                      child: state
                                                                              is LoadingPdf
                                                                          ? state.loading
                                                                              ? Center(
                                                                                  child: CircularProgressIndicator(
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                )
                                                                              : Text(
                                                                                  getDeviceLocale() == "ar" ? Translation().translateMe["Arabic"]!["save_button"] : Translation().translateMe["English"]!["save_button"],
                                                                                  style: TextStyle(color: Colors.white),
                                                                                )
                                                                          : Text(
                                                                              getDeviceLocale() == "ar" ? Translation().translateMe["Arabic"]!["save_button"] : Translation().translateMe["English"]!["save_button"],
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor: mode
                                                                            ? nightBar["buttons"]
                                                                            : dayBar["blue"],
                                                                      ),
                                                                    ),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor: mode
                                                                              ? nightBar["buttons"]
                                                                              : dayBar["blue"],
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          if (!(state is LoadingPdf &&
                                                                              state.loading)) {
                                                                            Navigator.pop(context);
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          getDeviceLocale() == "ar"
                                                                              ? "إلغاء"
                                                                              : "Cancel",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
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
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: mode
                                                        ? Colors.white
                                                        : dayBar["blue2"],
                                                  ),
                                                  Text(
                                                    getDeviceLocale() == "ar"
                                                        ? "تعديل"
                                                        : "Modify folder name",
                                                    style: TextStyle(
                                                        color: mode
                                                            ? Colors.white
                                                            : dayBar["blue2"]),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        PopupMenuDivider(),
                                        PopupMenuItem(
                                            onTap: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  backgroundColor: mode
                                                      ? nightBar["orange"]
                                                      : dayBar["blue"],
                                                  content: Container(
                                                    width:
                                                        getWidth(context) / 4,
                                                    height:
                                                        getHeight(context) / 8,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                          getDeviceLocale() ==
                                                                  "ar"
                                                              ? "هل أنت متأكد ؟"
                                                              : "Are you sure?",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            BlocBuilder<
                                                                LoadingPdfCubit,
                                                                LoadingPdfState>(
                                                              builder: (context,
                                                                  state) {
                                                                return ElevatedButton(
                                                                  onPressed:
                                                                      () async {
                                                                    if (await checkConnection()) {
                                                                      context
                                                                          .read<
                                                                              LoadingPdfCubit>()
                                                                          .loadingPdf(
                                                                              true);
                                                                      await _repo
                                                                          .deleteFolder(
                                                                              copyData[index].id);
                                                                      context
                                                                          .read<
                                                                              LoadingPdfCubit>()
                                                                          .loadingPdf(
                                                                              false);

                                                                      context
                                                                          .read<
                                                                              RefreshFolderCubit>()
                                                                          .refreshPage();
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      lunchAwesomDialoge(
                                                                          DialogType
                                                                              .warning,
                                                                          "e",
                                                                          getDeviceLocale() == "ar"
                                                                              ? "تأكد من اتصالك بالإنترنت"
                                                                              : "Make sure you are connected to the Internet",
                                                                          context,
                                                                          getWidth(
                                                                              context),
                                                                          getHeight(
                                                                              context));
                                                                    }
                                                                  },
                                                                  child: state
                                                                              is LoadingPdf &&
                                                                          state
                                                                              .loading
                                                                      ? CircularProgressIndicator(
                                                                          color:
                                                                              Colors.white,
                                                                        )
                                                                      : Text(
                                                                          getDeviceLocale() == "ar"
                                                                              ? "نعم"
                                                                              : "Yes",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                );
                                                              },
                                                            ),
                                                            ElevatedButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  getDeviceLocale() ==
                                                                          "ar"
                                                                      ? "إلغاء"
                                                                      : "Cancel",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: mode
                                                      ? Colors.white
                                                      : dayBar["blue2"],
                                                ),
                                                Center(
                                                  child: Text(
                                                    getDeviceLocale() == "ar"
                                                        ? "حذف "
                                                        : "Delete folder",
                                                    style: TextStyle(
                                                        color: mode
                                                            ? Colors.white
                                                            : dayBar["blue2"]),
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ]);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 3.0,
                                      spreadRadius: 0.0,
                                      offset: Offset(1.0, 1.0),
                                    )
                                  ],
                                  gradient: LinearGradient(
                                    colors: mode
                                        ? [
                                            nightBar["orange"],
                                            nightBar["buttons"],
                                          ]
                                        : [
                                            const Color.fromARGB(
                                                255, 11, 85, 145),
                                            const Color.fromARGB(
                                                255, 4, 96, 172)
                                          ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(children: [
                                        Container(
                                          width: getWidth(context),
                                          height: getHeight(context) / 10,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                mode
                                                    ? BoxShadow()
                                                    : BoxShadow(
                                                        color: Colors.black38,
                                                        blurRadius: 30,
                                                        spreadRadius: 0.0,
                                                        offset: Offset(0, 15),
                                                      )
                                              ],
                                              color: mode
                                                  ? Colors.grey.withOpacity(.4)
                                                  : Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                            "images/book.png",
                                            width: getWidth(context),
                                            height: getHeight(context) / 12,
                                          ),
                                        ),
                                      ]),
                                      FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(
                                          offline
                                              ? data[index]
                                              : data[index].name,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }

  // Future initVideos() async {
  //   var ref = await FirebaseStorage.instance.ref(widget.folder).list();
  //   if (!checkFolder(ref.items, ref.prefixes)) {
  //     try {
  //       if (widget.controller.isNotEmpty) {
  //         widget.controller.clear();
  //       }

  //       var copyVideos = List.from(ref.prefixes);

  //       context.read<LunchLoadingCubit>().lunchLoading(true);

  //       late DocumentSnapshot<Map<String, dynamic>> downloadUrls;
  //       FirebaseFirestore.instance.settings =
  //           const Settings(persistenceEnabled: true);
  //       for (var i = 0; i < copyVideos.length; i++) {
  //         downloadUrls = await FirebaseFirestore.instance
  //             .collection("videos")
  //             .doc(ref.prefixes[i].fullPath
  //                 .split("/")[ref.prefixes[i].fullPath.split("/").length - 1])
  //             .get();

  //         widget.currentData.addAll({i: downloadUrls.data()});
  //         widget.mp4Urls.add(downloadUrls.data()!["videoUrl"]);
  //         final controller = VideoPlayerController.networkUrl(
  //             Uri.parse(widget.mp4Urls[widget.mp4Urls.length - 1]));

  //         await controller.initialize(); // Await initialization
  //         widget.controller.add(controller);
  //       }

  //       context.read<LunchLoadingCubit>().lunchLoading(false);
  //       return [downloadUrls, widget.controller];
  //     } catch (e) {
  //       print("++++++++++++++++++++++++++++++++++++++++");
  //       print(e);
  //     }
  //   }
  // }

  Future checkVideoPermision({parentId}) async {
    var box = Hive.box(hiveBoxName);
    List folders = await _repo.getChildFolders(parentId);
    if (widget.vedio) {
      box.put(
          "${widget.folder.toString().split("/")[widget.folder.toString().split("/").length - 1]}_check_folderr",
          false);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadVideo(folder: widget.folder),
          ));
    } else if ((folders.isNotEmpty)) {
      var name = "";
      box.put("${widget.folder}_check_folder", true);
      GlobalKey<FormState> globalKey = GlobalKey();
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: mode ? nightBar["orange"] : Colors.white,
          content: PopScope(
            canPop: false,
            child: Container(
              width: getWidth(context) * .8,
              height: getWidth(context) * .5,
              child: Form(
                key: globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: getWidth(context) * 2 / 15,
                      height: getWidth(context) * 2 / 15,
                      child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(255, 201, 201, 201),
                        child: Image.asset(
                          "images/add_book.png",
                          width: getWidth(context) * 1 / 15,
                          height: getWidth(context) * 1 / 15,
                        ),
                      ),
                    ),
                    TextFormField(
                      validator: (value) => nameValidator(value!),
                      style: TextStyle(
                        color: mode ? Colors.white : dayBar["blue2"],
                      ),
                      cursorColor: mode ? Colors.white : dayBar["blue2"],
                      onChanged: (folderName) {
                        name = folderName;
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
                              ? Translation()
                                  .translateMe["Arabic"]!["save_folder"]
                              : Translation()
                                  .translateMe["English"]!["save_folder"],
                          hintStyle: TextStyle(
                            color: mode ? Colors.white : dayBar["blue2"],
                          )),
                    ),
                    BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (globalKey.currentState!.validate()) {
                                  try {
                                    context
                                        .read<LoadingPdfCubit>()
                                        .loadingPdf(true);

                                    var check = await _repo.createFolder(
                                        name, context,
                                        parentId: parentId);
                                    if (check) {
                                      context
                                          .read<LoadingPdfCubit>()
                                          .loadingPdf(false);
                                      Navigator.pop(context);

                                      context
                                          .read<RefreshFolderCubit>()
                                          .refreshPage();
                                    } else {
                                      context
                                          .read<LoadingPdfCubit>()
                                          .loadingPdf(false);
                                    }
                                  } catch (e) {
                                    context
                                        .read<LoadingPdfCubit>()
                                        .loadingPdf(false);
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
                              },
                              child: state is LoadingPdf
                                  ? state.loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          getDeviceLocale() == "ar"
                                              ? Translation().translateMe[
                                                  "Arabic"]!["save_button"]
                                              : Translation().translateMe[
                                                  "English"]!["save_button"],
                                          style: TextStyle(color: Colors.white),
                                        )
                                  : Text(
                                      getDeviceLocale() == "ar"
                                          ? Translation().translateMe[
                                              "Arabic"]!["save_button"]
                                          : Translation().translateMe[
                                              "English"]!["save_button"],
                                      style: TextStyle(color: Colors.white),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    mode ? nightBar["buttons"] : dayBar["blue"],
                              ),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: mode
                                      ? nightBar["buttons"]
                                      : dayBar["blue"],
                                ),
                                onPressed: () {
                                  if (!(state is LoadingPdf && state.loading)) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Text(
                                  getDeviceLocale() == "ar"
                                      ? "إلغاء"
                                      : "Cancel",
                                  style: TextStyle(color: Colors.white),
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
    } else {
      showDialog(
        context: context,
        builder: (context) => AddChoice(main: [false, widget.folder, parentId]),
      );
    }
  }

  // Future initVideos() async {
  //   try {
  //     var ref = await FirebaseStorage.instance.ref(widget.folder).list();

  //     // Check if the folder is valid
  //     if (!checkFolder(ref.items, ref.prefixes)) {
  //       // Clear the controller if it contains old data

  //       var copyVideos = List.from(ref.prefixes);

  //       // Enable Firestore caching

  //       // Use Future.wait to load videos concurrently
  //       List<Future> tasks = [];
  //       for (var i = 0; i < copyVideos.length; i++) {
  //         tasks.add(_loadVideo(ref.prefixes[i], i));
  //       }

  //       // Wait for all tasks to complete
  //       await Future.wait(tasks);

  //       context.read<LunchLoadingCubit>().lunchLoading(false);
  //     }
  //   } catch (e) {
  //     print("Error initializing videos: $e");
  //   }
  // }

// Helper function to load a single video
  Future<List<dynamic>> _loadVideo(Reference prefix, int index) async {
    try {
      // Get video metadata from Firestore
      FirebaseFirestore.instance.settings =
          const Settings(persistenceEnabled: true);
      var doc = await FirebaseFirestore.instance
          .collection("videos")
          .doc(prefix.fullPath.split("/").last)
          .get();

      var videoData = doc.data();

      if (videoData != null) {
        XFile thumbnailFile = await VideoThumbnail.thumbnailFile(
          // video:
          //     "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
          video: videoData["videoUrl"],
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          quality: 0,
        );

        return [thumbnailFile, videoData];
      }
    } catch (e) {
      widget.mp4Urls.clear();
      widget.unit8List.clear();
      widget.currentData.clear();
    }
    return [];
  }

  bool checkFolder(List<Reference> items, List<Reference> prefixes) {
    if (items.isNotEmpty) {
      if (items.length == 1 && prefixes.length > 0) {
        return true;
      }
    }
    return false;
  }

  void checkAndCreateTable() async {
    const tableName = 'products';

    if (!await doesTableExist(tableName)) {
      await createProductsTable();
    } else {}
  }

  Future<void> createProductsTable() async {
    // Your table creation logic here
  }
  Future<bool> checkVedio(pucketName) async {
    if (await doesBucketExist(pucketName)) {
      return true;
    }

    return false;
  }

  Future<bool> doesBucketExist(String bucketName) async {
    try {
      final response = await supabase.storage
          .from(bucketName)
          .list(); // Try to list contents (empty if bucket exists)

      // If no exception was thrown, the bucket exists
      return true;
    } catch (e) {
      // Check for specific error message or code
      if (e.toString().contains('bucket not found')) {
        return false;
      }
      return false; // Re-throw other errors
    }
  }

  bool checkEmpty(List<Reference> items, List<Reference> prefixes) {
    if (items.length == 1 && prefixes.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool checkFolderOffline() {
    var box = Hive.box(hiveBoxName);

    if (box.get("${widget.folder.toString().split("/")[widget.folder.toString().split("/").length - 1]}_check") !=
            null &&
        box.get(
            "${widget.folder.toString().split("/")[widget.folder.toString().split("/").length - 1]}_check")) {
      return true;
    } else {
      return false;
    }
  }

  Future getVideoDataOffline(String fullPath, offline) async {
    var box = Hive.box(hiveBoxName);
    var dataOnline = {};
    var dataOffline = [];
    if (offline) {
      var data = box.get("${fullPath.split("/").last.split(".").first}");
      if (data != null) {
        return data;
      } else {
        return {};
      }
    } else {
      // var data = await FirebaseFirestore.instance
      //     .collection("videos")
      //     .doc(fullPath.split("/").last)
      //     .get();
      // dataOnline = data.data()!;

      // box.put("${fullPath.split("/").last.split(".").first}", dataOnline);
      return dataOnline;
    }
  }

  Future getChilde() async {
    var l = await supabase.storage.from("curces").list();
    for (var i = 0; i < l.length; i++) {
      if (l[i].name == widget.parentId.toString()) {
        widget.vedio = true;
        var data = await supabase
            .from("curces")
            .select()
            .eq("folder_id", widget.parentId);
        return data;
      } else {
        widget.vedio = false;
      }
    }

    return await _repo.getChildFolders(widget.parentId);
  }
}
