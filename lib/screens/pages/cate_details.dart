import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/screens/pages/codes.dart';
import 'package:teach/widgets/no_data_found.dart';

class CateDetails extends StatefulWidget {
  CateDetails({required this.cate});
  String cate = "";
  @override
  State<CateDetails> createState() => _CateDetailsState();
}

class _CateDetailsState extends State<CateDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            FutureBuilder(
              future: getCourseNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(
                        width: getWidth(context),
                        height: getHeight(context) / 2,
                        child: Image.asset("images/loading.gif")),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                      width: getWidth(context),
                      height: getHeight(context) / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NoDataFound(),
                        ],
                      ));
                } else {
                  var data = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: mode ? nightBar["orange"] : dayBar["blue2"],
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Codes(
                                name: data[index] as String,
                              ),
                            ));
                          },
                         
                          leading: CircleAvatar(
                              backgroundColor:
                                  mode ? nightBar["buttons"] : dayBar["blue"],
                              child: Icon(
                                Icons.code,
                                color: Colors.white,
                              )),
                          title: Text(
                            data[index].toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )
          ],
        )),
      ),
    );
  }

  Future<List<String?>> getCourseNames() async {
    var firestore = FirebaseFirestore.instance;
    var snapshot = await firestore.collection('un_used_codes').get();

    // Extract the document IDs (course names)
    var names = snapshot.docs
        .map((doc) {
          return doc.data()["name"] as String;
        })
        .toSet()
        .toList();

    return names;
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      centerTitle: true,
      title: Text(
        getDeviceLocale() == "ar" ? "سجل الأكواد" : "Record codes",
      ),
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
          )),
    );
  }
}
