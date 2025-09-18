import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teach/cubit/teachCubit/teach_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class LoadingUpload extends StatefulWidget {
  const LoadingUpload({super.key});

  @override
  State<LoadingUpload> createState() => _LoadingUploadState();
}

class _LoadingUploadState extends State<LoadingUpload> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeachCubit, TeachState>(
      builder: (context, state) {
        if (state is Percentage) {
          return WillPopScope(
            onWillPop: () {
              return Future.delayed(Duration.zero);
            },
            child: AlertDialog(
              backgroundColor: mode ? nightBar["orange"] : dayBar["blue2"],
              content: Container(
                width: getWidth(context) / 2,
                height: getHeight(context) / 3,
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: state.percent,
                  animationDuration: 400,
                  animateFromLastPercent: true,
                  onAnimationEnd: () {},
                  progressColor: const Color.fromARGB(255, 32, 138, 36),
                  animation: true,
                  curve: Curves.easeInOut,
                  center: Center(
                    child: myImageAsset("images/loading.gif", context),
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container(
            width: getWidth(context) / 2,
            height: getHeight(context) / 2,
          );
        }
      },
    );
  }
}
