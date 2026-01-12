import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teach/features/main-screen/presentation/view/manager/add_phone_number_loading/add_phone_number_cubit.dart';
import 'package:teach/features/main-screen/presentation/view/manager/managerScreen/manager_screen_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';
import 'package:teach/data/widgets/lunch.dart';


class AddPhoneNumber extends StatefulWidget {
  const AddPhoneNumber({super.key});

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
      // ignore: deprecated_member_use
      child: WillPopScope(
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
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: mode ? Colors.black : Colors.white),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        autofocus: false,
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
                          prefixIcon: Icon(
                            Icons.person,
                            color: dayBar["blue2"],
                          ),
                        ),
                        style: TextStyle(color: dayBar["blue"]),
                      ),
                    ),
                    BlocBuilder<AddPhoneNumberCubit, AddPhoneNumberState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () async {
                              try {
                                if (nameController.text.isNotEmpty &&
                                    phoneController.text.isNotEmpty) {
                                  context
                                      .read<AddPhoneNumberCubit>()
                                      .addPhoneNumberLoading(true);

                                  context
                                      .read<AddPhoneNumberCubit>()
                                      .addSellPoint(
                                          nameController, phoneController);

                                  // ignore: use_build_context_synchronously
                                  context
                                      .read<AddPhoneNumberCubit>()
                                      .addPhoneNumberLoading(false);

                                 
                                  lunchAwesomDialoge(
                                      DialogType.success,
                                      "s",
                                      getDeviceLocale() == "ar"
                                          ? "تمّت العملية بنجاح"
                                          : "The operation was successful.",
                                      // ignore: use_build_context_synchronously
                                      context,
                                      getWidth(context),
                                      getHeight(context));
                                }
                              } catch (e) {
                                context
                                    .read<AddPhoneNumberCubit>()
                                    .addPhoneNumberLoading(false);
                                lunchAwesomDialoge(
                                    DialogType.warning,
                                    "e",
                                   e.toString(),
                                    context,
                                    getWidth(context),
                                    getHeight(context));
                              }
                            },
                            child: state is AddPhoneNumberLoading &&
                                    state.loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : AutoSizeText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 15,
                                    getDeviceLocale() == "ar" ? "حفظ" : "Save",
                                    style: const TextStyle(color: Colors.white),
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
