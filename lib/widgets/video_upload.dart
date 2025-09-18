import 'package:auto_size_text/auto_size_text.dart';
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
            content: PopScope(
              canPop: false,
              child: Container(
                width: getWidth(context) * .5,
                height: getHeight(context) * .3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: getWidth(context) * .24,
                        height: getHeight(context) * .3,
                        child: CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: state.percent,
                          animationDuration: 400,
                          animateFromLastPercent: true,
                          animation: true,
                          curve: Curves.easeInOut,
                          progressColor: state.color,
                          center: Center(
                            child: AutoSizeText(
                              "${(state.percent * 100).floor().toString()}%",
                              maxLines: 1,
                              minFontSize: 5,
                              maxFontSize: 12,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
