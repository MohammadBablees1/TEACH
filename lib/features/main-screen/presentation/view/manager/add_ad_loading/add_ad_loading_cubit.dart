import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';

import 'package:teach/features/main-screen/repo/create_ad_repo.dart';

part 'add_ad_loading_state.dart';

class AddAdLoadingCubit extends Cubit<AddAdLoadingState> {
  AddAdLoadingCubit() : super(AddAdLoadingInitial());

  addAdLoading(loading) {
    emit(AddAdLoading(loading: loading));
  }

  Future<void> createAd(
    File file,
    String collage,
  ) async {
   
      CreateAdRepo createAdRepo = CreateAdRepo();
     await createAdRepo.createAd(file, collage);
   
  }
}
