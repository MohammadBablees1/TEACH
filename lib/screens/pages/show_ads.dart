import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:teach/cubit/clauserCubit/clauser_index_cubit.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/consts/sql_const.dart';
import 'package:teach/data/sql/sql.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/screens/main_screen.dart';
import 'package:teach/screens/pages/editable_ad_screen.dart';

class ShowAds extends StatefulWidget {
  var ads;
  var loading = false;
  var index = 0;
  ShowAds({required this.ads, required this.index});
  PageController pageController = PageController();

  @override
  State<ShowAds> createState() => _ShowAdsState();
}

class _ShowAdsState extends State<ShowAds> {
  var customCachManager = CacheManager(Config(
    "customCacheKey",
    stalePeriod: Duration(days: 7),
  ));
  @override
  void initState() {
    //  widget.pageController.animateToPage(widget.pageController.initialPage,
    //                           duration: Duration(milliseconds: 300),
    //                           curve: Curves.easeInOut);

    super.initState();
  }

  var box = Hive.box(hiveBoxName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(.3),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              if (!widget.loading) {
                Navigator.pop(context);
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
        actions: [
          checkPermision(true, false, false, false, false, false)
              ? IconButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EditableAdScreen(ad: widget.ads[widget.index]),
                      ));
                    } else {
                      lunchAwesomDialoge(
                          DialogType.warning,
                          "w",
                          getDeviceLocale() == "ar"
                              ? "يرجى الاتصال بالإنترنت"
                              : "Please connect to the Internet",
                          context,
                          getWidth(context),
                          getHeight(context));
                    }
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ))
              : Container(),
          checkPermision(false, true, false, false, false,false)
              ? IconButton(
                  onPressed: () async {
                    if (await checkConnection()) {
                      // change it ... and check collage...
                      showDialog(
                        context: context,
                        builder: (context) =>
                            BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                          builder: (context, state) {
                            return AlertDialog(
                              content: Container(
                                width: getWidth(context) * .3,
                                height: getWidth(context) * .3,
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
                                            ? "هل أنت متأكّد من الحذف؟"
                                            : "Are you sure you want to delete?"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              context
                                                  .read<LoadingPdfCubit>()
                                                  .loadingPdf(true);
                                              await BlocProvider.of<TeachCubit>(
                                                      context)
                                                  .deleteAd(
                                                      widget.ads[widget.index]);
                                              context
                                                  .read<LoadingPdfCubit>()
                                                  .loadingPdf(false);
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BlocProvider(
                                                          create: (context) =>
                                                              ClauserIndexCubit(),
                                                          child: MainScreen(),
                                                        ),
                                                      ),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            },
                                            child: state is LoadingPdf &&
                                                    state.loading
                                                ? CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    getDeviceLocale() == "ar"
                                                        ? "نعم"
                                                        : "Yes",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )),
                                        ElevatedButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: AutoSizeText(
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 10,
                                              maxFontSize: 15,
                                              getDeviceLocale() == "ar"
                                                  ? "لا"
                                                  : "No",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      lunchAwesomDialoge(
                          DialogType.warning,
                          "w",
                          getDeviceLocale() == "ar"
                              ? "يرجى الاتصال بالإنترنت"
                              : "Please connect to the Internet",
                          context,
                          getWidth(context),
                          getHeight(context));
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ))
              : Container()
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          if (!widget.loading) {
            Navigator.pop(context);
          }
          return Future.delayed(Duration.zero);
        },
        child: PageView.builder(
            onPageChanged: (position) {
              widget.index = position;
            },
            controller: PageController(initialPage: widget.index),
            itemCount: widget.ads.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    width: getWidth(context),
                    height: getHeight(context),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.3)
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 50]),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                            cacheManager: customCachManager,
                            imageUrl: '${widget.ads[index]["imageUrl"]}',
                            cacheKey:
                                '${widget.ads[index]["id"]}_${widget.ads[index]["updated_at"]}',
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 40,
                                ),
                            placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  color: mode ? Colors.white : dayBar["blue"],
                                ))),
                        Opacity(
                          opacity: .9,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.3)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0, 50]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
