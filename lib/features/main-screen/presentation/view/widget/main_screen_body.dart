import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:teach/cubit/check_connection/check_connection_cubit.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/refresh_folder/refresh_folder_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/repository/folder_repo.dart';
import 'package:teach/features/main-screen/data/hive_data.dart';
import 'package:teach/features/main-screen/presentation/view/widget/folders.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/show_ads.dart';
import 'package:teach/widgets/clipper.dart';
import 'package:teach/widgets/no_data_found.dart';

// ignore: must_be_immutable
class MainScreenBody extends StatefulWidget {
  var currentIndex = 0;

  MainScreenBody({super.key});

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  var box = Hive.box(hiveBoxName);
  final FolderRepository _repo = FolderRepository(supabase);
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 365),
  ));
  @override
  Widget build(BuildContext context) {
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
                                : "Welcom ${box.get(isMainManager) ? box.get("Mname") : box.get("info")[0]}"),
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

                                return FutureBuilder(
                                  future: !data!
                                      ? HiveData().getAdsLocaly()
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
                                      List ads = [];
                                      if (!data) {
                                        ads = snapshot.data!;
                                      } else {
                                        ads = snapshot.data!;
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
                                                            width: getWidth(
                                                                context),
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
                                                  const Duration(seconds: 10),
                                              autoPlayAnimationDuration:
                                                  const Duration(seconds: 2),
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
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  FutureBuilder(
                      future: checkConnection(),
                      builder: (context, checkConnection) {
                        if (checkConnection.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child:
                                  myImageAsset("images/loading.gif", context));
                        }
                        return FutureBuilder(
                          future: checkConnection.hasData &&
                                  checkConnection.data! == true
                              ? _repo.getRootFolders()
                              : HiveData().getDataFromHive(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: Image.asset("images/loading.gif"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const NoDataFound();
                            } else {
                              List data = snapshot.data!;
                              var copyData = List.from(data);
                              if (checkConnection.hasData &&
                                  checkConnection.data! == true) {
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
                                return Folders(
                                    copyData: copyData, offline: false);
                              } else {
                                return Folders(copyData: data, offline: true);
                              }
                            }
                          },
                        );
                      }),
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
}
