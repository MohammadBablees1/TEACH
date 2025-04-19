import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:teach/cubit/upload_video_cubit/upload_video_cubit.dart';
import 'package:teach/data/consts/app_const.dart';
import 'package:teach/data/consts/day_neight.dart';

class VideoUpload extends StatelessWidget {
  const VideoUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UploadVideoCubit, UploadVideoState>(
      builder: (context, state) {
        if (state is ChangePercentage) {
          return AlertDialog(
             backgroundColor: mode ? nightBar["orange"] : dayBar["blue2"],
            content: WillPopScope(
              onWillPop: () {
                return Future.delayed(Duration.zero);
              },
              child: Container(
                width: getWidth(context) / 2,
                height: getHeight(context) / 3,
                child: CircularPercentIndicator(
                  radius: 60.0,
                  lineWidth: 5.0,
                  percent: state.percent,
                  animationDuration: 400,
                  animateFromLastPercent: true,
                  onAnimationEnd: () {
                    // Navigator.pop(context);
                  },
                  animation: true,
                  curve: Curves.easeInOut,
                  progressColor: const Color.fromARGB(255, 32, 138, 36),
                  center: Center(
                    child: Image.asset("images/loading.gif"),
                  ),
                  
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
