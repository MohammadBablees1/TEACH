import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/cubit/check_connection/check_connection_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/home_search/home_search_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/slelecte_class/selecte_class_cubit.dart';

import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';

import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';

import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/add_ads.dart';
import 'package:teach/screens/profile.dart';

import 'package:teach/screens/pages/show_ads.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';

import 'package:teach/widgets/add_choice.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MainScreen extends StatefulWidget {
  var home = true, len = 0;
  var currentIndex = 0;
  var name = "", loading = false;
  var isEditing = false;
  var currentUser = "";

  late TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future _pullRefresh() async {
    setState(() {});
  }

  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 7),
  ));
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  GlobalKey<FormState> folderKey = GlobalKey();
  var selectedClass = "";
  GlobalKey _btnKey = GlobalKey();
  final FolderRepository _repo = FolderRepository(supabase);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: main_screen_body(context),
      floatingActionButton: checkPermision() && widget.home
          ? Builder(builder: (context) {
              return FabCircularMenu(
                key: fabKey,
                // Cannot be Alignment.center
                alignment: getDeviceLocale() == "ar"
                    ? Alignment.bottomLeft
                    : Alignment.bottomRight,
                ringColor: mode
                    ? Colors.white.withAlpha(25)
                    : dayBar["blue2"].withOpacity(.5),
                ringDiameter: 500.0,

                ringWidth: 150.0,
                fabSize: 64.0,
                fabElevation: 8.0,
                fabIconBorder: CircleBorder(),
                // Also can use specific color based on wether
                // the menu is open or not:
                // fabOpenColor: Colors.white
                // fabCloseColor: Colors.white
                // These properties take precedence over fabColor
                fabColor: mode ? nightBar["orange"] : Colors.white,
                fabOpenIcon: Icon(Icons.add,
                    color: mode ? Colors.white : dayBar["blue2"]),
                fabCloseIcon: Icon(Icons.close,
                    color: mode ? Colors.white : dayBar["blue2"]),
                fabMargin: getDeviceLocale() == "ar"
                    ? const EdgeInsets.only(
                        left: 0, right: 0, bottom: 30, top: 0)
                    : const EdgeInsets.all(16.0),
                animationDuration: const Duration(milliseconds: 800),
                animationCurve: Curves.easeInOutCirc,
                onDisplayChange: (isOpen) {},
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddAds(),
                      ));
                    },
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      "images/add_ads.png",
                      width: getWidth(context) * 0.1,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () {
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
                                        color: mode
                                            ? Colors.white
                                            : dayBar["blue2"],
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
                                              ? "اكتب اسم الجامعة هنا..."
                                              : "Write the name of the university here...",
                                          hintStyle: TextStyle(
                                            color: mode
                                                ? Colors.white.withOpacity(.5)
                                                : dayBar["blue2"]
                                                    .withOpacity(.4),
                                          )),
                                    ),
                                    BlocBuilder<LunchLoadingCubit,
                                        LunchLoadingState>(
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
                                                        .read<
                                                            LunchLoadingCubit>()
                                                        .lunchLoading(true);

                                                    var check = await _repo
                                                        .createFolder(
                                                            name, context);
                                                    if (check) {
                                                      context
                                                          .read<
                                                              LunchLoadingCubit>()
                                                          .lunchLoading(false);
                                                      context
                                                          .read<
                                                              RefreshFolderCubit>()
                                                          .refreshPage();
                                                      Navigator.pop(context);
                                                    } else {
                                                      context
                                                          .read<
                                                              LunchLoadingCubit>()
                                                          .lunchLoading(false);
                                                    }
                                                  } catch (e) {
                                                    print(e);
                                                    print("++++++++++++++++++");
                                                    context
                                                        .read<
                                                            LunchLoadingCubit>()
                                                        .lunchLoading(false);
                                                    setState(() {
                                                      widget.loading = false;
                                                    });
                                                    lunchAwesomDialoge(
                                                        DialogType.error,
                                                        "e",
                                                        getDeviceLocale() ==
                                                                "ar"
                                                            ? "يوجد خطأ ما!"
                                                            : "Somethig is wrong!",
                                                        context,
                                                        getWidth(context),
                                                        getHeight(context));
                                                  }
                                                }
                                              },
                                              child: state is LunchLoading
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
                                                  if (!(state is LunchLoading &&
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
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      "images/university.png",
                      width: getWidth(context) * 0.1,
                    ),
                  ),
                  RawMaterialButton(
                    onPressed: () async {
                      await openClasses(false, "");
                    },
                    shape: CircleBorder(),
                    padding: const EdgeInsets.all(24.0),
                    child: Image.asset(
                      "images/classroom.png",
                      width: getWidth(context) * 0.1,
                    ),
                  ),
                ],
              );
            })
          : Container(),
    );
  }

  Widget main_screen_body(BuildContext context) {
    return BlocConsumer<RefreshFolderCubit, RefreshFolderState>(
      listener: (context, state) {
        setState(() {});
      },
      builder: (context, state) {
        return Stack(
          children: [
            ListView.builder(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: 1,
              itemBuilder: (context, index) {
                return SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: getWidth(context) * .8,
                            height: getWidth(context) * .1,
                            padding: EdgeInsets.symmetric(
                                horizontal: getWidth(context) / 60),
                            decoration: BoxDecoration(
                              color: mode
                                  ? nightBar["orange"].withOpacity(.5)
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    blurRadius: 30,
                                    offset: Offset(0, 15)),
                              ],
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: TextField(
                              style: TextStyle(
                                  color: mode ? Colors.white : Colors.blue),
                              cursorColor: mode ? Colors.white : Colors.blue,
                              maxLines: 1,
                              onChanged: (searchedValue) {
                                context
                                    .read<HomeSearchCubit>()
                                    .searchForValue(true, searchedValue);
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  borderSide: BorderSide.none,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintStyle: TextStyle(
                                    color: mode
                                        ? Colors.white.withOpacity(.4)
                                        : Colors.black.withOpacity(.6)),
                                fillColor: Colors.transparent,
                                filled: true,
                                hintText: getDeviceLocale() == "ar"
                                    ? "انقر هنا للبحث"
                                    : "Click here to search",
                                contentPadding: EdgeInsets.all(0),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: getWidth(context) * .1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getHeight(context) * .1,
                      ),
                      BlocBuilder<CheckConnectionCubit, ConnectivityStatus>(
                        builder: (context, state) => FutureBuilder(
                            future: checkConnection(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Image.asset("images/loading.gif"),
                                );
                              } else {
                                var data = snapshot.data;
                                if (!data!) {
                                  return FutureBuilder(
                                    future: getAdsLocaly(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child:
                                              Image.asset("images/loading.gif"),
                                        );
                                      } else if (!snapshot.hasData ||
                                          snapshot.data == null ||
                                          snapshot.data!.isEmpty) {
                                        return Container();
                                      } else {
                                        List ads = snapshot.data!;

                                        return Column(
                                          children: [
                                            CarouselSlider.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder:
                                                  (context, index, realIndex) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                      20.0),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ShowAds(
                                                                  ads: ads,
                                                                  index: index),
                                                        ),
                                                      );
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                      width: getWidth(context),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child: Stack(
                                                        children: [
                                                          ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              child:
                                                                  CachedNetworkImage(
                                                                      cacheManager:
                                                                          customCachManager,
                                                                      imageUrl:
                                                                          '${ads[index]["imageUrl"]}',
                                                                      cacheKey:
                                                                          '${ads[index]["id"]}_${ads[index]["updated_at"]}',
                                                                      height: double
                                                                          .infinity,
                                                                      width: double
                                                                          .infinity,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorWidget: (context,
                                                                              url,
                                                                              error) =>
                                                                          Icon(
                                                                            Icons.error,
                                                                            color:
                                                                                Colors.red,
                                                                            size:
                                                                                40,
                                                                          ),
                                                                      placeholder: (context,
                                                                              url) =>
                                                                          Center(
                                                                              child: CircularProgressIndicator(
                                                                            color: mode
                                                                                ? Colors.white
                                                                                : dayBar["blue"],
                                                                          )))),
                                                          Opacity(
                                                            opacity: .4,
                                                            child: Container(
                                                              width: getWidth(
                                                                  context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          Colors
                                                                              .transparent,
                                                                          Colors
                                                                              .black
                                                                        ],
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter,
                                                                        stops: [
                                                                          0,
                                                                          50
                                                                        ],
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              options: CarouselOptions(
                                                height: getHeight(context) / 4,
                                                autoPlay: true,
                                                pauseAutoPlayOnTouch: true,
                                                autoPlayInterval:
                                                    Duration(seconds: 10),
                                                autoPlayAnimationDuration:
                                                    Duration(seconds: 2),
                                                autoPlayCurve:
                                                    Curves.fastOutSlowIn,
                                                enlargeCenterPage: false,
                                                enableInfiniteScroll: false,
                                                onPageChanged: (index, reason) {
                                                  context
                                                      .read<ClauserIndexCubit>()
                                                      .changeIndex(index);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: getHeight(context) / 30,
                                            ),
                                            BlocBuilder<ClauserIndexCubit,
                                                ClauserIndexState>(
                                              builder: (context, state) {
                                                return AnimatedSmoothIndicator(
                                                  activeIndex:
                                                      state is ChangeIndex
                                                          ? state.newIndex
                                                          : widget.currentIndex,
                                                  count: ads.length,
                                                  effect: WormEffect(
                                                      activeDotColor: mode
                                                          ? nightBar["buttons"]
                                                          : dayBar["blue"],
                                                      dotColor: Colors.grey,
                                                      dotHeight: 5,
                                                      dotWidth: 5),
                                                );
                                              },
                                            )
                                          ],
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  return FutureBuilder(
                                      future:
                                          BlocProvider.of<TeachCubit>(context)
                                              .getAllAds(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Image.asset(
                                                "images/loading.gif"),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data == null ||
                                            snapshot.data!.isEmpty) {
                                          return Container();
                                        } else {
                                          var ads = snapshot.data;
                                          var box = Hive.box(hiveBoxName);
                                          box.put("ads", ads);
                                          // var box = Hive.box(hiveBoxName);
                                          // box.put("ads", ads);

                                          return Column(
                                            children: [
                                              CarouselSlider.builder(
                                                itemCount:
                                                    snapshot.data!.length,
                                                itemBuilder: (context, index,
                                                    realIndex) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ShowAds(
                                                                    ads: ads,
                                                                    index:
                                                                        index),
                                                          ),
                                                        );
                                                      },
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Container(
                                                        width:
                                                            getWidth(context),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Stack(
                                                          children: [
                                                            ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                child:
                                                                    CachedNetworkImage(
                                                                        cacheManager:
                                                                            customCachManager,
                                                                        imageUrl:
                                                                            '${ads![index]["imageUrl"]}',
                                                                        cacheKey:
                                                                            '${ads[index]["id"]}_${ads[index]["updated_at"]}',
                                                                        height: double
                                                                            .infinity,
                                                                        width: double
                                                                            .infinity,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(
                                                                              Icons.error,
                                                                              color: Colors.red,
                                                                              size: 40,
                                                                            ),
                                                                        placeholder: (context,
                                                                                url) =>
                                                                            Center(
                                                                                child: CircularProgressIndicator(
                                                                              color: mode ? Colors.white : dayBar["blue"],
                                                                            )))),
                                                            Opacity(
                                                              opacity: .4,
                                                              child: Container(
                                                                width: getWidth(
                                                                    context),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            Colors.transparent,
                                                                            Colors.black
                                                                          ],
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                          stops: [
                                                                            0,
                                                                            50
                                                                          ],
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                options: CarouselOptions(
                                                  height:
                                                      getHeight(context) / 4,
                                                  autoPlay: true,
                                                  pauseAutoPlayOnTouch: true,
                                                  autoPlayInterval:
                                                      Duration(seconds: 10),
                                                  autoPlayAnimationDuration:
                                                      Duration(seconds: 2),
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  enlargeCenterPage: false,
                                                  enableInfiniteScroll: false,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    context
                                                        .read<
                                                            ClauserIndexCubit>()
                                                        .changeIndex(index);
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: getHeight(context) / 30,
                                              ),
                                              BlocBuilder<ClauserIndexCubit,
                                                  ClauserIndexState>(
                                                builder: (context, state) {
                                                  return AnimatedSmoothIndicator(
                                                    activeIndex: state
                                                            is ChangeIndex
                                                        ? state.newIndex
                                                        : widget.currentIndex,
                                                    count: ads!.length,
                                                    effect: WormEffect(
                                                        activeDotColor: mode
                                                            ? nightBar[
                                                                "buttons"]
                                                            : dayBar["blue"],
                                                        dotColor: Colors.grey,
                                                        dotHeight: 5,
                                                        dotWidth: 5),
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        }
                                      });
                                }
                              }
                            }),
                      ),
                      SizedBox(
                        height: getHeight(context) / 20,
                      ),
                      BlocBuilder<HomeSearchCubit, HomeSearchState>(
                        builder: (context, state) {
                          return FutureBuilder(
                              future: checkConnection(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: Image.asset("images/loading.gif"));
                                } else if (snapshot.hasData &&
                                    snapshot.data! == true &&
                                    !(state is SendSearchValue)) {
                                  return FutureBuilder(
                                    future: _repo.getRootFolders(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: Image.asset(
                                                "images/loading.gif"));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return NoDataFound();
                                      } else {
                                        List data = snapshot.data!;

                                        var copyData = List.from(data);

                                        List d = [];
                                        for (var i = 0;
                                            i < copyData.length;
                                            i++) {
                                          d.add(copyData[i].name);
                                        }
                                        var box = Hive.box(hiveBoxName);

                                        box.put("main", d);

                                        return folders(copyData, false);
                                      }
                                    },
                                  );
                                } else {
                                  return FutureBuilder(
                                    future: state is SendSearchValue
                                        ? state.search
                                            ? getSearchValue(state.searchValue)
                                            : getDataFromHive()
                                        : getDataFromHive(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: Image.asset(
                                                "images/loading.gif"));
                                      } else if (snapshot.data!.isEmpty) {
                                        return Container(
                                            width: getWidth(context),
                                            child: NoDataFound());
                                      } else if (snapshot.hasData) {
                                        List data = snapshot.data!;

                                        return folders(data, true);
                                      } else {
                                        return NoDataFound();
                                      }
                                    },
                                  );
                                }
                              });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            PositionedDirectional(
              end: 10,
              top: getHeight(context) * .03,
              child: Container(
                width: getWidth(context) / 8.5,
                height: getWidth(context) / 8.5,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: mode
                        ? nightBar["orange"].withOpacity(.5)
                        : Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 30,
                          offset: Offset(0, 15)),
                    ],
                    shape: BoxShape.circle),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Profile(),
                    ));
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey,
                  ),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Padding folders(List<dynamic> copyData, offline) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimationLimiter(
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1.5,
          ),
          itemCount: copyData.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: 2,
              duration: Duration(milliseconds: 500),
              child: ScaleAnimation(
                duration: Duration(milliseconds: 800),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(
                  child: GestureDetector(
                    // key: _btnKey,

                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowFolderDetailes(
                              folder: offline
                                  ? copyData[index]
                                  : copyData[index].name,
                              parentId: offline ? "" : copyData[index].id,
                            ),
                          ));
                    },
                    onLongPressStart: (LongPressStartDetails details) {
                      if (checkPermision()) {
                        final RenderBox overlay = Overlay.of(context)
                            .context
                            .findRenderObject() as RenderBox;
                        final Offset position =
                            overlay.globalToLocal(details.globalPosition);
                        _showContextMenu(
                            context,
                            position,
                            copyData[index].name,
                            offline ? copyData[index] : copyData[index].id);
                        // PopupMenu popupMenu = PopupMenu(
                        //   context: context,
                        //   config: const MenuConfig(
                        //     backgroundColor: Colors.green,
                        //     lineColor: Colors.greenAccent,
                        //     highlightColor: Colors.lightGreenAccent,
                        //   ),
                        //   items: [
                        //     PopUpMenuItem(
                        //       title: 'Copy',
                        //       image: Icon(
                        //         Icons.delete,
                        //         color: Colors.white,
                        //       ),
                        //       // onTap: () async {
                        //       //   var ch = await deleteDirectory(offline
                        //       //       ? copyData[index]
                        //       //       : copyData[index].fullPath);
                        //       //   if (!ch) {
                        //       //     lunchAwesomDialoge(
                        //       //         DialogType.error,
                        //       //         "o",
                        //       //         getDeviceLocale() == "ar"
                        //       //             ? "لا يمكن حذف هذا الملف"
                        //       //             : "This file cannot be deleted.",
                        //       //         context,
                        //       //         getWidth(context),
                        //       //         getHeight(context));
                        //       //   } else {
                        //       //     setState(() {});
                        //       //   }
                        //       // },
                        //       // child: Row(
                        //       //   children: [
                        //       //     Icon(
                        //       //       Icons.delete,
                        //       //       color: Colors.white,
                        //       //     ),
                        //       //     Text(
                        //       //       getDeviceLocale() == "ar"
                        //       //           ? " حذف المجلّد"
                        //       //           : "Delete",
                        //       //       style: TextStyle(color: Colors.white),
                        //       //     )
                        //       //   ],
                        //       // )),
                        //     )
                        //   ],
                        //   onClickMenu: (item) {},
                        // );
                        // popupMenu.show(widgetKey: _btnKey);
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
                        gradient: LinearGradient(
                          colors: mode
                              ? [
                                  nightBar["orange"],
                                  nightBar["buttons"],
                                ]
                              : [
                                  const Color.fromARGB(255, 11, 85, 145),
                                  const Color.fromARGB(255, 4, 96, 172)
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(children: [
                              Container(
                                width: getWidth(context),
                                height: getWidth(context) * .21,
                                decoration: BoxDecoration(
                                    color: mode
                                        ? Colors.grey.withOpacity(.4)
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "images/book.png",
                                  width: getWidth(context),
                                  height: getWidth(context) * .15,
                                ),
                              ),
                            ]),
                            FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                offline
                                    ? copyData[index]
                                    : copyData[index].name,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
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
        ),
      ),
    );
  }

  Future<List> getDataFromHive() async {
    var box = await Hive.openBox(hiveBoxName);
    List v = box.get("main");

    return v;
  }

  Future<List> getSearchValue(String searchedValue) async {
    var box = await Hive.openBox(hiveBoxName);
    List v = box.get("main");

    return v.where((value) => value.contains(searchedValue)).toList();
  }

  openClasses(update, preName, {id}) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: mode
            ? nightBar["orange"]
            : const Color.fromARGB(255, 223, 222, 222),
        content: Container(
          width: getWidth(context) * .8,
          height: getWidth(context) * .5,
          child: BlocBuilder<SelecteClassCubit, SelecteClassState>(
            builder: (context, state) {
              return ListView(children: [
                Text(
                    getDeviceLocale() == "ar"
                        ? "الصفوف الابتدائية : "
                        : "Elementary classes:",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: mode ? Colors.white : dayBar["blue2"],
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: mode ? Colors.white : dayBar["blue2"])),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.school,
                        color: mode ? Colors.white : dayBar["blue2"],
                      ),
                      title: Text(getDeviceLocale() == "ar"
                          ? primaryInArabic[index]
                          : primaryInEnglish[index]),
                      trailing: CupertinoCheckbox(
                        value: state is SelecteClass
                            ? getDeviceLocale() == "ar"
                                ? state.selectedClass == primaryInArabic[index]
                                : state.selectedClass == primaryInEnglish[index]
                            : false,
                        onChanged: (value) {
                          getDeviceLocale() == "ar"
                              ? selectedClass = primaryInArabic[index]
                              : selectedClass = primaryInEnglish[index];
                          context
                              .read<SelecteClassCubit>()
                              .selecteClass(selectedClass);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  itemCount: (primaryInEnglish.length),
                ),
                Text(
                    getDeviceLocale() == "ar"
                        ? "الصفوف الإعدادية : "
                        : "Preparatory classes : ",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: mode ? Colors.white : dayBar["blue2"],
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: mode ? Colors.white : dayBar["blue2"])),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.school,
                        color: mode ? Colors.white : dayBar["blue2"],
                      ),
                      title: Text(getDeviceLocale() == "ar"
                          ? preparatoryInArabic[index]
                          : preparatoryInArabic[index]),
                      trailing: CupertinoCheckbox(
                        value: state is SelecteClass
                            ? getDeviceLocale() == "ar"
                                ? state.selectedClass ==
                                    preparatoryInArabic[index]
                                : state.selectedClass ==
                                    preparatoryInEnglish[index]
                            : false,
                        onChanged: (value) {
                          getDeviceLocale() == "ar"
                              ? selectedClass = preparatoryInArabic[index]
                              : selectedClass = preparatoryInEnglish[index];
                          context
                              .read<SelecteClassCubit>()
                              .selecteClass(selectedClass);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  itemCount: (preparatoryInEnglish.length),
                ),
                Text(
                    getDeviceLocale() == "ar"
                        ? "الصفوف الثانوية : "
                        : "Secondary classes : ",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: mode ? Colors.white : dayBar["blue2"],
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        color: mode ? Colors.white : dayBar["blue2"])),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.school,
                        color: mode ? Colors.white : dayBar["blue2"],
                      ),
                      title: Text(
                        getDeviceLocale() == "ar"
                            ? secondaryInArabic[index]
                            : secondaryInEnglish[index],
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: CupertinoCheckbox(
                        value: state is SelecteClass
                            ? getDeviceLocale() == "ar"
                                ? state.selectedClass ==
                                    secondaryInArabic[index]
                                : state.selectedClass ==
                                    secondaryInEnglish[index]
                            : false,
                        onChanged: (value) {
                          getDeviceLocale() == "ar"
                              ? selectedClass = secondaryInArabic[index]
                              : selectedClass = secondaryInEnglish[index];
                          context
                              .read<SelecteClassCubit>()
                              .selecteClass(selectedClass);
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  itemCount: (secondaryInEnglish.length),
                ),
                SizedBox(
                  height: 10,
                ),
                BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
                  builder: (context, state) {
                    return ElevatedButton(
                        onPressed: () async {
                          if (selectedClass.isEmpty) {
                          } else {
                            if (update) {
                              context
                                  .read<LunchLoadingCubit>()
                                  .lunchLoading(true);
                              var check = await _repo.renameFolder(
                                  id, selectedClass, context);
                              if (check) {
                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchLoading(false);
                                Navigator.pop(context);

                                context
                                    .read<RefreshFolderCubit>()
                                    .refreshPage();
                              } else {
                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchLoading(false);
                              }
                            } else {
                              try {
                                context
                                    .read<LunchLoadingCubit>()
                                    .lunchLoading(true);

                                var check = await _repo.createFolder(
                                    selectedClass, context);
                                if (check) {
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(false);
                                  Navigator.pop(context);

                                  context
                                      .read<RefreshFolderCubit>()
                                      .refreshPage();
                                } else {
                                  context
                                      .read<LunchLoadingCubit>()
                                      .lunchLoading(false);
                                }
                              } catch (e) {
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
                          }
                        },
                        child: state is LunchLoading && state.loading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                getDeviceLocale() == "ar"
                                    ? update
                                        ? "تحديث"
                                        : "إضافة"
                                    : update
                                        ? "Update"
                                        : "Add",
                                style: TextStyle(color: Colors.white),
                              ));
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ]);
            },
          ),
        ),
      ),
    );
  }

  // checkManagerCodesPer() async {
  //   var userAuth = FirebaseAuth.instance.currentUser!;
  //   var userInfo = await FirebaseFirestore.instance
  //       .collection("manager")
  //       .doc(userAuth.uid)
  //       .get();
  //   if (userInfo.data() == null) {
  //     return false;
  //   } else if (userInfo.data()!["codes"] == "true") {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  void _showContextMenu(
      BuildContext context, Offset position, previousName, id) {
    final RelativeRect positionRelativeToScreen = RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      MediaQuery.of(context).size.width - position.dx,
      MediaQuery.of(context).size.height - position.dy,
    );

    showMenu(
      context: context,
      position: positionRelativeToScreen,
      color: mode ? nightBar["orange"] : Colors.white,
      items: <PopupMenuEntry<dynamic>>[
        PopupMenuItem(
          child: Center(
            child: Text(
              getDeviceLocale() == "ar" ? "تعديل" : "Edite",
              style: TextStyle(color: mode ? Colors.white : dayBar["blue2"]),
            ),
          ), // Edit
          onTap: () {
            if (school.contains(previousName)) {
              openClasses(true, previousName, id: id);
            } else {
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
                              validator: (value) {
                                return nameValidator(value!);
                              },
                              style: TextStyle(
                                color: mode ? Colors.white : dayBar["blue2"],
                              ),
                              cursorColor:
                                  mode ? Colors.white : dayBar["blue2"],
                              onChanged: (folderName) {
                                widget.name = folderName;
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: .5,
                                        color: mode
                                            ? Colors.white
                                            : dayBar["blue2"],
                                      )),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: .5,
                                        color: mode
                                            ? Colors.white
                                            : dayBar["blue2"],
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: mode
                                            ? Colors.white
                                            : dayBar["blue2"],
                                      )),
                                  hintText: getDeviceLocale() == "ar"
                                      ? "اكتب اسم الجامعة هنا..."
                                      : "Write the name of the university here...",
                                  hintStyle: TextStyle(
                                    color: mode
                                        ? Colors.white.withOpacity(.5)
                                        : dayBar["blue2"].withOpacity(.4),
                                  )),
                            ),
                            BlocBuilder<LunchLoadingCubit, LunchLoadingState>(
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
                                                .read<LunchLoadingCubit>()
                                                .lunchLoading(true);

                                            var check =
                                                await _repo.renameFolder(
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
                                      },
                                      child: state is LunchLoading
                                          ? state.loading
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
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
                                                )
                                          : Text(
                                              getDeviceLocale() == "ar"
                                                  ? Translation().translateMe[
                                                      "Arabic"]!["save_button"]
                                                  : Translation().translateMe[
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
                                          if (!(state is LunchLoading &&
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
            }
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Center(
            child: Text(getDeviceLocale() == "ar" ? "حذف" : "Delete",
                style: TextStyle(color: mode ? Colors.white : dayBar["blue2"])),
          ), // Delete
          onTap: () {
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
                      Text(
                        getDeviceLocale() == "ar"
                            ? "هل أنت متأكد ؟"
                            : "Are you sure?",
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
                                    await _repo.deleteFolder(id);
                                    context
                                        .read<LunchLoadingCubit>()
                                        .lunchLoading(false);

                                    context
                                        .read<RefreshFolderCubit>()
                                        .refreshPage();
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
                                    : Text(
                                        getDeviceLocale() == "ar"
                                            ? "نعم"
                                            : "Yes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              );
                            },
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
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
          },
        ),
      ],
    );
  }

  Future<List> getAdsLocaly() async {
    var box = Hive.box(hiveBoxName);
    List ads = await box.get("ads");
    return ads;
  }
}
