import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';

class CourseCard extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () async {
          var data = await supabase
              .from("folders")
              .select()
              .eq("id", course["folder_id"]);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowFolderDetailes(
                    folder: data[0]["name"], parentId: course["folder_id"]),
              ));
        },
        child: Container(
          width: getWidth(context),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
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
                          Text(
                            course['name'] ?? 'بدون عنوان',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(width: 4),
                          Row(
                            children: [
                              Text(
                                '${course['viewers_count']}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 1,
                              ),
                              Icon(
                                Icons.remove_red_eye,
                                color: Colors.white,
                              ),
                            ],
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
