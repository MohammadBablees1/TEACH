import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/cubit/check_connection/check_connection_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/home_search/home_search_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/slelecte_class/selecte_class_cubit.dart';

import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';

import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/sql/sql.dart';

import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/page_veiw.dart';
import 'package:teach/screens/pages/about_app.dart';
import 'package:teach/screens/pages/add_ads.dart';
import 'package:teach/screens/pages/add_folder.dart';
import 'package:teach/screens/pages/add_phone_number.dart';
import 'package:teach/screens/pages/code_generater.dart';
import 'package:teach/screens/pages/create_notification.dart';
import 'package:teach/screens/pages/sell_point.dart';
import 'package:teach/screens/pages/student_profile.dart';
import 'package:teach/screens/pages/show_ads.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';
import 'package:teach/screens/recorded_code.dart/recorded_code.dart';
import 'package:teach/widgets/clipper.dart';
import 'package:teach/widgets/no_data_found.dart';

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
  var box = Hive.box(hiveBoxName);
  Future<void> _reauthenticateAndDelete() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  void initState() {
    registerFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> listOfIcons = [
      Icons.home_rounded,
      Image.asset(
        "images/add-folder.png",
        width: getWidth(context) * .08,
        height: getWidth(context) * .08,
      ),
      Image.asset(
        "images/add_ads.png",
        width: getWidth(context) * .08,
        height: getWidth(context) * .08,
      ),
      checkPermision(box.get(editing), box.get(deleting), box.get(watching),
              box.get(isCode), box.get(isFile), box.get(noting))
          ? Image.asset(
              "images/add_phone.png",
              width: getWidth(context) * .08,
              height: getWidth(context) * .08,
            )
          : "",
      Icons.settings,
    ];
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: BlocBuilder<ManagerScreenCubit, ManagerScreenState>(
        builder: (context, state) {
          if (state is Indexed && state.currentIndex == 0) {
            return main_screen_body(context);
          } else if (state is Indexed && state.currentIndex == 1) {
            return AddFolder();
          } else if (state is Indexed && state.currentIndex == 2) {
            return AddAds();
          } else if (state is Indexed && state.currentIndex == 3) {
            return AddPhoneNumber();
          }
          return main_screen_body(context);
        },
      ),
      bottomNavigationBar: checkPermision(
              false, false, false, false, true, false)
          ? Container(
              margin: const EdgeInsets.all(20),
              height: getWidth(context) * .155,
              decoration: BoxDecoration(
                color: mode ? Colors.white.withOpacity(.5) : Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10))
                ],
                borderRadius: BorderRadius.circular(50),
              ),
              child: BlocBuilder<ManagerScreenCubit, ManagerScreenState>(
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: 4,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(
                        horizontal: getWidth(context) * .024),
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        context.read<ManagerScreenCubit>().changeIndex(index);
                      },
                      splashColor: Colors.transparent,
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 1500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            margin: EdgeInsets.only(
                              bottom: state is Indexed &&
                                      index == state.currentIndex
                                  ? 0
                                  : getWidth(context) * .029,
                              right: getWidth(context) * .0422,
                              left: getWidth(context) * .0422,
                            ),
                            width: getWidth(context) * .128,
                            height:
                                state is Indexed && index == state.currentIndex
                                    ? getWidth(context) * .014
                                    : 0,
                            decoration: BoxDecoration(
                                color:
                                    mode ? nightBar["orange"] : dayBar["blue3"],
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10))),
                          ),
                          index == 0
                              ? Icon(
                                  listOfIcons[index],
                                  size: getWidth(context) * .076,
                                  color: state is Indexed &&
                                          index == state.currentIndex
                                      ? mode
                                          ? nightBar["orange"]
                                          : dayBar["blue3"]
                                      : Colors.black38,
                                )
                              : listOfIcons[index],
                          SizedBox(
                            height: getWidth(context) * .03,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          : Container(),
      drawer: Drawer(
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
                    const Color.fromARGB(255, 1, 37, 87),
                    const Color.fromARGB(255, 1, 37, 87)
                  ],
          )),
          child: ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      width: getWidth(context),
                      height: getWidth(context) * .4,
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: .5, color: Colors.white))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: getWidth(context) * .2,
                            height: getWidth(context) * .2,
                            child: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 197, 197, 197),
                              child: Icon(
                                Icons.settings,
                                size: getWidth(context) * .1,
                                color:
                                    mode ? nightBar["orange"] : dayBar["blue3"],
                              ),
                            ),
                          ),
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "الإعدادات"
                                : "Settings",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: getWidth(context) * .05),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: getWidth(context),
                      height: getWidth(context) * 1.3,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentProfile(),
                                  ));
                            },
                            leading: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "الملف الشخصي"
                                  : "Profile",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SellPoint(),
                                  ));
                            },
                            leading: Icon(
                              Icons.sell,
                              color: Colors.white,
                            ),
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "نقاط البيع"
                                  : "Points of Sale",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          checkPermision(
                                  false, false, false, true, false, false)
                              ? Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RecordedCode(),
                                            ));
                                      },
                                      leading: Icon(
                                        Icons.code,
                                        color: Colors.white,
                                      ),
                                      title: AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "سجل الأكواد"
                                            : "Codes",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      width: getWidth(context),
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                )
                              : Container(),
                          box.get(isMainManager)
                              ? ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CodeGenerater(),
                                        ));
                                  },
                                  leading: Icon(
                                    Icons.group_add_outlined,
                                    color: Colors.white,
                                  ),
                                  title: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "إنشاء حساب مدير"
                                        : "create new manager",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                          box.get(isMainManager)
                              ? Container(
                                  width: getWidth(context),
                                  height: 1,
                                  color: Colors.grey.shade300,
                                )
                              : Container(),
                          box.get(isMainManager) ||
                                  checkPermision(
                                      false, false, false, false, false, true)
                              ? ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateNotification(),
                                        ));
                                  },
                                  leading: Icon(
                                    Icons.notification_add,
                                    color: Colors.white,
                                  ),
                                  title: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? "إنشاء إشعار جديد "
                                        : "create new notification",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Container(),
                          box.get(isMainManager) ||
                                  checkPermision(
                                      false, false, false, false, false, true)
                              ? Container(
                                  width: getWidth(context),
                                  height: 1,
                                  color: Colors.grey.shade300,
                                )
                              : Container(),
                          SwitchListTile(
                            value: mode,
                            activeColor: mode
                                ? Colors.green
                                : const Color.fromARGB(255, 11, 85, 145),
                            onChanged: (value) async {
                              mode = mode ? false : true;

                              BlocProvider.of<ThemModeCubit>(context)
                                  .isDarkMode(mode);
                            },
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "الوضع الليلي"
                                  : "Night mode",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          SwitchListTile(
                            value: getDeviceLocale() == "ar" ? false : true,
                            activeColor: mode
                                ? Colors.green
                                : const Color.fromARGB(255, 11, 85, 145),
                            onChanged: (value) async {
                              language = value;

                              BlocProvider.of<ThemModeCubit>(context)
                                  .changeLanguage(language);

                              var data = await Sql().getLan();
                              if (data.isEmpty) {
                                await Sql().lunchEn();
                              } else {
                                await Sql().updateLan(
                                    language == "ar" ? "false" : "true");
                              }
                            },
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "اللغة الإنكليزية"
                                  : "English language",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          ListTile(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AboutApp(),
                                  ));
                            },
                            leading: Icon(
                              Icons.phone_android,
                              color: Colors.white,
                            ),
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "حول التطبيق"
                                  : "About the app",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          ListTile(
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
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          getDeviceLocale() == "ar"
                                              ? "هل أنت متأكد ؟"
                                              : "Are you sure?",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                if (await checkConnection()) {
                                                  context
                                                      .read<LunchLoadingCubit>()
                                                      .lunchLoading(true);

                                                  await _reauthenticateAndDelete();
                                                  context
                                                      .read<LunchLoadingCubit>()
                                                      .lunchLoading(false);
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PageVeiwScreen(),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                  var box =
                                                      Hive.box(hiveBoxName);
                                                  box.delete(isStudent);
                                                  box.delete(isMainManager);
                                                  box.delete(isManager);
                                                  box.delete(isCode);
                                                  box.delete(isFile);
                                                  box.delete("info");
                                                  mode = false;

                                                  BlocProvider.of<
                                                              ThemModeCubit>(
                                                          context)
                                                      .isDarkMode(mode);

                                                  BlocProvider.of<
                                                              ThemModeCubit>(
                                                          context)
                                                      .isDarkMode(false);
                                                  BlocProvider.of<
                                                              ThemModeCubit>(
                                                          context)
                                                      .changeLanguage(false);
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
                                              child: AutoSizeText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 10,
                                                maxFontSize: 15,
                                                getDeviceLocale() == "ar"
                                                    ? "نعم"
                                                    : "Yes",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "إلغاء"
                                                      : "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.output_sharp,
                              color: Colors.white,
                            ),
                            title: AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "تسجيل الخروج"
                                  : "Sign out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Container(
                            width: getWidth(context),
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget main_screen_body(BuildContext context) {
    return BlocConsumer<RefreshFolderCubit, RefreshFolderState>(
      listener: (context, state) {
        setState(() {});
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  ClipPath(
                    clipper: CurvedAppBarClipper(),
                    child: Container(
                      height: getWidth(context) * .5,
                      decoration: BoxDecoration(
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: AppBar(
                        title: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "أهلاً بك ${box.get(isMainManager) ? box.get("Mname") : box.get("info")[0]}"
                                : "Welcom ${box.get("info")[0]}"),
                        leading: Builder(builder: (context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.list_rounded,
                                color: Colors.white,
                              ));
                        }),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        centerTitle: true,
                      ),
                    ),
                  ),
                  Column(
                    children: [
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
                                  child: myImageAsset(
                                      "images/loading.gif", context),
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
                                          child: myImageAsset(
                                              "images/loading.gif", context),
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
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  // SizedBox(
                  //   height: getHeight(context) * .3,
                  // ),

                  BlocBuilder<HomeSearchCubit, HomeSearchState>(
                    builder: (context, state) {
                      return FutureBuilder(
                          future: checkConnection(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: myImageAsset(
                                      "images/loading.gif", context));
                            } else if (snapshot.hasData &&
                                snapshot.data! == true &&
                                !(state is SendSearchValue)) {
                              return FutureBuilder(
                                future: _repo.getRootFolders(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child:
                                            Image.asset("images/loading.gif"));
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return NoDataFound();
                                  } else {
                                    List data = snapshot.data!;

                                    var copyData = List.from(data);

                                    List d = [];
                                    for (var i = 0; i < copyData.length; i++) {
                                      d.add({
                                        "id": copyData[i].id,
                                        "name": copyData[i].name,
                                        "image_url": copyData[i].imageUrl,
                                        "count": copyData[i].childCount
                                      });
                                    }
                                    var box = Hive.box(hiveBoxName);

                                    box.put("main", d);

                                    return folders(copyData, false);
                                  }
                                },
                              );
                            } else {
                              return FutureBuilder(
                                future: getDataFromHive(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child:
                                            Image.asset("images/loading.gif"));
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
                  SizedBox(
                    height: getWidth(context) * .15,
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Padding folders(List<dynamic> copyData, offline) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: getHeight(context),
        child: Stack(
          children: [
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: copyData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowFolderDetailes(
                                folder: offline
                                    ? copyData[index]
                                    : copyData[index].name,
                                parentId: offline ? "" : copyData[index].id,
                                manage: false,
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
                                      ? copyData[index]["image_url"] == null
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
                                                  )))
                                      : copyData[index].imageUrl == null
                                          ? Image.asset(
                                              "images/icon.jpg",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : CachedNetworkImage(
                                              cacheManager: customCachManager,
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
                                              placeholder: (context, url) =>
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
                                        borderRadius: BorderRadius.circular(30),
                                        color: mode
                                            ? nightBar["orange"].withOpacity(.5)
                                            : dayBar["blue2"].withOpacity(.5)),
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
                                              ? copyData[index]["count"]
                                              : copyData[index].childCount,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  checkPermision(true, false, false, false,
                                          false, false)
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (await checkConnection()) {
                                              await showEditeDialoge(
                                                  copyData[index].id);
                                            }
                                          },
                                          child: Container(
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
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "تعديل"
                                                      : "ُEdite",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getWidth(context) *
                                                              .026,
                                                      color: Colors.white,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  checkPermision(false, true, false, false,
                                          false, false)
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (await checkConnection()) {
                                              await showDeleteDialoge(
                                                  copyData[index].id);
                                            }
                                          },
                                          child: Container(
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
                                                const Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                                AutoSizeText(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  minFontSize: 10,
                                                  maxFontSize: 15,
                                                  getDeviceLocale() == "ar"
                                                      ? "حذف"
                                                      : "Delete",
                                                  style: TextStyle(
                                                      fontSize:
                                                          getWidth(context) *
                                                              .026,
                                                      color: Colors.white,
                                                      overflow: TextOverflow
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
                  );
                }),
          ],
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
                AutoSizeText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 15,
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
                      title: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
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
                AutoSizeText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 15,
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
                      title: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
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
                AutoSizeText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 10,
                    maxFontSize: 15,
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
                      title: AutoSizeText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 10,
                        maxFontSize: 15,
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
                            : AutoSizeText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 10,
                                maxFontSize: 15,
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
            child: AutoSizeText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              minFontSize: 10,
              maxFontSize: 15,
              getDeviceLocale() == "ar" ? "تعديل" : "Edite",
              style: TextStyle(color: mode ? Colors.white : dayBar["blue2"]),
            ),
          ), // Edit
          onTap: () {
            if (school.contains(previousName)) {
              openClasses(true, previousName, id: id);
            } else {}
          },
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: Center(
            child: AutoSizeText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                maxFontSize: 15,
                getDeviceLocale() == "ar" ? "حذف" : "Delete",
                style: TextStyle(color: mode ? Colors.white : dayBar["blue2"])),
          ), // Delete
          onTap: () {},
        ),
      ],
    );
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
                            await _repo.deleteFolder(id, null, context);
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
                            child: state is LunchLoading
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  mode ? nightBar["buttons"] : dayBar["blue3"],
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

  Future<List> getAdsLocaly() async {
    var box = Hive.box(hiveBoxName);
    List ads = await box.get("ads");
    return ads;
  }
}
