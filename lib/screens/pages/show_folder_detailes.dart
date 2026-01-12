import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';

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
import 'package:teach/screens/pages/code_generater.dart';
import 'package:teach/screens/pages/play_video.dart';
import 'package:teach/screens/pages/quize.dart';
import 'package:teach/features/sell_point/presentation/sell_point.dart';
import 'package:teach/screens/pages/upload_video.dart';
import 'package:teach/widgets/add_choice.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:uuid/uuid.dart';

class ShowFolderDetailes extends StatefulWidget {
  var loading = false;
  var folder;
  var vedio = false;
  List<dynamic> unit8List = [];
  List mp4Urls = [];
  var currentData = {};
  var manage = false;
  List localData = [];
  var name = "";
  var parentId;
  ShowFolderDetailes(
      {required this.folder, required this.parentId, required this.manage});

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
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // await initVideos();
    // });
  }

  GlobalKey<FormState> folderKey = GlobalKey();
  var box = Hive.box(hiveBoxName);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RefreshFolderCubit, RefreshFolderState>(
      listener: (context, state) {
        // initVideos();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
          extendBody: true,
          extendBodyBehindAppBar: true,
          floatingActionButton:
              checkPermision(false, false, false, false, true, false)
                  ? BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                      builder: (context, state) {
                        return FloatingActionButton(
                          backgroundColor:
                              mode ? nightBar["orange"] : dayBar["blue3"],
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UploadVideo(
                                  folder: widget.folder,
                                  parent_id: widget.parentId),
                            ));
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : Container(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: getWidth(context) * .2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                              widget.folder,
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
                  height: getHeight(context) - (getWidth(context) * .2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: mode
                          ? const Color.fromRGBO(0, 0, 0, 1)
                          : Colors.white),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        FutureBuilder(
                            future: checkConnection(),
                            builder: (context, connectionSnapshot) {
                              if (connectionSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  width: getWidth(context),
                                  height: getHeight(context) -
                                      (getWidth(context) * .2),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: myImageAsset(
                                                "images/loading.gif", context)),
                                      ],
                                    ),
                                  ),
                                );
                              } else if ((connectionSnapshot.hasData &&
                                      connectionSnapshot.data! == true) ||
                                  widget.manage) {
                                return FutureBuilder(
                                  future: getChilde(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        width: getWidth(context),
                                        height: getHeight(context) -
                                            (getWidth(context) * .2),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: myImageAsset(
                                                      "images/loading.gif",
                                                      context)),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Container(
                                        width: getWidth(context),
                                        height: getHeight(context) -
                                            (getWidth(context) * .2),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(child: NoDataFound()),
                                          ],
                                        ),
                                      );
                                    } else {
                                      var data = widget.vedio
                                          ? snapshot.data[0]
                                          : snapshot.data;
                                      var userData =
                                          widget.vedio ? snapshot.data[1] : [];
                                      var copyData = List.from(data!);

                                      var box = Hive.box(hiveBoxName);
                                      List localVedioName = [];
                                      var copyFolderData = [];
                                      if (copyData.first is Folder) {
                                        for (var i = 0;
                                            i < copyData.length;
                                            i++) {
                                          copyFolderData
                                              .add(copyData[i].toJson());
                                        }
                                      }
                                      var vedioName = copyFolderData.isEmpty
                                          ? copyData
                                          : copyFolderData;

                                      box.put("${widget.folder}", vedioName);

                                      return folders(
                                          copyData,
                                          data,
                                          (widget.manage &&
                                                  connectionSnapshot.data! ==
                                                      false)
                                              ? true
                                              : false,
                                          userData);
                                    }
                                  },
                                );
                              } else {
                                return SizedBox(
                                    width: getWidth(context),
                                    height: getHeight(context) -
                                        (getWidth(context) * .2),
                                    child: const Center(child: NoInternet()));
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget folders(copyData, data, offline, userData) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.vedio
          ? copyData.length
          : offline
              ? data.length
              : data.length,
      itemBuilder: (context, index) {
        if (widget.manage) {
          if (copyData[index] is! Folder &&
              copyData[index]["folder_id"] != null) {
            widget.vedio = true;
          }
        }

        return widget.vedio
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    var box = Hive.box(hiveBoxName);

                    if (!box.get(isStudent) &&
                        !checkPermision(
                            false, false, true, false, false, false)) {
                      lunchAwesomDialoge(
                          DialogType.info,
                          "i",
                          getDeviceLocale() == "ar"
                              ? "لا تمتلك الصلاحيات لفتح الملف"
                              : "You do not have permission to open the file.",
                          context,
                          getWidth(context),
                          getHeight(context));
                    } else if ((!widget.manage || (await checkConnection())) &&
                        !box.get(isMainManager)) {
                      var data = await supabase
                          .from("current_user")
                          .select()
                          .eq("id", supabase.auth.currentUser!.id);

                      var codes =
                          box.get(isManager) ? "" : data[0]["codes"] ?? "";
                      codes = box.get(isStudent) ? data[0]["codes"] ?? "" : "";
                      var check = false;

                      if (codes is List) {
                        for (var i = 0; i < codes.length; i++) {
                          if (codes[i]
                                  .toString()
                                  .contains(widget.parentId.toString()) ||
                              codes[i]
                                  .toString()
                                  .contains(copyData[index]["sub"])) {
                            check = true;

                            break;
                          }
                        }
                      } else if (codes != "") {
                        if (codes
                                .toString()
                                .contains(widget.parentId.toString()) ||
                            codes.toString().contains(copyData[index]["sub"])) {
                          check = true;
                        }
                      }

                      if (check ||
                          checkPermision(
                              false, false, true, false, false, false) ||
                          widget.manage ||
                          copyData[index]["is_free"]) {
                        if (copyData[index]["url"].isEmpty &&
                            copyData[index]["pdf_urls"].isEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Quize(
                                questions: copyData[index]["que"],
                                choices: copyData[index]["choose"],
                                answers: copyData[index]["ans"]),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlayVideo(
                              data: copyData[index],
                              name: offline
                                  ? copyData[index]
                                  : copyData[index]["name"],
                            ),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor:
                              mode ? nightBar["orange"] : dayBar["blue3"],
                          content: Container(
                            child: Column(
                              children: [
                                AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "الملف مغلق، يرجى زيارة نقاط البيع"
                                      : "File is closed, please visit the points of sale",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          action: SnackBarAction(
                              backgroundColor:
                                  mode ? nightBar["buttons"] : dayBar["blue2"],
                              textColor: Colors.white,
                              label: getDeviceLocale() == "ar"
                                  ? "نقاط البيع"
                                  : "Sell point",
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SellPoint(),
                                ));
                              }),
                        ));
                      }
                    } else {
                      if (copyData[index]["url"].isEmpty &&
                          copyData[index]["pdf_urls"].isEmpty) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Quize(
                                questions: copyData[index]["que"],
                                choices: copyData[index]["choose"],
                                answers: copyData[index]["ans"])));
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlayVideo(
                            data: copyData[index],
                            name: offline
                                ? copyData[index]
                                : copyData[index]["name"],
                          ),
                        ));
                      }
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                        // color: mode
                        //     ? const Color(0xffEDECEA).withOpacity(.5)
                        //     : const Color(0xffEDECEA),
                        gradient: LinearGradient(
                          colors: mode
                              ? [
                                  nightBar["orange"],
                                  nightBar["buttons"],
                                ]
                              : [
                                  const Color.fromARGB(255, 1, 37, 87),
                                  const Color.fromARGB(255, 1, 37, 87)
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: getWidth(context),
                            height: getWidth(context) * .35,
                            child: Stack(
                              children: [
                                Container(
                                    width: getWidth(context),
                                    height: getHeight(context) * .35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          topRight: Radius.circular(15)),
                                      child: copyData[index]["image_url"] ==
                                                  null ||
                                              copyData[index]["image_url"]
                                                      .toString() ==
                                                  "null" ||
                                              copyData[index]
                                                          ["image_url"]
                                                      .toString() ==
                                                  ""
                                          ? Image.asset(
                                              "images/icon.jpg",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              cacheManager: customCachManager,
                                              imageUrl:
                                                  '${copyData[index]["image_url"]}',
                                              cacheKey:
                                                  '${copyData[index]["id"]}_${copyData[index]["image_url"]}',
                                              height: double.infinity,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 40,
                                                      ),
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ))),
                                    )),
                                Opacity(
                                  opacity: .4,
                                  child: Container(
                                    width: getWidth(context),
                                    height: getHeight(context) * .35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(),
                                      gradient: LinearGradient(
                                        colors: mode
                                            ? [
                                                nightBar["orange"],
                                                nightBar["buttons"],
                                              ]
                                            : [
                                                Colors.transparent,
                                                const Color.fromARGB(
                                                    255, 107, 107, 107)
                                              ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Center(
                                        child: Icon(
                                          copyData[index]["url"].isEmpty &&
                                                  copyData[index]["pdf_urls"]
                                                      .isEmpty
                                              ? Icons.quiz_rounded
                                              : copyData[index]["url"].isEmpty
                                                  ? Icons.picture_as_pdf
                                                  : Icons
                                                      .ondemand_video_outlined,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          offline
                                              ? copyData[index]["name"]
                                              : copyData[index]["name"],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          (copyData[index]["url"].isEmpty &&
                                      copyData[index]["pdf_urls"].isEmpty) ||
                                  (copyData[index]["url"].isEmpty)
                              ? ListTile(
                                  leading: Icon(
                                    color: Colors.white,
                                    userData.isNotEmpty
                                        ? userData[0]["codes"]
                                                    .toString()
                                                    .contains(copyData[index]
                                                            ["folder_id"]
                                                        .toString()) ||
                                                copyData[index]["is_free"] ||
                                                userData[0]["codes"]
                                                    .toString()
                                                    .contains(copyData[index]
                                                            ["sub"]
                                                        .toString())
                                            ? Icons.lock_open
                                            : Icons.lock
                                        : Icons.lock_open,
                                  ),
                                  title: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? offline
                                            ? userData.isNotEmpty
                                                ? userData[0]["codes"]
                                                            .toString()
                                                            .contains(copyData[
                                                                        index][
                                                                    "folder_id"]
                                                                .toString()) ||
                                                        copyData[index]
                                                            ["is_free"]
                                                    ? "مجاني"
                                                    : "مقفل"
                                                : "إدارة"
                                            : ""
                                        : offline
                                            ? userData.isNotEmpty
                                                ? userData[0]["codes"]
                                                            .toString()
                                                            .contains(copyData[
                                                                        index][
                                                                    "folder_id"]
                                                                .toString()) ||
                                                        copyData[index]
                                                            ["is_free"]
                                                    ? "Free"
                                                    : "Locked"
                                                : "Management"
                                            : "",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: SizedBox(
                                    width: getWidth(context) * .18,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        checkPermision(false, true, false,
                                                false, false, false)
                                            ? GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor: mode
                                                          ? nightBar["orange"]
                                                          : dayBar["blue"],
                                                      content: Container(
                                                        width:
                                                            getWidth(context) /
                                                                4,
                                                        height:
                                                            getHeight(context) /
                                                                8,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            AutoSizeText(
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              minFontSize: 10,
                                                              maxFontSize: 15,
                                                              getDeviceLocale() ==
                                                                      "ar"
                                                                  ? "هل أنت متأكد ؟"
                                                                  : "Are you sure?",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                                      (context,
                                                                          state) {
                                                                    return ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (await checkConnection()) {
                                                                          context
                                                                              .read<LoadingPdfCubit>()
                                                                              .loadingPdf(true);
                                                                          await _repo.deleteVideo(
                                                                              copyData[index],
                                                                              context,
                                                                              widget.parentId);
                                                                          context
                                                                              .read<LoadingPdfCubit>()
                                                                              .loadingPdf(false);

                                                                          context
                                                                              .read<RefreshFolderCubit>()
                                                                              .refreshPage();
                                                                          Navigator.pop(
                                                                              context);
                                                                        } else {
                                                                          lunchAwesomDialoge(
                                                                              DialogType.warning,
                                                                              "e",
                                                                              getDeviceLocale() == "ar" ? "تأكد من اتصالك بالإنترنت" : "Make sure you are connected to the Internet",
                                                                              context,
                                                                              getWidth(context),
                                                                              getHeight(context));
                                                                        }
                                                                      },
                                                                      child: state is LoadingPdf &&
                                                                              state.loading
                                                                          ? CircularProgressIndicator(
                                                                              color: Colors.white,
                                                                            )
                                                                          : AutoSizeText(
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              minFontSize: 10,
                                                                              maxFontSize: 15,
                                                                              getDeviceLocale() == "ar" ? "نعم" : "Yes",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                    );
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        AutoSizeText(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          15,
                                                                      getDeviceLocale() ==
                                                                              "ar"
                                                                          ? "إلغاء"
                                                                          : "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      getWidth(context) * .08,
                                                  height:
                                                      getWidth(context) * .08,
                                                  decoration: BoxDecoration(
                                                      color: mode
                                                          ? dayBar["blue"]
                                                          : nightBar["buttons"],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: .5,
                                                          color: mode
                                                              ? dayBar["blue2"]
                                                              : nightBar[
                                                                  "orange"])),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      getDeviceLocale() == "ar"
                                                          ? "حذف"
                                                          : "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                )
                              : ListTile(
                                  leading: Icon(
                                    userData.isNotEmpty
                                        ? userData[0]["codes"]
                                                    .toString()
                                                    .contains(copyData[index]
                                                            ["folder_id"]
                                                        .toString()) ||
                                                copyData[index]["is_free"] ||
                                                userData[0]["codes"]
                                                    .toString()
                                                    .contains(copyData[index]
                                                            ["sub"]
                                                        .toString())
                                            ? Icons.slow_motion_video_rounded
                                            : Icons.lock
                                        : Icons.slow_motion_video_rounded,
                                    color: Colors.white,
                                  ),
                                  title: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    copyData[index]["url"].isEmpty &&
                                            copyData[index]["pdf_urls"].isEmpty
                                        ? ""
                                        : getDeviceLocale() == "ar"
                                            ? copyData[index]["watchers"]
                                                    .contains(supabase
                                                        .auth.currentUser!.id)
                                                ? "تمت مشاهدته"
                                                : "لم تشاهده بعد"
                                            : copyData[index]["wathers"]
                                                    .contains(supabase
                                                        .auth.currentUser!.id)
                                                ? "ًWatched"
                                                : "Not watched",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: getWidth(context) * .03),
                                  ),
                                  subtitle: AutoSizeText(
                                    "حجم الملف : ${copyData[index]["size"]}",
                                    maxFontSize: 15,
                                    minFontSize: 5,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  trailing: checkPermision(false, true, false,
                                          false, false, false)
                                      ? SizedBox(
                                          width: getWidth(context) * .18,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor: mode
                                                          ? nightBar["orange"]
                                                          : dayBar["blue"],
                                                      content: Container(
                                                        width:
                                                            getWidth(context) /
                                                                4,
                                                        height:
                                                            getHeight(context) /
                                                                8,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            AutoSizeText(
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              minFontSize: 10,
                                                              maxFontSize: 15,
                                                              getDeviceLocale() ==
                                                                      "ar"
                                                                  ? "هل أنت متأكد ؟"
                                                                  : "Are you sure?",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                                                      (context,
                                                                          state) {
                                                                    return ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (await checkConnection()) {
                                                                          context
                                                                              .read<LoadingPdfCubit>()
                                                                              .loadingPdf(true);
                                                                          await _repo.deleteVideo(
                                                                              copyData[index],
                                                                              context,
                                                                              widget.parentId);
                                                                          context
                                                                              .read<LoadingPdfCubit>()
                                                                              .loadingPdf(false);

                                                                          context
                                                                              .read<RefreshFolderCubit>()
                                                                              .refreshPage();
                                                                          Navigator.pop(
                                                                              context);
                                                                        } else {
                                                                          lunchAwesomDialoge(
                                                                              DialogType.warning,
                                                                              "e",
                                                                              getDeviceLocale() == "ar" ? "تأكد من اتصالك بالإنترنت" : "Make sure you are connected to the Internet",
                                                                              context,
                                                                              getWidth(context),
                                                                              getHeight(context));
                                                                        }
                                                                      },
                                                                      child: state is LoadingPdf &&
                                                                              state.loading
                                                                          ? CircularProgressIndicator(
                                                                              color: Colors.white,
                                                                            )
                                                                          : AutoSizeText(
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              minFontSize: 10,
                                                                              maxFontSize: 15,
                                                                              getDeviceLocale() == "ar" ? "نعم" : "Yes",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                    );
                                                                  },
                                                                ),
                                                                ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        AutoSizeText(
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      minFontSize:
                                                                          10,
                                                                      maxFontSize:
                                                                          15,
                                                                      getDeviceLocale() ==
                                                                              "ar"
                                                                          ? "إلغاء"
                                                                          : "Cancel",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ))
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width:
                                                      getWidth(context) * .08,
                                                  height:
                                                      getWidth(context) * .08,
                                                  decoration: BoxDecoration(
                                                      color: mode
                                                          ? dayBar["blue"]
                                                          : nightBar["buttons"],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      border: Border.all(
                                                          width: .5,
                                                          color: mode
                                                              ? dayBar["blue2"]
                                                              : nightBar[
                                                                  "orange"])),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      getDeviceLocale() == "ar"
                                                          ? "حذف"
                                                          : "Delete",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                ),
                        ],
                      )),
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
                                          ? data[index]["name"]
                                          : data[index].name,
                                      parentId: offline
                                          ? data[index]["id"]
                                          : data[index].id,
                                      manage: widget.manage,
                                    ),
                                  ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
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
                                gradient: LinearGradient(
                                  colors: mode
                                      ? [
                                          nightBar["orange"],
                                          nightBar["buttons"],
                                        ]
                                      : [
                                          const Color.fromARGB(255, 8, 56, 124),
                                          const Color.fromARGB(255, 1, 37, 87)
                                        ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: getWidth(context),
                                    height: getWidth(context) * .35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        child: offline
                                            ? copyData[index]["image_url"] ==
                                                        null ||
                                                    copyData[index]["image_url"]
                                                        .isEmpty
                                                ? Image.asset(
                                                    "images/icon.jpg",
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    cacheManager:
                                                        customCachManager,
                                                    imageUrl:
                                                        '${copyData[index]["image_url"]}',
                                                    cacheKey:
                                                        '${copyData[index]["id"]}_${copyData[index]["image_url"]}',
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                              color: Colors.red,
                                                              size: 40,
                                                            ),
                                                    placeholder: (context, url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: Colors.white,
                                                        )))
                                            : copyData[index].imageUrl.toString() ==
                                                        "null" ||
                                                    copyData[index]
                                                        .imageUrl
                                                        .isEmpty ||
                                                    copyData[index]
                                                            .imageUrl
                                                            .toString() ==
                                                        ""
                                                ? Image.asset(
                                                    "images/icon.jpg",
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    cacheManager:
                                                        customCachManager,
                                                    imageUrl:
                                                        '${copyData[index].imageUrl}',
                                                    cacheKey:
                                                        '${copyData[index].id}_${copyData[index].imageUrl}',
                                                    height: double.infinity,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                              color: Colors.red,
                                                              size: 40,
                                                            ),
                                                    placeholder: (context,
                                                            url) =>
                                                        const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                          color: Colors.white,
                                                        )))),
                                  ),
                                  ListTile(
                                    leading: Container(
                                        width: getWidth(context) * .1,
                                        height: getWidth(context) * .1,
                                        child: CircleAvatar(
                                          child: Image.asset(
                                            "images/book.png",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    title: AutoSizeText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      minFontSize: 10,
                                      maxFontSize: 15,
                                      offline
                                          ? copyData[index]["name"]
                                          : copyData[index].name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getWidth(context) * .05,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: getWidth(context) * .15,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: .5,
                                                  color: mode
                                                      ? nightBar["orange"]
                                                      : dayBar["blue2"]),
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: mode
                                                  ? nightBar["orange"]
                                                      .withOpacity(.5)
                                                  : dayBar["blue2"]
                                                      .withOpacity(.5)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.folder,
                                                color: Colors.white,
                                              ),
                                              AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                offline
                                                    ? copyData[index]
                                                        ["child_count"]
                                                    : copyData[index]
                                                        .childCount,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                        !offline &&
                                                copyData[index].locked &&
                                                box.get(isStudent)
                                            ? Container(
                                                width: getWidth(context) * .3,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: .5,
                                                        color: mode
                                                            ? nightBar["orange"]
                                                            : dayBar["blue2"]),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    color: mode
                                                        ? nightBar["orange"]
                                                            .withOpacity(.5)
                                                        : dayBar["blue2"]
                                                            .withOpacity(.5)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      getDeviceLocale() == "ar"
                                                          ? "السعر : "
                                                          : "Price",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Container(
                                                      width: getWidth(context) *
                                                          .15,
                                                      child: AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        offline
                                                            ? copyData[index]
                                                                ["price"]
                                                            : copyData[index]
                                                                .price,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        checkPermision(true, false, false,
                                                false, false, false)
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (await checkConnection()) {
                                                    await showEditeDialoge(
                                                        copyData[index].id);
                                                  }
                                                },
                                                child: Container(
                                                  width:
                                                      getWidth(context) * .15,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: .5,
                                                          color: mode
                                                              ? nightBar[
                                                                  "orange"]
                                                              : dayBar[
                                                                  "blue2"]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: mode
                                                          ? nightBar["orange"]
                                                              .withOpacity(.5)
                                                          : dayBar["blue2"]
                                                              .withOpacity(.5)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? "تعديل"
                                                            : "ُEdite",
                                                        style: TextStyle(
                                                            fontSize: getWidth(
                                                                    context) *
                                                                .026,
                                                            color: Colors.white,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        offline
                                            ? copyData[index]["locked"] &&
                                                    checkPermision(
                                                        false,
                                                        false,
                                                        false,
                                                        true,
                                                        false,
                                                        false)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      if (await checkConnection()) {
                                                        showCodeDialoge(
                                                            copyData[index].id);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: getWidth(context) *
                                                          .15,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: .5,
                                                              color: mode
                                                                  ? nightBar[
                                                                      "orange"]
                                                                  : dayBar[
                                                                      "blue2"]),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: mode
                                                              ? nightBar[
                                                                      "orange"]
                                                                  .withOpacity(
                                                                      .5)
                                                              : dayBar["blue2"]
                                                                  .withOpacity(
                                                                      .5)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Icon(
                                                            Icons.code,
                                                            color: Colors.white,
                                                          ),
                                                          AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "كود"
                                                                : "ُCode",
                                                            style: TextStyle(
                                                                fontSize: getWidth(
                                                                        context) *
                                                                    .026,
                                                                color: Colors
                                                                    .white,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink()
                                            : copyData[index].locked &&
                                                    checkPermision(
                                                        false,
                                                        false,
                                                        false,
                                                        true,
                                                        false,
                                                        false)
                                                ? GestureDetector(
                                                    onTap: () async {
                                                      if (await checkConnection()) {
                                                        showCodeDialoge(
                                                            copyData[index].id);
                                                      }
                                                    },
                                                    child: Container(
                                                      width: getWidth(context) *
                                                          .15,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              width: .5,
                                                              color: mode
                                                                  ? nightBar[
                                                                      "orange"]
                                                                  : dayBar[
                                                                      "blue2"]),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          color: mode
                                                              ? nightBar[
                                                                      "orange"]
                                                                  .withOpacity(
                                                                      .5)
                                                              : dayBar["blue2"]
                                                                  .withOpacity(
                                                                      .5)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Icon(
                                                            Icons.code,
                                                            color: Colors.white,
                                                          ),
                                                          AutoSizeText(
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            minFontSize: 10,
                                                            maxFontSize: 15,
                                                            getDeviceLocale() ==
                                                                    "ar"
                                                                ? "كود"
                                                                : "ُCode",
                                                            style: TextStyle(
                                                                fontSize: getWidth(
                                                                        context) *
                                                                    .026,
                                                                color: Colors
                                                                    .white,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                        checkPermision(false, true, false,
                                                false, false, false)
                                            ? GestureDetector(
                                                onTap: () async {
                                                  if (await checkConnection()) {
                                                    await showDeleteDialoge(
                                                        copyData[index].id);
                                                  }
                                                },
                                                child: Container(
                                                  width:
                                                      getWidth(context) * .15,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: .5,
                                                          color: mode
                                                              ? nightBar[
                                                                  "orange"]
                                                              : dayBar[
                                                                  "blue2"]),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: mode
                                                          ? nightBar["orange"]
                                                              .withOpacity(.5)
                                                          : dayBar["blue2"]
                                                              .withOpacity(.5)),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                      AutoSizeText(
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        minFontSize: 10,
                                                        maxFontSize: 15,
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? "حذف"
                                                            : "Delete",
                                                        style: TextStyle(
                                                            fontSize: getWidth(
                                                                    context) *
                                                                .026,
                                                            color: Colors.white,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ],
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
            builder: (context) => UploadVideo(
              folder: widget.folder,
              parent_id: parentId,
            ),
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
                                          style: TextStyle(color: Colors.white),
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
                                child: AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
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
    if (widget.manage && !(await checkConnection())) {
      var box = Hive.box(hiveBoxName);
      return box.get("${widget.folder}");
    }
    var checkVideo =
        await supabase.from("folders").select().eq("id", widget.parentId);
    var l = await supabase
        .from("curces")
        .select()
        .eq("folder_id", widget.parentId)
        .order("id", ascending: true);

    if (l.isEmpty) {
      widget.vedio = false;
    } else {
      widget.vedio = true;

      var userData = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);
      List allData = [];
      allData.add(l);
      allData.add(userData);

      return allData;
    }

    return await _repo.getChildFolders(widget.parentId);
  }

  showDeleteDialoge(id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: mode ? nightBar["orange"] : dayBar["blue"],
        content: Container(
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
                style: TextStyle(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () async {
                          if (await checkConnection()) {
                            context
                                .read<LunchLoadingCubit>()
                                .lunchLoading(true);
                            await _repo.deleteFolder(
                                id, widget.parentId, context);
                            context
                                .read<LunchLoadingCubit>()
                                .lunchLoading(false);

                            context.read<RefreshFolderCubit>().refreshPage();
                            Navigator.pop(context);
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
                        child: state is LunchLoading && state.loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
                                getDeviceLocale() == "ar" ? "نعم" : "Yes",
                                style: TextStyle(color: Colors.white),
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
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  showEditeDialoge(id) {
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
                                        id, widget.name, context);
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
                                        ? Translation().translateMe["Arabic"]![
                                            "save_button"]
                                        : Translation().translateMe["English"]![
                                            "save_button"],
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mode
                                    ? nightBar["buttons"]
                                    : dayBar["blue3"],
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
      ),
    );
  }

  void showCodeDialoge(id) {
    GlobalKey<FormState> key = GlobalKey();
    TextEditingController numberOfCodeController = TextEditingController();
    TextEditingController teacherController = TextEditingController();
    TextEditingController subjectController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            width: getWidth(context) * .5,
            height: getWidth(context) * .5,
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    controller: numberOfCodeController,
                    validator: (value) {
                      return codeGeneratorValidator(value!);
                    },
                    style: TextStyle(
                      color: mode ? Colors.white : dayBar["blue2"],
                    ),
                    cursorColor: mode ? Colors.white : dayBar["blue2"],
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
                            ? "عدد الأكواد المطلوبة..."
                            : "Number of codes required...",
                        hintStyle: TextStyle(
                          color: mode
                              ? Colors.white.withOpacity(.5)
                              : dayBar["blue2"].withOpacity(.4),
                        )),
                  ),
                  BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                    builder: (context, state) {
                      return ElevatedButton(
                          onPressed: () async {
                            try {
                              if (key.currentState!.validate()) {
                                context
                                    .read<LunchLoadingCubit>()
                                    .uploadCode(true);
                                FolderRepository repo =
                                    FolderRepository(supabase);
                                var rootFolder = await repo.getRootFolder(id);
                                var nameOfCurce = await supabase
                                    .from("folders")
                                    .select()
                                    .eq("id", id);
                                var subRoot = await repo.getSubRootFolder(id);
                                var subjectFolder =
                                    await repo.getSubjectFolder(id);
                                var teacherFolder =
                                    await repo.getTeachertFolder(id);
                                var formatedName = "";

                                if (subjectFolder.isNotEmpty &&
                                    subjectFolder.toString().trim() !=
                                        nameOfCurce[0]["name"]
                                            .toString()
                                            .trim()) {
                                  formatedName =
                                      "${rootFolder} - ${subRoot} - ${subjectFolder} - ${nameOfCurce[0]["name"]}";
                                } else {
                                  formatedName =
                                      "${rootFolder} - ${subRoot} - ${nameOfCurce[0]["name"]}";
                                }
                                var box = Hive.box(hiveBoxName);
                                var managerName = box.get(isMainManager)
                                    ? box.get("Mname")
                                    : box.get("info")[0];
                              
                                for (var i = 0;
                                    i <
                                        int.parse(
                                            numberOfCodeController.text.trim());
                                    i++) {
                                  var code = Uuid().v4();

                                  await supabase.from("codes").insert({
                                    "id": code.toString().trim(),
                                    "name": formatedName.toString().trim(),
                                    "folder_id": id,
                                    "generator-name":
                                        managerName.toString().trim(),
                                    "subject": subjectFolder,
                                    "teacher": teacherFolder,
                                  });
                                }
                              }
                              context
                                  .read<LunchLoadingCubit>()
                                  .uploadCode(false);
                              Navigator.pop(context);
                            } catch (e) {
                              context
                                  .read<LunchLoadingCubit>()
                                  .uploadCode(false);
                              print(e);
                            }
                          },
                          child: state is UploadCodeLoading && state.loading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : AutoSizeText(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  minFontSize: 10,
                                  maxFontSize: 15,
                                  getDeviceLocale() == "ar"
                                      ? "توليد"
                                      : "Generate",
                                  style: const TextStyle(color: Colors.white),
                                ));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
