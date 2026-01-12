
// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:teach/features/main-screen/presentation/view/manager/managerScreen/manager_screen_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

// ignore: camel_case_types
class mainScreenBottomNavigationBar extends StatelessWidget {
  const mainScreenBottomNavigationBar({
    super.key,
  
  });



  @override
  Widget build(BuildContext context) {
      var box = Hive.box(hiveBoxName);
     List<dynamic> listOfIcons = [
      Icons.home_rounded,
      Image.asset(
        "images/add-folder.png",
        width: getWidth(context) * .08,
        height: getWidth(context) * .08,
      ),
      Image.asset(
        "images/add_ads.png",
        width: getWidth(context) * .08,
        height: getWidth(context) * .08,
      ),
      checkPermision(box.get(editing), box.get(deleting), box.get(watching),
              box.get(isCode), box.get(isFile), box.get(noting))
          ? Image.asset(
              "images/add_phone.png",
              width: getWidth(context) * .08,
              height: getWidth(context) * .08,
            )
          : "",
      Icons.settings,
    ];
    return Container(
        margin: const EdgeInsets.all(20),
        height: getWidth(context) * .155,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: mode ? Colors.white.withOpacity(.5) : Colors.white,
          boxShadow: [
            BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(.15),
                blurRadius: 30,
                offset: const Offset(0, 10))
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: BlocBuilder<ManagerScreenCubit, ManagerScreenState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                  horizontal: getWidth(context) * .024),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  context.read<ManagerScreenCubit>().changeIndex(index);
                },
                splashColor: Colors.transparent,
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        bottom: state is Indexed &&
                                index == state.currentIndex
                            ? 0
                            : getWidth(context) * .029,
                        right: getWidth(context) * .0422,
                        left: getWidth(context) * .0422,
                      ),
                      width: getWidth(context) * .128,
                      height:
                          state is Indexed && index == state.currentIndex
                              ? getWidth(context) * .014
                              : 0,
                      decoration: BoxDecoration(
                          color:
                              mode ? nightBar["orange"] : dayBar["blue3"],
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(10))),
                    ),
                    index == 0
                        ? Icon(
                            listOfIcons[index],
                            size: getWidth(context) * .076,
                            color: state is Indexed &&
                                    index == state.currentIndex
                                ? mode
                                    ? nightBar["orange"]
                                    : dayBar["blue3"]
                                : Colors.black38,
                          )
                        : listOfIcons[index],
                    SizedBox(
                      height: getWidth(context) * .03,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}