import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/cubit/change_name/change_name_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/home_search/home_search_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/search/search_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/cubit/them_mode/them_mode_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/modules/folders.dart';
import 'package:teach/data/modules/translate_consts.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/page_veiw.dart';
import 'package:teach/screens/pages/about_app.dart';
import 'package:teach/screens/pages/bar_code_scanner.dart';

import 'package:teach/screens/pages/sell_point.dart';
import 'package:teach/screens/pages/show_ads.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';
import 'package:teach/screens/pages/student_manage_codes.dart';
import 'package:teach/screens/pages/student_profile.dart';
import 'package:teach/widgets/clipper.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:teach/widgets/watchers_card.dart';
import 'package:teach/widgets/wave_appbar.dart';

class StudentMainScreen extends StatefulWidget {
  var home = true, len = 0;
  var currentIndex = 0;
  var name = "", loading = false;
  var isEditing = false;
  var currentUser = "";
  var see = false;
  var codeController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey();
  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 7),
  ));
  final FolderRepository _repo = FolderRepository(supabase);
  @override
  void initState() {
    registerFCMToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box(hiveBoxName);
    return Scaffold(
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
                  : [dayBar["blue3"], dayBar["blue3"]],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            children: [
              Container(
                child: DrawerHeader(
                  child: Column(
                    children: [
                      Container(
                          width: getWidth(context) * .2,
                          height: getWidth(context) * .2,
                          child: CircleAvatar(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "images/icon.jpg",
                                  width: getWidth(context),
                                  fit: BoxFit.cover,
                                )),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<ChangeNameCubit, ChangeNameState>(
                        builder: (context, state) {
                          return AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            box.get("student_name") ?? "غير معرّف",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
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
                  getDeviceLocale() == "ar" ? "الملف الشخصي" : "Profile",
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
                        builder: (context) => StudentManageCodes(),
                      ));
                },
                leading: Icon(
                  Icons.precision_manufacturing_rounded,
                  color: Colors.white,
                ),
                title: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar"
                      ? "إدارة الاشتراكات"
                      : "Subscription Management",
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
                  getDeviceLocale() == "ar" ? "نقاط البيع" : "Points of Sale",
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
                        builder: (context) => BarCodeScanner(
                          check: false,
                          userEmail1: "",
                          userPassword1: "",
                          universityNumber: TextEditingController(text: ""),
                        ),
                      ));
                },
                leading: Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                title: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar"
                      ? "تفعيل اشتراك تلقائي"
                      : "Activate automatic subscription",
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
                      content: Container(
                        width: getWidth(context) * .7,
                        height: getWidth(context) * .4,
                        child: Form(
                          key: widget.globalKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    return codeValidator(value!);
                                  },
                                  controller: widget.codeController,
                                  keyboardType: TextInputType.name,
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
                                        ? "اكتب كود الكورس هنا..."
                                        : "Write the course code here...",
                                    hintStyle: TextStyle(),
                                    prefixIcon: IconButton(
                                      onPressed: () async {},
                                      icon: Icon(
                                        Icons.code,
                                        color: dayBar["blue2"],
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(color: dayBar["blue"]),
                                ),
                              ),
                              BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                      onPressed: () async {
                                        if (widget.globalKey.currentState!
                                            .validate()) {
                                          context
                                              .read<LoadingPdfCubit>()
                                              .loadingPdf(true);
                                          var check = false;
                                          var codes = await supabase
                                              .from("codes")
                                              .select();
                                          for (var i = 0;
                                              i < codes.length;
                                              i++) {
                                            if (codes[i]["id"] ==
                                                widget.codeController.text
                                                    .trim()) {
                                              var user = await supabase
                                                  .from("current_user")
                                                  .select()
                                                  .eq(
                                                      "id",
                                                      supabase.auth.currentUser!
                                                          .id);
                                              var code = user[0]["codes"];

                                              if (code.toString().contains(
                                                  codes[i]["folder_id"])) {
                                                context
                                                    .read<LoadingPdfCubit>()
                                                    .loadingPdf(false);
                                                lunchAwesomDialoge(
                                                    DialogType.error,
                                                    "e",
                                                    getDeviceLocale() == "ar"
                                                        ? "لقد اشتركت بالفعل بهذا الكورس"
                                                        : "You have already signed up for this course.",
                                                    context,
                                                    getWidth(context),
                                                    getHeight(context));
                                                check = true;
                                                break;
                                              }
                                              code.add(codes[i]["folder_id"]);
                                              await supabase
                                                  .from("current_user")
                                                  .update({"codes": code}).eq(
                                                      "id",
                                                      supabase.auth.currentUser!
                                                          .id);
                                              await supabase
                                                  .from("codes")
                                                  .delete()
                                                  .eq("id", codes[i]["id"]);
                                              var ch = await supabase
                                                  .from("sold_codes")
                                                  .select()
                                                  .eq("name", codes[i]["name"])
                                                  .maybeSingle();
                                              if (ch != null) {
                                                var total = int.parse(
                                                    ch["count"].toString());
                                                total++;
                                                await supabase
                                                    .from("sold_codes")
                                                    .update({
                                                  "count": total
                                                }).eq("id", ch["id"]);
                                              } else {
                                                await supabase
                                                    .from("sold_codes")
                                                    .insert({
                                                  "name": codes[i]["name"],
                                                  "count": 1
                                                });
                                              }

                                              check = true;
                                              context
                                                  .read<LoadingPdfCubit>()
                                                  .loadingPdf(false);
                                              Fluttertoast.showToast(
                                                  msg: getDeviceLocale() == "ar"
                                                      ? "تمّ شراء الكورس بنجاح"
                                                      : "The course has been successfully purchased.",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              Navigator.pop(context);
                                              break;
                                            }
                                          }
                                          if (!check) {
                                            context
                                                .read<LoadingPdfCubit>()
                                                .loadingPdf(false);
                                            lunchAwesomDialoge(
                                                DialogType.error,
                                                "e",
                                                getDeviceLocale() == "ar"
                                                    ? "الكود غير صالح"
                                                    : "The code is invalid",
                                                context,
                                                getWidth(context),
                                                getHeight(context));
                                          }
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
                                              getDeviceLocale() == "ar"
                                                  ? "شراء"
                                                  : "Buy",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                leading: Icon(
                  Icons.money,
                  color: Colors.white,
                ),
                title: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar"
                      ? "تفعيل اشتراك يدوي"
                      : "Manual subscription activation",
                  style: TextStyle(color: Colors.white),
                ),
              ),

              Container(
                width: getWidth(context),
                height: 1,
                color: Colors.grey.shade300,
              ),

              SwitchListTile(
                value: mode,
                activeColor: mode
                    ? Colors.green
                    : const Color.fromARGB(255, 11, 85, 145),
                onChanged: (value) async {
                  mode = mode ? false : true;

                  BlocProvider.of<ThemModeCubit>(context).isDarkMode(mode);
                },
                title: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar" ? "الوضع الليلي" : "Night mode",
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
                    await Sql().updateLan(language == "ar" ? "false" : "true");
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
                  getDeviceLocale() == "ar" ? "حول التطبيق" : "About the app",
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
                      backgroundColor:
                          mode ? nightBar["orange"] : dayBar["blue"],
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
                              getDeviceLocale() == "ar"
                                  ? "هل أنت متأكد ؟"
                                  : "Are you sure?",
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PageVeiwScreen(),
                                          ));
                                      var box = Hive.box(hiveBoxName);
                                      box.delete(isStudent);
                                      box.delete(isMainManager);
                                      box.delete(isManager);
                                      box.delete(isCode);
                                      box.delete(isFile);
                                      box.delete("info");
                                      mode = false;

                                      BlocProvider.of<ThemModeCubit>(context)
                                          .isDarkMode(mode);

                                      BlocProvider.of<ThemModeCubit>(context)
                                          .isDarkMode(false);
                                      BlocProvider.of<ThemModeCubit>(context)
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
                                    getDeviceLocale() == "ar" ? "نعم" : "Yes",
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                                      getDeviceLocale() == "ar"
                                          ? "إلغاء"
                                          : "Cancel",
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
                leading: Icon(
                  Icons.output_sharp,
                  color: Colors.white,
                ),
                title: AutoSizeText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 10,
                  maxFontSize: 15,
                  getDeviceLocale() == "ar" ? "تسجيل الخروج" : "Sign out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                width: getWidth(context),
                height: 1,
                color: Colors.grey.shade300,
              ),

              // عناصر القائمة هنا
            ],
          ),
        ),
      ),
      body:
          // CustomWaveAppBar(
          //   username: box.get("student_name") ?? "",
          //   onSearch: (query) {
          //     if (query.isEmpty) {
          //       context.read<HomeSearchCubit>().searchForValue(false, "");
          //     } else {
          //       context.read<HomeSearchCubit>().searchForValue(true, query);
          //     }
          //   },
          // ),
          SingleChildScrollView(
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
                      title: BlocBuilder<ChangeNameCubit, ChangeNameState>(
                        builder: (context, state) {
                          return AutoSizeText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              minFontSize: 10,
                              maxFontSize: 15,
                              getDeviceLocale() == "ar"
                                  ? "أهلاً بك ${box.get("student_name")}"
                                  : "Welcom ${box.get("student_name")}");
                        },
                      ),
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
                      // // title: AutoSizeText(
                      //       maxLines: 1,
                      //       overflow: TextOverflow.ellipsis,
                      //       minFontSize: 10,
                      //       maxFontSize: 15,getDeviceLocale() == "ar" ? "الرئيسية" : "Home"),
                      centerTitle: true,
                    ),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: getHeight(context) * .1,
                    ),
                    FutureBuilder(
                        future: checkConnection(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child:
                                  myImageAsset("images/loading.gif", context),
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
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowAds(
                                                              ads: ads,
                                                              index: index),
                                                    ),
                                                  );
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Container(
                                                  width: getWidth(context),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Stack(
                                                    children: [
                                                      ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
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
                                                                  errorWidget:
                                                                      (context,
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
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                        color: mode
                                                                            ? Colors.white
                                                                            : dayBar["blue"],
                                                                      )))),
                                                      Opacity(
                                                        opacity: .4,
                                                        child: Container(
                                                          width:
                                                              getWidth(context),
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
                                                                      BorderRadius
                                                                          .circular(
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
                                            autoPlayCurve: Curves.fastOutSlowIn,
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
                                              activeIndex: state is ChangeIndex
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
                                  future: BlocProvider.of<TeachCubit>(context)
                                      .getAllAds(),
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
                                      var ads = snapshot.data;
                                      var box = Hive.box(hiveBoxName);
                                      box.put("ads", ads);
                                      // var box = Hive.box(hiveBoxName);
                                      // box.put("ads", ads);

                                      return Column(
                                        children: [
                                          CarouselSlider.builder(
                                            itemCount: snapshot.data!.length,
                                            itemBuilder:
                                                (context, index, realIndex) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(20.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ShowAds(
                                                                ads: ads,
                                                                index: index),
                                                      ),
                                                    );
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                    width: getWidth(context),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                    child: Stack(
                                                      children: [
                                                        ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
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
                                                                    errorWidget:
                                                                        (context,
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
                                                                            child:
                                                                                CircularProgressIndicator(
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
                                                count: ads!.length,
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
                                  });
                            }
                          }
                        }),
                  ],
                )
              ],
            ),
            BlocBuilder<HomeSearchCubit, HomeSearchState>(
              builder: (context, homeSatate) {
                return Column(
                  children: [
                    FutureBuilder(
                        future: checkConnection(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child:
                                  myImageAsset("images/loading.gif", context),
                            );
                          } else {
                            var data = snapshot.data;
                            if (!data!) {
                              return (homeSatate is SendSearchValue &&
                                          !homeSatate.search) ||
                                      (homeSatate is! SendSearchValue)
                                  ? Column(
                                      children: [
                                        ((homeSatate is SendSearchValue &&
                                                    !homeSatate.search) ||
                                                (homeSatate
                                                    is! SendSearchValue))
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: getWidth(context),
                                                  height:
                                                      getWidth(context) * .1,
                                                  child: AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    getDeviceLocale() == "ar"
                                                        ? "الكورسات الشائعة"
                                                        : "Popular courses",
                                                    style: TextStyle(
                                                        color: mode
                                                            ? Colors.white
                                                            : dayBar["blue2"],
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        (homeSatate is SendSearchValue &&
                                                    !homeSatate.search) ||
                                                (homeSatate is! SendSearchValue)
                                            ? FutureBuilder<
                                                List<Map<String, dynamic>>>(
                                                future: getData(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                      child: Image.asset(
                                                          "images/loading.gif"),
                                                    );
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data == null ||
                                                      snapshot.data!.isEmpty) {
                                                    return Container(
                                                      width: getWidth(context) *
                                                          .4,
                                                      height:
                                                          getWidth(context) *
                                                              .4,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            width: getWidth(
                                                                    context) *
                                                                .4,
                                                            height: getWidth(
                                                                    context) *
                                                                .3,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child:
                                                                  Image.asset(
                                                                "iamges/no_data.jpg",
                                                                width: double
                                                                    .infinity,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    );
                                                  }

                                                  final topCourses =
                                                      snapshot.data![0]["0"];
                                                  final names =
                                                      snapshot.data![0]["1"];

                                                  return CarouselSlider.builder(
                                                    itemCount:
                                                        topCourses.length,
                                                    options: CarouselOptions(
                                                      height:
                                                          getHeight(context) /
                                                              4,
                                                      autoPlay: false,
                                                      enlargeCenterPage: false,
                                                      enableInfiniteScroll:
                                                          false,
                                                    ),
                                                    itemBuilder: (context,
                                                        index, realIndex) {
                                                      final course =
                                                          topCourses[index];
                                                      var number =
                                                          names.keys.toList();
                                                      var sendedIndex = 0;
                                                      for (var i = 0;
                                                          i < number.length;
                                                          i++) {
                                                        if (index < number[i]) {
                                                          sendedIndex =
                                                              number[i];
                                                          break;
                                                        }
                                                      }

                                                      return CourseCard(
                                                        course: course,
                                                        name:
                                                            names[sendedIndex],
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : Container(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: getWidth(context),
                                            height: getWidth(context) * .1,
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 10,
                                              maxFontSize: 15,
                                              getDeviceLocale() == "ar"
                                                  ? (homeSatate is SendSearchValue &&
                                                              !homeSatate
                                                                  .search) ||
                                                          (homeSatate
                                                              is! SendSearchValue)
                                                      ? "الكورسات المتوفرة"
                                                      : "نتائج البحث"
                                                  : (homeSatate is SendSearchValue &&
                                                              !homeSatate
                                                                  .search) ||
                                                          (homeSatate
                                                              is! SendSearchValue)
                                                      ? "Available courses"
                                                      : "Search results",
                                              style: TextStyle(
                                                  color: mode
                                                      ? Colors.white
                                                      : dayBar["blue2"],
                                                  fontSize: 20),
                                            ),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: homeSatate is SendSearchValue
                                              ? homeSatate.search
                                                  ? getSearchValue(
                                                      homeSatate.searchValue)
                                                  : getDataFromHive()
                                              : getDataFromHive(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child: myImageAsset(
                                                      "images/loading.gif",
                                                      context));
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
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
                                        ),
                                      ],
                                    )
                                  : Container();
                            } else {
                              return Column(
                                children: [
                                  (homeSatate is SendSearchValue &&
                                              !homeSatate.search) ||
                                          (homeSatate is! SendSearchValue)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: getWidth(context),
                                            height: getWidth(context) * .1,
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 10,
                                              maxFontSize: 15,
                                              getDeviceLocale() == "ar"
                                                  ? "الكورسات الشائعة"
                                                  : "Popular courses",
                                              style: TextStyle(
                                                  color: mode
                                                      ? Colors.white
                                                      : dayBar["blue2"],
                                                  fontSize: 20),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  (homeSatate is SendSearchValue &&
                                              !homeSatate.search) ||
                                          (homeSatate is! SendSearchValue)
                                      ? FutureBuilder(
                                          future: checkConnection(),
                                          builder: (context, connection) {
                                            if (connection.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                child: myImageAsset(
                                                    "images/loading.gif",
                                                    context),
                                              );
                                            }

                                            var checkConnection =
                                                connection.data!;
                                            var box = Hive.box(hiveBoxName);
                                            return FutureBuilder<
                                                List<Map<String, dynamic>>>(
                                              future: getTopViewedCourses(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child: myImageAsset(
                                                        "images/loading.gif",
                                                        context),
                                                  );
                                                } else if (!snapshot.hasData ||
                                                    snapshot.data == null ||
                                                    snapshot.data!.isEmpty) {
                                                  return Container();
                                                }

                                                final topCourses =
                                                    snapshot.data![0]["0"];
                                                final names =
                                                    snapshot.data![0]["1"];

                                                return CarouselSlider.builder(
                                                  itemCount: topCourses.length,
                                                  options: CarouselOptions(
                                                    height:
                                                        getHeight(context) / 4,
                                                    autoPlay: false,
                                                    enlargeCenterPage: false,
                                                    enableInfiniteScroll: false,
                                                  ),
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    if (checkConnection) {
                                                      var box =
                                                          Hive.box(hiveBoxName);
                                                      box.put(
                                                          "top10", topCourses);
                                                      box.put("topName", names);
                                                    }

                                                    final course =
                                                        topCourses[index];
                                                    var number =
                                                        names.keys.toList();
                                                    var sendedIndex = 0;
                                                    for (var i = 0;
                                                        i < number.length;
                                                        i++) {
                                                      if (index < number[i]) {
                                                        sendedIndex = number[i];
                                                        break;
                                                      }
                                                    }

                                                    return CourseCard(
                                                      course: course,
                                                      name: names[sendedIndex],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          })
                                      : Container(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: getWidth(context),
                                      height: getWidth(context) * .1,
                                      child: AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? (homeSatate is SendSearchValue &&
                                                        !homeSatate.search) ||
                                                    (homeSatate
                                                        is! SendSearchValue)
                                                ? "الكورسات المتوفرة"
                                                : "نتائج البحث"
                                            : (homeSatate is SendSearchValue &&
                                                        !homeSatate.search) ||
                                                    (homeSatate
                                                        is! SendSearchValue)
                                                ? "Available courses"
                                                : "Search results",
                                        style: TextStyle(
                                            color: mode
                                                ? Colors.white
                                                : dayBar["blue2"],
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  BlocBuilder<HomeSearchCubit, HomeSearchState>(
                                    builder: (context, state) {
                                      return FutureBuilder(
                                          future: checkConnection(),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return myImageAsset(
                                                  "images/loading.gif",
                                                  context);
                                            } else if (snapshot.hasData &&
                                                snapshot.data! == true &&
                                                !(state is SendSearchValue)) {
                                              var conection = snapshot.data;
                                              return FutureBuilder(
                                                future: _repo
                                                    .getChildFoldersForStudent(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child: myImageAsset(
                                                            "images/loading.gif",
                                                            context));
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data!.isEmpty) {
                                                    return NoDataFound();
                                                  } else {
                                                    List data = snapshot.data!;

                                                    var copyData =
                                                        List.from(data);

                                                    // List d = [];
                                                    // for (var i = 0;
                                                    //     i <
                                                    //         copyData
                                                    //             .length;
                                                    //     i++) {
                                                    //   d.add(
                                                    //       copyData[i]
                                                    //           .name);
                                                    // }
                                                    var box =
                                                        Hive.box(hiveBoxName);

                                                    box.put(
                                                        "main",
                                                        copyData
                                                            .map(
                                                              (e) => {
                                                                "name": e.name,
                                                                "image_url":
                                                                    e.imageUrl,
                                                                "child_count":
                                                                    e.childCount
                                                              },
                                                            )
                                                            .toList());

                                                    return folders(
                                                        copyData, false);
                                                  }
                                                },
                                              );
                                            } else {
                                              var conection = snapshot.data;
                                              return FutureBuilder(
                                                future: state is SendSearchValue
                                                    ? state.search
                                                        ? getSearchValue(
                                                            state.searchValue)
                                                        : conection!
                                                            ? _repo
                                                                .getChildFoldersForStudent()
                                                            : getDataFromHive()
                                                    : conection!
                                                        ? _repo
                                                            .getChildFoldersForStudent()
                                                        : getDataFromHive(),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return Center(
                                                        child: Image.asset(
                                                            "images/loading.gif"));
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data!.isEmpty) {
                                                    return Container(
                                                        width:
                                                            getWidth(context),
                                                        child: NoDataFound());
                                                  } else if (snapshot.hasData) {
                                                    List data = snapshot.data!;

                                                    return folders(
                                                        data, !conection!);
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
                              );
                            }
                          }
                        }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Padding folders(List<dynamic> copyData, offline) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          ListView.builder(
              shrinkWrap: true,
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
                                  ? copyData[index]["name"]
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
                                    ? copyData[index]["image_url"] == null ||
                                            copyData[index]["image_url"].isEmpty
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
                                    : copyData[index].imageUrl == null ||
                                            copyData[index].imageUrl.isEmpty
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                            ? copyData[index]["child_count"]
                                            : copyData[index].childCount,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
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
    );
  }

  Future<List> getAdsLocaly() async {
    var box = Hive.box(hiveBoxName);
    List ads = await box.get("ads");
    return ads;
  }

  Future<List> getDataFromHive() async {
    var box = await Hive.openBox(hiveBoxName);
    List v = box.get("main");
    return v;
  }

  Future<List> getSearchValue(String searchedValue) async {
    if (await checkConnection()) {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);
      var folder_id;

      if (data[0]["collage"].toString() == "null") {
        // folder_id = id[0]["id"];

        var id = await supabase
            .from("folders")
            .select()
            .eq("name", data[0]["category"]);
        folder_id = id[0]["id"];
      } else {
        var root_id = await supabase
            .from("folders")
            .select()
            .eq("name", data[0]["category"]);
        var id = await supabase
            .from("folders")
            .select()
            .eq("name", data[0]["collage"])
            .eq("parent_id", root_id[0]["id"]);
        folder_id = id[0]["id"];
      }

      var search = await searchInFolder(
          folderId: folder_id.toString(), searchQuery: searchedValue);

      return search;
    } else {
      var box = await Hive.openBox(hiveBoxName);
      List v = box.get("main");

      return v.where((value) => value.contains(searchedValue)).toList();
    }
  }

  Future getAllSubfolders(String parentId) async {
    final List<Map<String, dynamic>> allFolders = [];

    Future<void> fetchSubfolders(int folderId) async {
      final response =
          await supabase.from('folders').select().eq('parent_id', folderId);

      for (final folder in response) {
        allFolders.add(folder);
        await fetchSubfolders(folder['id']); // استدعاء ذاتي للمجلدات الفرعية
      }
    }

    await fetchSubfolders(int.parse(parentId));

    return allFolders;
  }

  Future<List<Folder?>> searchInFolder({
    required String folderId,
    String? searchQuery,
  }) async {
    // 1. جلب جميع المجلدات الفرعية
    try {
      List<Map<String, dynamic>> subFolders = await getAllSubfolders(folderId);

      List<Folder> results = [];
      for (var i = 0; i < subFolders.length; i++) {
        if (subFolders[i]["name"].toString().contains(searchQuery.toString())) {
          results.add(Folder.fromJson(subFolders[i]));
        }
      }

      return results;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopViewedCourses() async {
    if (await checkConnection()) {
      var data = await supabase
          .from("current_user")
          .select()
          .eq("id", supabase.auth.currentUser!.id);
      var response = await supabase
          .from('curces')
          .select()
          .eq("grade", data[0]["category"]); // جلب الكورسات مع مشاهداتها

      if (response.isEmpty) return [];

      // ترتيب الكورسات حسب عدد المشاهدين
      final sortedCourses = response.map((course) {
        final viewers = (course['watchers'] as List).length;
        return {
          ...course,
          'viewers_count': viewers, // إضافة حقل عددي لعدد المشاهدين
        };
      }).toList()
        ..sort((a, b) =>
            b['viewers_count'].compareTo(a['viewers_count'])); // ترتيب تنازلي

      Map subjects = {};
      var sum = 0;
      try {
        for (var i = 0;
            i < (sortedCourses.length <= 10 ? sortedCourses.length : 10);
            i++) {
          if (i + 1 !=
                  (sortedCourses.length <= 10 ? sortedCourses.length : 10) &&
              sortedCourses[i]["subject-folder"] ==
                  sortedCourses[i + 1]["subject-folder"]) {
            sum++;
          } else {
            sum++;
            var folders = await supabase
                .from("folders")
                .select()
                .eq("id", sortedCourses[i]["subject-folder"]);

            subjects.addAll({sum: folders[0]["name"]});
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      return [
        {"0": sortedCourses.take(10).toList(), "1": subjects},
      ]; // إرجاع أول 10 فقط
    } else {
      var box = Hive.box(hiveBoxName);
      return [
        {"0": box.get("top10"), "1": box.get("topName")}
      ];
    }
  }

  Future<void> _reauthenticateAndDelete() async {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      // Handle exceptions
    }
  }

  Future<List> getEmpty() async {
    return [];
  }

  Future<List<Map<String, dynamic>>> getData() async {
    var box = Hive.box(hiveBoxName);
    return [
      {"0": box.get("top10"), "1": box.get("topName")}
    ];
  }
}
