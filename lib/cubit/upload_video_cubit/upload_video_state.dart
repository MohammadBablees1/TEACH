part of 'upload_video_cubit.dart';

@immutable
sealed class UploadVideoState {
  
  
}

final class UploadVideoInitial extends UploadVideoState {}

final class ChangePercentage extends UploadVideoState {
  var percent = 0.0;
  ChangePercentage({required this.percent});
}
