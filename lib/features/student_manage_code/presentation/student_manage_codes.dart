import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/student_manage_code/data/gat_data_localy.dart';
import 'package:teach/features/student_manage_code/repo/get_student_code_repo.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';
import 'package:teach/widgets/no_data_found.dart';

class StudentManageCodes extends StatefulWidget {
  const StudentManageCodes({super.key});

  @override
  State<StudentManageCodes> createState() => _StudentManageCodesState();
}

class _StudentManageCodesState extends State<StudentManageCodes> {
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7),
  ));
  var box = Hive.box(hiveBoxName);
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
          getDeviceLocale() == "ar"
              ? "إدارة الاشتراكات"
              : "Manage Subscriptions",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: FutureBuilder(
          future: checkConnection(),
          builder: (context, connection) {
            if (connection.connectionState == ConnectionState.waiting) {
              return Center(
                child: myImageAsset("images/loading.gif", context),
              );
            }

            var checkConnection = connection.data!;
            return FutureBuilder(
              future: checkConnection ? GetStudentCodeRepo().getStudentCodes() :  GatDataLocaly().getDataLocaly(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: myImageAsset("images/loading.gif", context),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return SizedBox(
                    width: getWidth(context),
                    height: getHeight(context),
                    child: const Center(
                      child: NoDataFound(),
                    ),
                  );
                } else {
                  var data = snapshot.data;
                  if (checkConnection) {
                    box.put("saved", data);
                  }

                  return AnimationLimiter(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      shrinkWrap: true,
                      itemCount: data!.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: const Duration(milliseconds: 500),
                          child: ScaleAnimation(
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.fastLinearToSlowEaseIn,
                            child: FadeInAnimation(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShowFolderDetailes(
                                          folder: data[index]["name"],
                                          parentId: data[index]["id"],
                                          manage: true,
                                        ),
                                      ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: const [
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
                                                  255, 1, 37, 87),
                                              const Color.fromARGB(
                                                  255, 10, 57, 122)
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
                                              height: getWidth(context) * .35,
                                              decoration: BoxDecoration(
                                                color: dayBar["blue3"],
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(
                                                                20)),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(
                                                                20)),
                                                child: data[index]
                                                                ["image_url"] ==
                                                            null ||
                                                        data[index]["image_url"]
                                                            .isEmpty
                                                    ? Image.asset(
                                                        "images/icon.jpg",
                                                        fit: BoxFit.contain,
                                                      )
                                                    : CachedNetworkImage(
                                                        cacheManager:
                                                            customCachManager,
                                                        imageUrl:
                                                            '${data[index]["image_url"]}',
                                                        cacheKey:
                                                            '${data[index]["id"]}_${data[index]["image_url"]}',
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        fit: BoxFit.cover,
                                                        errorWidget: (context,
                                                                url, error) =>
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
                                                              color:
                                                                  Colors.white,
                                                            ))),
                                              )),
                                        ]),
                                        ListTile(
                                          leading: SizedBox(
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
                                            data[index]["name"],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    getWidth(context) * .05,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                          ),
                                          subtitle: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
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
                                                      Icons.folder,
                                                      color: Colors.white,
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      minFontSize: 10,
                                                      maxFontSize: 15,
                                                      data[index]
                                                          ["child_count"],
                                                      style: const TextStyle(
                                                          color: Colors.white),
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
                              ),
                            )),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }),
    );
  }


 
}
