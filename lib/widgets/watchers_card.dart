import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';

class CourseCard extends StatelessWidget {
  final Map<dynamic, dynamic> course;
  String name;
  CourseCard({Key? key, required this.course, required this.name})
      : super(key: key);
  static final customCachManager = CacheManager(Config(
    'customCacheKey',
    stalePeriod: Duration(days: 7),
  ));
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          if (await checkConnection()) {
            var data = await supabase
                .from("folders")
                .select()
                .eq("id", course["folder_id"]);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowFolderDetailes(
                    folder: data[0]["name"],
                    parentId: course["folder_id"],
                    manage: false,
                  ),
                ));
          } else {
            lunchAwesomDialoge(
                DialogType.warning,
                "w",
                getDeviceLocale() == "ar"
                    ? "تأكد من اتصالك بالإنترنت"
                    : "Make sure you are connected to the Internet.",
                context,
                getWidth(context),
                getHeight(context));
          }
        },
        child: Container(
          width: getWidth(context),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: course["image_url"] != null &&
                        course["image_url"].toString().isNotEmpty &&
                        course["image_url"].toString() != "null"
                    ? CachedNetworkImage(
                        cacheManager: customCachManager,
                        imageUrl: '${course["image_url"]}',
                        cacheKey: '${course["image_url"]}_${course["id"]}',
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
                            )))
                    : Image.asset(
                        "images/icon.jpg",
                        width: getWidth(context),
                        fit: BoxFit.cover,
                      ),
              ),
              Opacity(
                  opacity: .4,
                  child: Container(
                    width: getWidth(context),
                    height: getHeight(context),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15)),
                  )),
              Container(
                width: getWidth(context),
                height: getHeight(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
