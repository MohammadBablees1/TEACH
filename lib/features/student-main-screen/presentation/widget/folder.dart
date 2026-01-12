import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';

class FolderWidgetStudentMainScreen extends StatefulWidget {
  final List<dynamic> copyData;

  final bool offline;
  const FolderWidgetStudentMainScreen(
      {super.key, required this.copyData, required this.offline});

  @override
  State<FolderWidgetStudentMainScreen> createState() =>
      _FolderWidgetStudentMainScreenState();
}

class _FolderWidgetStudentMainScreenState
    extends State<FolderWidgetStudentMainScreen> {
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: const Duration(days: 7),
  ));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        children: [
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.copyData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowFolderDetailes(
                              folder: widget.offline
                                  ? widget.copyData[index]["name"]
                                  : widget.copyData[index].name,
                              parentId: widget.offline
                                  ? ""
                                  : widget.copyData[index].id,
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
                                  const Color.fromARGB(255, 10, 57, 122)
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
                              color: dayBar["blue3"],
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                child: widget.offline
                                    ? widget.copyData[index]["image_url"] ==
                                                null ||
                                            widget.copyData[index]["image_url"]
                                                .isEmpty
                                        ? Image.asset(
                                            "images/icon.jpg",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.contain,
                                          )
                                        : CachedNetworkImage(
                                            cacheManager: customCachManager,
                                            imageUrl:
                                                '${widget.copyData[index]["image_url"]}',
                                            cacheKey:
                                                '${widget.copyData[index]["id"]}_${widget.copyData[index]["image_url"]}',
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
                                    : widget.copyData[index].imageUrl == null ||
                                            widget.copyData[index].imageUrl
                                                .isEmpty
                                        ? Image.asset(
                                            "images/icon.jpg",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.contain,
                                          )
                                        : CachedNetworkImage(
                                            cacheManager: customCachManager,
                                            imageUrl:
                                                '${widget.copyData[index].imageUrl}',
                                            cacheKey:
                                                '${widget.copyData[index].id}_${widget.copyData[index].imageUrl}',
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
                              widget.offline
                                  ? widget.copyData[index]["name"]
                                  : widget.copyData[index].name,
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
                                      const Icon(
                                        Icons.folder,
                                        color: Colors.white,
                                      ),
                                      AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        widget.offline
                                            ? widget.copyData[index]
                                                ["child_count"]
                                            : widget.copyData[index].childCount,
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
                );
              }),
        ],
      ),
    );
  }
}
