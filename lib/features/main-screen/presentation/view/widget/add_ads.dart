import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teach/features/main-screen/presentation/view/manager/add_ad_loading/add_ad_loading_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/managerScreen/manager_screen_cubit.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

import 'package:teach/data/widgets/lunch.dart';

import 'package:teach/widgets/loading_upload.dart';

// ignore: must_be_immutable
class AddAds extends StatefulWidget {
  var selectedImage = "";
  XFile imageFile = XFile("images/icon.jpg");
  var title = "";
  var text = "";
  var once = false;
  String? selectedValue;
  String? selectedGrade;
  Object? selectedCollage;
  String? previusGrade;
  String? previusCollage;
  // ignore: prefer_typing_uninitialized_variables
  late var id;

  AddAds({super.key});
  @override
  State<AddAds> createState() => _AddAdsState();
}

class _AddAdsState extends State<AddAds> {
  var loading = false;
  // ignore: prefer_typing_uninitialized_variables
  var id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? nightBar["orange"] : dayBar["blue3"],
      extendBodyBehindAppBar: true,
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () {
          context.read<ManagerScreenCubit>().changeIndex(0);
          return Future.delayed(Duration.zero);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
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
                                "images/add_ads.png",
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
                                ? "إنشاء إعلان جديد"
                                : "Create new ad",
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
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: mode ? Colors.black : Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          var pickedImage = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            widget.selectedImage = pickedImage!.path;
                            widget.imageFile = pickedImage;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: getWidth(context),
                          height: getHeight(context) / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: mode ? nightBar["buttons"] : dayBar["blue3"],
                          ),
                          child: Center(
                            child: widget.selectedImage == ""
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                      AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "اضغط لاختيار صورة للإعلان"
                                            : "Click to select an image for the ad",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      )
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      width: getWidth(context),
                                      File(widget.selectedImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: getWidth(context),
                        child: AutoSizeText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 10,
                          maxFontSize: 15,
                          getDeviceLocale() == "ar"
                              ? "اختر الفئة المتبوع لها : "
                              : "Choose the category to follow : ",
                          style: TextStyle(
                              color: mode ? Colors.white : dayBar["blue2"]),
                        ),
                      ),
                    ),
                    FutureBuilder(
                        future: getTruthSubject(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: mode ? Colors.white : dayBar["blue2"],
                              ),
                            );
                          } else {
                            var data = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2(
                                  isExpanded: true,
                                  buttonStyleData: ButtonStyleData(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 1,
                                            color: mode
                                                ? Colors.white
                                                : dayBar["blue2"],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(20))),
                                  hint: AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar"
                                        ? widget.selectedValue == "جامعي" ||
                                                widget.selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "اختر نوع الجامعة"
                                            : "اختر الدرجة العلمية : "
                                        : widget.selectedValue == "جامعي" ||
                                                widget.selectedValue ==
                                                    itemsInEnglish[3]
                                            ? "Choose the type of university"
                                            : "Choose the academic degree : ",
                                  ),
                                  items: getDeviceLocale() == "ar"
                                      ? (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                value: value,
                                                child: AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    value),
                                              ))
                                          .toList()
                                      : (data)!
                                          .map((String value) =>
                                              DropdownMenuItem(
                                                value: value,
                                                child: AutoSizeText(
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 10,
                                                    maxFontSize: 15,
                                                    value),
                                              ))
                                          .toList(),
                                  value: widget.selectedGrade != null
                                      ? widget.previusGrade !=
                                              widget.selectedValue
                                          ? data[0]
                                          : widget.selectedGrade
                                      : widget.selectedGrade,
                                  onChanged: (value) {
                                    setState(() {
                                      widget.selectedGrade = value;
                                      widget.previusGrade =
                                          widget.selectedValue;

                                      id = universety.where(
                                        (element) => element.name == value,
                                      );
                                    });
                                  },
                                  dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                    color: mode
                                        ? nightBar["orange"]
                                        : Colors.white,
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(20)),
                                  )),
                                ),
                              ),
                            );
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BlocConsumer<TeachCubit, TeachState>(
                        listener: (context, state) async {
                          if (state is Percentage && !widget.once) {
                            widget.once = true;
                            await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => const LoadingUpload());
                          }
                        },
                        builder: (context, state) {
                          return BlocBuilder<AddAdLoadingCubit,
                              AddAdLoadingState>(
                            builder: (context, state) {
                              return ElevatedButton(
                                onPressed: () async {
                               
                                    if (widget.imageFile.path.isEmpty ||
                                        widget.selectedImage.isEmpty ||
                                        widget.selectedImage == "" ||
                                        widget.selectedGrade == null) {
                                      lunchAwesomDialoge(
                                          DialogType.error,
                                          "e",
                                          getDeviceLocale() == "ar"
                                              ? "يرجى تعبئة جميع الحقول"
                                              : "Please fill in all fields.",
                                          context,
                                          getWidth(context),
                                          getHeight(context));
                                    } else {
                                      try {
                                        context
                                            .read<AddAdLoadingCubit>()
                                            .addAdLoading(true);
                                        await BlocProvider.of<
                                                AddAdLoadingCubit>(context)
                                            .createAd(
                                                File(widget.imageFile.path),
                                                widget.selectedGrade
                                                    .toString());
                                        // ignore: use_build_context_synchronously
                                        context
                                            .read<AddAdLoadingCubit>()
                                            .addAdLoading(false);
                                        lunchAwesomDialoge(
                                            DialogType.success,
                                            "s",
                                            getDeviceLocale() == "ar"
                                                ? "تمّت العملية بنجاح"
                                                : "The operation was successful.",
                                            // ignore: use_build_context_synchronously
                                            context,
                                            // ignore: use_build_context_synchronously
                                            getWidth(context),
                                            // ignore: use_build_context_synchronously
                                            getHeight(context));
                                      } catch (e) {
                                         // ignore: use_build_context_synchronously
                                        context
                                            .read<AddAdLoadingCubit>()
                                            .addAdLoading(false);
                                        lunchAwesomDialoge(
                                            DialogType.error,
                                            "",
                                            e.toString(),
                                            // ignore: use_build_context_synchronously
                                            context,
                                            // ignore: use_build_context_synchronously
                                            getWidth(context),
                                            // ignore: use_build_context_synchronously
                                            getHeight(context));
                                      }
                                    }
                                  
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: mode
                                        ? nightBar["buttons"]
                                        : dayBar["blue3"]),
                                child: state is AddAdLoading && state.loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : AutoSizeText(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        minFontSize: 10,
                                        maxFontSize: 15,
                                        getDeviceLocale() == "ar"
                                            ? "نشر"
                                            : "Publish",
                                        style: const TextStyle(color: Colors.white),
                                      ),
                              );
                            },
                          );
                        },
                      ),
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
