import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/cubit/loading_pdf/loading_pdf_cubit.dart';
import 'package:teach/cubit/lunch_loading_cubit/lunch_loading_cubit.dart';
import 'package:teach/cubit/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/phone_number/phone_number_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';
import 'package:teach/main.dart';

class AddPhoneNumber extends StatefulWidget {
  @override
  State<AddPhoneNumber> createState() => _AddPhoneNumberState();
}

class _AddPhoneNumberState extends State<AddPhoneNumber> {
  String? selectedCategory;
  var nameController = TextEditingController();

  var phoneController = TextEditingController();
  GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mode ? nightBar["orange"] : dayBar["blue3"],
      child: WillPopScope(
        onWillPop: () {
          context.read<ManagerScreenCubit>().changeIndex(0);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: getWidth(context) * .4,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(getWidth(context) * .05),
                      child: SizedBox(
                          width: getWidth(context) * .15,
                          height: getWidth(context) * .15,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                "images/add_phone.png",
                                width: getWidth(context),
                                fit: BoxFit.cover,
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Center(
                          child: AutoSizeText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            minFontSize: 10,
                            maxFontSize: 15,
                            getDeviceLocale() == "ar"
                                ? "إنشاء نقطة بيع"
                                : "Create new sell point",
                            style: TextStyle(
                                fontSize: getWidth(context) * .05,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: getHeight(context) - (getWidth(context) * .4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: mode ? Colors.black : Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: true,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        cursorColor: dayBar["blue"],
                        autocorrect: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: 1, color: dayBar["blue"])),
                          hintText: getDeviceLocale() == "ar"
                              ? "اكتب الاسم الكامل هنا ..."
                              : "Write full name here...",
                          prefixIcon: Icon(
                            Icons.person,
                            color: dayBar["blue2"],
                          ),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: dayBar["blue"],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: .5, color: dayBar["blue"])),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(width: 1, color: dayBar["blue"])),
                          hintText: getDeviceLocale() == "ar"
                              ? "اكتب الرقم هنا ..."
                              : "Write the number here...",
                          hintStyle: TextStyle(),
                          prefixIcon: Icon(
                            Icons.person,
                            color: dayBar["blue2"],
                          ),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      ),
                    ),
                    BlocBuilder<LoadingPdfCubit, LoadingPdfState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () async {
                              try {
                                if (nameController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty) {
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(true);

                              
                                   
                                      await supabase.from("sell_point").insert({
                                        "name": nameController.text.trim(),
                                        "phone": phoneController.text.trim()
                                      });
                                      context
                                          .read<LoadingPdfCubit>()
                                          .loadingPdf(false);
                                   
                                
                                  context
                                      .read<LoadingPdfCubit>()
                                      .loadingPdf(false);
                                  lunchAwesomDialoge(
                                      DialogType.success,
                                      "s",
                                      getDeviceLocale() == "ar"
                                          ? "تمّت العملية بنجاح"
                                          : "The operation was successful.",
                                      context,
                                      getWidth(context),
                                      getHeight(context));
                                }
                              } catch (e) {
                                lunchAwesomDialoge(
                                    DialogType.warning,
                                    "e",
                                    getDeviceLocale() == "ar"
                                        ? "يوجد خطأ ما!"
                                        : "Something went wrong!",
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              }
                            },
                            child: state is LoadingPdf && state.loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar" ? "حفظ" : "Save",
                                    style: TextStyle(color: Colors.white),
                                  ));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
