import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/features/main-screen/presentation/view/widget/show_deleting_dialoge.dart';
import 'package:teach/features/main-screen/presentation/view/widget/show_edite_dialoge.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';

class Folders extends StatelessWidget {
  final List<dynamic> copyData;
  final bool offline;

  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 365),
  ));
  const Folders({super.key, required this.copyData, required this.offline});
  @override
  Widget build(BuildContext context) {
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
                                ? const BoxShadow()
                                : const BoxShadow(
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
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                              ),
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
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
                                offline
                                    ? copyData[index]["name"]
                                    : copyData[index].name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: getWidth(context) * .05,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              trailing: const Icon(
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
                                        const Icon(
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
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  checkPermision(true, false, false, false,
                                          false, false)
                                      ? GestureDetector(
                                          onTap: () async {
                                            if (await checkConnection()) {
                                              await showDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (context) =>
                                                    ShowEditeDialoge(
                                                        id: copyData[index].id),
                                              );
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
                                              await showDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (context) =>
                                                    ShowDeletingDialoge(
                                                        id: copyData[index].id),
                                              );
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
}