import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/show_folder_detailes.dart';
import 'package:teach/widgets/no_data_found.dart';

class StudentManageCodes extends StatefulWidget {
  const StudentManageCodes({super.key});

  @override
  State<StudentManageCodes> createState() => _StudentManageCodesState();
}

class _StudentManageCodesState extends State<StudentManageCodes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30))),
        centerTitle: true,
        title: Text(
          getDeviceLocale() == "ar"
              ? "إدارة الاشتراكات"
              : "Manage Subscriptions",
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
            )),
      ),
      body: FutureBuilder(
        future: getStudentCodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset("images/loading.gif"),
            );
          } else if (!snapshot.hasData) {
            return Container(
              width: getWidth(context),
              height: getHeight(context),
              child: Center(
                child: NoDataFound(),
              ),
            );
          } else {
            var data = snapshot.data;
            return AnimationLimiter(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 1.5,
                ),
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    columnCount: 2,
                    duration: const Duration(milliseconds: 500),
                    child: ScaleAnimation(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.fastLinearToSlowEaseIn,
                      child: FadeInAnimation(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShowFolderDetailes(
                                    folder: data[index]["name"],
                                    parentId: data[index]["id"],
                                  ),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
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
                                        const Color.fromARGB(255, 11, 85, 145),
                                        const Color.fromARGB(255, 4, 96, 172)
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
                                      height: getHeight(context) / 10,
                                      decoration: BoxDecoration(
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
                                          color: mode
                                              ? Colors.grey.withOpacity(.4)
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        "images/book.png",
                                        width: getWidth(context),
                                        height: getHeight(context) / 12,
                                      ),
                                    ),
                                  ]),
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      data[index]["name"],
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
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
      ),
    );
  }

  Future<List> getStudentCodes() async {
    try {
      var userId = supabase.auth.currentUser!.id;
      var data = await supabase.from("current_user").select().eq("id", userId);

      if (data[0]["codes"].isEmpty) {
        return [];
      } else {
        List info = [];

        for (var i = 0; i < data[0]["codes"].length; i++) {
          var d = await supabase
              .from("folders")
              .select()
              .eq("id", data[0]["codes"][i]);

          info.add(d[0]);
        }
        print(info);
        return info;
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
