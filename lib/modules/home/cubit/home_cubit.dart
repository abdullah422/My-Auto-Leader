import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/model/ads_model.dart';
import 'package:mal/model/stage_model.dart';
import 'package:mal/modules/home/cubit/home_states.dart';
import 'package:mal/responses/ad_response.dart';
import 'package:mal/responses/stages_response.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';

import '../../../translations/locale_keys.g.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<Ads> adss = [];
  late bool getAdsLoading = false;
  late bool getAdsConnectionError = false;

  void tryAgain() {
      if(adss.isEmpty){
        getAdsConnectionError=false;
        getAdsLoading =false;
        getAllAds();
        emit(TryAgainState());
      }
      if(stages.isEmpty){
        getStagesLoading =false;
        getStagesConnectionError =false;
        getStages();
        emit(TryAgainState());
      }


  }

  void getAllAds() async {
    getAdsLoading = true;
    emit(GetAllAdsLoadingState());
    adss = [];
    try {
      await API()
          .getData(
        endPoint: EndPoints.getAllAds,
      )
          .then((value) {
        var adsResponse = AdsResponse.fromJson(value.data);
        adss = adsResponse.adss!;
        print('get ads successfully');
        getAdsLoading = false;
        emit(GetAllAdsSuccessState());
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetAllAdsErrorConnectionState(
            error: LocaleKeys.chek_internet.tr()));
        getAdsLoading = false;
        getAdsConnectionError = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetAllAdsErrorConnectionState(error: LocaleKeys.no_internet.tr()));
        getAdsLoading = false;
        getAdsConnectionError = true;
      } else {
        emit(GetAllAdsErrorState(error:'Ops something wrong'));
      }
    } catch (e) {
      emit(GetAllAdsErrorState(error: 'Ops something wrong'));
    }
  }

  List<Stage> stages = [];
  late bool getStagesLoading = false;
  late bool getStagesConnectionError = false;
  void getStages() async {
    getStagesConnectionError = false;
    getStagesLoading = true;
    stages = [];
    emit(GetStagesLoadingState());
    try {
      await API()
          .getData(
        endPoint: EndPoints.getStages,
      )
          .then((value) {
        var messageResponse = StageResponse.fromJson(value.data);
        stages = messageResponse.stages!;
        print('get Stages successfully');
        getStagesLoading = false;
        emit(GetStagesSuccessState());
      });
    } on DioError catch (e) {
      if (e.type.name == 'other') {
        emit(GetAllAdsErrorConnectionState(
            error: LocaleKeys.chek_internet.tr()));
        getStagesConnectionError = true;
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetAllAdsErrorConnectionState(error: LocaleKeys.no_internet.tr()));
        getStagesConnectionError = true;
      } else {
        emit(GetAllAdsErrorState(error: 'Ops something wrong'));
      }
    } catch (e) {
      emit(GetStagesErrorState(error:'Ops something wrong'));
    }
  }
}
