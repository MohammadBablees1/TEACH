// ignore: file_names
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/features/user_profile/presentation/manager/change_name/change_name_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/features/recorded_code/presentation/manager/home_search/home_search_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/student-main-screen/data/get_ads_localy.dart';
import 'package:teach/features/student-main-screen/data/get_root_folder_from_hive.dart';
import 'package:teach/features/student-main-screen/data/get_top_curces.dart';
import 'package:teach/features/student-main-screen/presentation/manager/open_popular_curse_loading/open_popular_curse_loading_cubit.dart';
import 'package:teach/features/student-main-screen/presentation/widget/folder.dart';
import 'package:teach/features/student-main-screen/repo/get_child_folders_for_student.dart';
import 'package:teach/features/student-main-screen/repo/top_curces_view_repo.dart';
import 'package:teach/screens/pages/show_ads.dart';
import 'package:teach/widgets/clipper.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:teach/features/student-main-screen/presentation/widget/watchers_card.dart';

class Bodystudentmainscreen extends StatefulWidget {
  late final int currentIndex;
  // ignore: prefer_const_constructors_in_immutables
  Bodystudentmainscreen({super.key});

  @override
  State<Bodystudentmainscreen> createState() => _BodystudentmainscreenState();
}

class _BodystudentmainscreenState extends State<Bodystudentmainscreen> {
  var box = Hive.box(hiveBoxName);
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 1),
  ));
  @override
  void initState() {
    widget.currentIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                              icon: const Icon(
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

                              return FutureBuilder(
                                future: !data!
                                    ? GetAdsLocaly().getAdsLocaly()
                                    : BlocProvider.of<TeachCubit>(context)
                                        .getAllAds(),
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
                                    if (!data) {
                                      var box = Hive.box(hiveBoxName);
                                      box.put("ads", ads);
                                    }
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
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red,
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
                                                                      const LinearGradient(
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
                                                const Duration(seconds: 10),
                                            autoPlayAnimationDuration:
                                                const Duration(seconds: 2),
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
                              var connection = snapshot.data;
                              {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
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
                                    ),
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                      future: connection!
                                          ? TopCurcesViewRepo()
                                              .getTopViewedCourses()
                                          : GetTopCurces().getData(),
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
                                        }

                                        final topCourses =
                                            snapshot.data![0]["0"];
                                        final names = snapshot.data![0]["1"];

                                        return CarouselSlider.builder(
                                          itemCount: topCourses.length,
                                          options: CarouselOptions(
                                            height: getHeight(context) / 4,
                                            autoPlay: false,
                                            enlargeCenterPage: false,
                                            enableInfiniteScroll: false,
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            if (connection) {
                                              var box = Hive.box(hiveBoxName);
                                              box.put("top10", topCourses);
                                              box.put("topName", names);
                                            }

                                            final course = topCourses[index];

                                            return CourseCard(
                                              course: course,
                                              name: names[index],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: getWidth(context),
                                        height: getWidth(context) * .1,
                                        child: AutoSizeText(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 10,
                                          maxFontSize: 15,
                                          getDeviceLocale() == "ar"
                                              ? "الكورسات المتوفرة"
                                              : "Available courses",
                                          style: TextStyle(
                                              color: mode
                                                  ? Colors.white
                                                  : dayBar["blue2"],
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                    FutureBuilder(
                                      future: connection
                                          ? GetChildFoldersForStudent()
                                              .getChildFoldersForStudent(
                                                  context)
                                          : GetRootFolderFromHive()
                                              .getDataFromHive(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: myImageAsset(
                                                "images/loading.gif", context),
                                          );
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return SizedBox(
                                              width: getWidth(context),
                                              child: const NoDataFound());
                                        } else if (snapshot.hasData) {
                                          List data = snapshot.data!;

                                          return FolderWidgetStudentMainScreen(
                                              copyData: data,
                                              offline: !connection);
                                        } else {
                                          return const NoDataFound();
                                        }
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
        BlocBuilder<OpenPopularCurseLoadingCubit, OpenPopularCurseLoadingState>(
          builder: (context, state) {
            if (state is OpenPopularCurseLoading && state.loading) {
              return Container(
                width: getWidth(context),
                height: getHeight(context),
                color: Colors.black.withValues(alpha: .4),
                child:
                    Center(child: myImageAsset("images/loading.gif", context)),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ],
    );
  }
}
