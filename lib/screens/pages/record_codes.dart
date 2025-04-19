import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:teach/cubit/animatedContainerTow/animated_container_tow_cubit.dart';
import 'package:teach/cubit/search/search_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/main.dart';
import 'package:teach/screens/pages/cate_details.dart';
import 'package:teach/screens/pages/codes.dart';
import 'package:teach/widgets/no_data_found.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RecordCodes extends StatefulWidget {
  var searchText = "";
  var manager = true, codes = false;
  @override
  State<RecordCodes> createState() => _RecordCodesState();
}

class _RecordCodesState extends State<RecordCodes> {
  var manager = true, codes = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      bottomNavigationBar: bottomNavBar(context),
      body: BlocBuilder<AnimatedContainerTowCubit, AnimatedContainerTowState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  FutureBuilder(
                      future: checkConnection(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Image.asset("images/loading.gif"));
                        } else if (snapshot.hasData && snapshot.data == true) {
                          return FutureBuilder(
                            future: Future.wait([
                              getManagers(),
                              getCourseNames(),
                              getSoldCode()
                            ]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Container(
                                      width: getWidth(context),
                                      height: getHeight(context) / 2,
                                      child: Image.asset("images/loading.gif")),
                                );
                              } else if ((snapshot.data![0].isEmpty &&
                                      widget.manager) ||
                                  snapshot.data![1].isEmpty && widget.codes) {
                                return Container(
                                    width: getWidth(context),
                                    height: getHeight(context) / 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        NoDataFound(),
                                      ],
                                    ));
                              } else {
                                List data = snapshot.data![1];
                                List managers = snapshot.data![0];
                                List sold = snapshot.data![2];
                                var selectedData = [];
                                if (widget.searchText != "") {
                                  for (var code in data) {
                                    if (code
                                        .toString()
                                        .contains(widget.searchText)) {
                                      selectedData.add(code);
                                    }
                                  }
                                }
                                return code_card(context, state, managers,
                                    selectedData, data, sold);
                              }
                            },
                          );
                        } else {
                          return Container(
                              width: getWidth(context),
                              height: getHeight(context),
                              child: connection_widget(getWidth(context),
                                  getHeight(context), context));
                        }
                      })
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Container code_card(
      BuildContext context,
      AnimatedContainerTowState state,
      List<dynamic> managers,
      List<dynamic> selectedData,
      List<dynamic> data,
      sold) {
   
    print("+++++++++++++++++");
    return Container(
      width: getWidth(context),
      height: getHeight(context) / 1.266,
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: state is ChangeAnimation
            ? state.manager
                ? managers.length
                : widget.searchText != ""
                    ? selectedData.length
                    : data.length
            : managers.length,
        itemBuilder: (context, index) => Card(
          color: mode ? nightBar["orange"] : dayBar["blue2"],
          child: ListTile(
            onTap: () {
              if ((state is ChangeAnimation && state.codes)) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Codes(
                    name: data[index],
                  ),
                ));
              }
            },
            leading: CircleAvatar(
                backgroundColor: mode ? nightBar["buttons"] : dayBar["blue"],
                child: Icon(
                  state is ChangeAnimation
                      ? state.manager
                          ? Icons.manage_accounts
                          : Icons.code
                      : Icons.manage_accounts,
                  color: Colors.white,
                )),
            title: Text(
              state is ChangeAnimation
                  ? state.manager
                      ? managers[index]["name"]
                      : widget.searchText != ""
                          ? selectedData[index]
                          : data[index]
                  : managers[index]["name"],
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              widget.manager
                  ? ""
                  : sold.isNotEmpty
                      ? sold[index]["count"]
                      : "0",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: state is ChangeAnimation
                ? state.manager
                    ? TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Container(
                                height: getHeight(context) / 2.61,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    PrettyQrView.data(
                                      data: managers[index]["code"],
                                      decoration: const PrettyQrDecoration(
                                        background: Colors.white,
                                        // image:
                                        //     PrettyQrDecorationImage(
                                        //   matchTextDirection: true,
                                        //   image: AssetImage(
                                        //     'images/qr_icon.png',
                                        //   ),
                                        // ),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          final qrCode = QrCode.fromData(
                                            data: managers[index]["code"],
                                            errorCorrectLevel:
                                                QrErrorCorrectLevel.M,
                                          );

                                          final qrImage = QrImage(qrCode);
                                          final qrImageData =
                                              await qrImage.toImageAsBytes(
                                            size: 512,
                                            format: ImageByteFormat.png,
                                            decoration:
                                                const PrettyQrDecoration(
                                              shape: PrettyQrSmoothSymbol(),
                                              background: Colors.white,
                                              //   image:
                                              //       PrettyQrDecorationImage(
                                              //     image: AssetImage(
                                              //         'images/icon.jpg'),
                                              //   ),
                                              // ),
                                            ),
                                          );
                                          if (qrImageData == null) {
                                            throw Exception(
                                                'Failed to generate QR code bytes.');
                                          }
                                          final Uint8List qrImageBytes =
                                              qrImageData.buffer.asUint8List();
                                          final tempDir =
                                              await getTemporaryDirectory();
                                          final tempFile = File(
                                              '${tempDir.path}/qr_image.png');
                                          await tempFile
                                              .writeAsBytes(qrImageBytes);

                                          final result =
                                              await Share.shareXFiles(
                                                  [XFile(tempFile.path)]);
                                        },
                                        icon: Icon(
                                          Icons.share,
                                          color: dayBar["blue2"],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          state is ChangeAnimation
                              ? state.manager
                                  ? managers[index]["code"]
                                  : widget.searchText != ""
                                      ? selectedData[index].id
                                      : data[index]
                              : managers[index]["code"],
                          style: TextStyle(color: Colors.white),
                        ))
                    : Container()
                : TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Container(
                            height: getHeight(context) / 2.61,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PrettyQrView.data(
                                  data: state is ChangeAnimation
                                      ? state.manager
                                          ? managers[index]["code"]
                                          : ""
                                      : managers[index]["code"],
                                  decoration: const PrettyQrDecoration(
                                    background: Colors.white,
                                    // image:
                                    //     PrettyQrDecorationImage(
                                    //   matchTextDirection: true,
                                    //   image: AssetImage(
                                    //     'images/qr_icon.png',
                                    //   ),
                                    // ),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () async {
                                      final qrCode = QrCode.fromData(
                                        data: state is ChangeAnimation
                                            ? state.manager
                                                ? managers[index]["code"]
                                                : ""
                                            : managers[index]["code"],
                                        errorCorrectLevel:
                                            QrErrorCorrectLevel.M,
                                      );

                                      final qrImage = QrImage(qrCode);

                                      final qrImageData =
                                          await qrImage.toImageAsBytes(
                                        size: 512,
                                        format: ImageByteFormat.png,
                                        decoration: const PrettyQrDecoration(
                                          shape: PrettyQrSmoothSymbol(),
                                          background: Colors.white,
                                          //   image:
                                          //       PrettyQrDecorationImage(
                                          //     image: AssetImage(
                                          //         'images/icon.jpg'),
                                          //   ),
                                          // ),
                                        ),
                                      );

                                      if (qrImageData == null) {
                                        throw Exception(
                                            'Failed to generate QR code bytes.');
                                      }
                                      final Uint8List qrImageBytes =
                                          qrImageData.buffer.asUint8List();
                                      final tempDir =
                                          await getTemporaryDirectory();
                                      final tempFile =
                                          File('${tempDir.path}/qr_image.png');
                                      await tempFile.writeAsBytes(qrImageBytes);

                                      final result = await Share.shareXFiles(
                                          [XFile(tempFile.path)]);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      color: dayBar["blue2"],
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      state is ChangeAnimation
                          ? state.manager
                              ? managers[index]["code"]
                              : widget.searchText != ""
                                  ? selectedData[index].id
                                  : data[index]
                          : managers[index]["code"],
                      style: TextStyle(color: Colors.white),
                    )),
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30))),
      centerTitle: true,
      title: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state is IsSearch
              ? state.isSearch
                  ? swichEditText(context)
                  : Text(
                      getDeviceLocale() == "ar"
                          ? "سجل الأكواد"
                          : "Record codes",
                    )
              : Text(
                  getDeviceLocale() == "ar" ? "سجل الأكواد" : "Record codes",
                );
        },
      ),
      leading: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state is IsSearch
              ? state.isSearch
                  ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        context.read<SearchCubit>().changeSearch(false, "");
                        widget.searchText = "";
                      },
                    )
                  : IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                      ))
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                  ));
        },
      ),
      actions: [
        BlocBuilder<AnimatedContainerTowCubit, AnimatedContainerTowState>(
          builder: (context, state) {
            return state is ChangeAnimation
                ? state.codes
                    ? IconButton(
                        onPressed: () {
                          context.read<SearchCubit>().changeSearch(true, "");
                        },
                        icon: Icon(
                          Icons.search,
                        ),
                      )
                    : Container()
                : Container();
          },
        ),
      ],
    );
  }

  Widget bottomNavBar(BuildContext context) {
    return BottomAppBar(
      height: getHeight(context) / 15,
      child: Container(
        height: getHeight(context) / 20,
        width: getWidth(context),
        child:
            BlocBuilder<AnimatedContainerTowCubit, AnimatedContainerTowState>(
          builder: (context, state) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      widget.manager = true;
                      widget.codes = false;
                      context
                          .read<AnimatedContainerTowCubit>()
                          .chnageAnimation(widget.manager, widget.codes);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: getWidth(context) / 4,
                          child: Center(
                            child: AnimatedContainer(
                              curve: Curves.fastLinearToSlowEaseIn,
                              width: state is ChangeAnimation
                                  ? state.manager
                                      ? getWidth(context) / 4
                                      : 0
                                  : getWidth(context) / 4,
                              duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(.3)),
                            ),
                          ),
                        ),
                        Container(
                          width: getWidth(context) / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.manage_accounts_outlined,
                                color: Colors.white,
                              ),
                              Text(
                                getDeviceLocale() == "ar"
                                    ? "المدراء"
                                    : "Managers",
                                style: TextStyle(
                                    fontWeight: state is ChangeAnimation
                                        ? state.manager
                                            ? FontWeight.bold
                                            : FontWeight.w100
                                        : FontWeight.bold,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      widget.manager = false;
                      widget.codes = true;
                      context
                          .read<AnimatedContainerTowCubit>()
                          .chnageAnimation(widget.manager, widget.codes);
                    },
                    splashColor: Colors.transparent,
                    highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                    child: Stack(
                      children: [
                        SizedBox(
                            width: getWidth(context) / 4,
                            child: Center(
                              child: AnimatedContainer(
                                curve: Curves.fastLinearToSlowEaseIn,
                                width: state is ChangeAnimation
                                    ? state.codes
                                        ? getWidth(context) / 4
                                        : 0
                                    : 0,
                                duration: Duration(seconds: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white.withOpacity(.3)),
                              ),
                            )),
                        Container(
                          width: getWidth(context) / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.code,
                                color: Colors.white,
                              ),
                              Text(
                                getDeviceLocale() == "ar"
                                    ? "الكورسات"
                                    : "Courses",
                                style: TextStyle(
                                    fontWeight: state is ChangeAnimation
                                        ? state.codes
                                            ? FontWeight.bold
                                            : FontWeight.w100
                                        : FontWeight.w100,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  swichEditText(BuildContext context) {
    return TextField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      onChanged: (value) {
        context.read<SearchCubit>().changeSearch(true, value);
        setState(() {
          widget.searchText = value;
        });
      },
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 0, color: Colors.transparent)),
          hintText: getDeviceLocale() == "ar"
              ? "اكتب للبحث هنا..."
              : "Type to search",
          hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
    );
  }

  Future<List<String>> getCourseNames() async {
    var data = await supabase.from("codes").select();

    // Extract the document IDs (course names)
    var names = data.map((doc) => doc['name'] as String).toSet().toList();

    return names;
  }

  Future<List<Map<String, dynamic>>> getManagers() async {
    var data = await supabase.from("manager").select();

    // Extract the document IDs (course names)

    return data;
  }

  // Future<List<String>> getCodesForCourse(String courseName) async {
  //   var firestore = FirebaseFirestore.instance;
  //   var snapshot = await firestore
  //       .collection('codes')
  //       .doc(courseName)
  //       .collection('un_used')
  //       .get();

  //   // Extract codes from document IDs
  //   return snapshot.docs.map((doc) => doc.id).toList();
  // }
}
