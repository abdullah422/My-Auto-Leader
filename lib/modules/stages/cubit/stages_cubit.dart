import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mal/model/question_model.dart';
import 'package:mal/model/stage_details_model.dart';
import 'package:mal/modules/home/cubit/home_cubit.dart';
import 'package:mal/responses/stage_details_response.dart';
import 'package:mal/shared/network/remote/api.dart';
import 'package:mal/shared/network/remote/end_points.dart';
import 'package:mal/translations/locale_keys.g.dart';

import 'stages_states.dart';

class StagesCubit extends Cubit<StagesStates> {
  StagesCubit() : super(StagesInitialState());

  static StagesCubit get(context) => BlocProvider.of(context);

  bool getStageDetailsLoading = false;
  bool getStagesErrorConnection = false;
  //List<StageDetails>? subStages = [];
  StageDetails ? stageDetails;

  getStageDetails(int id) async {
    emit(GetStageDetailsLoadingState());
    getStageDetailsLoading = true;
    getStagesErrorConnection = false;
    stageDetails = null;
    try {
      await API().getData(endPoint: EndPoints.getStage + '$id').then((value) {
        var stageDetailsResponse = StageDetailsResponse.fromJson(value.data);
        /*questions = stageDetailsResponse.questions!;
        subStages = stageDetailsResponse.subStages;*/
        stageDetails = stageDetailsResponse.stageDetails!;
        getStageDetailsLoading = false;
        print(stageDetails!.subStages.toString());
        print(stageDetails!.questions.toString());
        emit(GetStageDetailsSuccessState( stageDetails:stageDetails as StageDetails));
      });
    } on DioError catch (e) {
      //print(e.toString());
      if (e.type.name == 'other') {
        getStagesErrorConnection = true;
        emit(GetStageDetailsErrorState(error: LocaleKeys.chek_internet.tr()));
      } else if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        emit(GetStageDetailsErrorState(error: LocaleKeys.chek_internet.tr()));
        getStagesErrorConnection = true;
      } else {
        getStagesErrorConnection = true;
        emit(GetStageDetailsErrorState(error: LocaleKeys.ops.tr()));
      }
    } catch (e) {
      //print(e.toString());
      getStagesErrorConnection = true;
      emit(GetStageDetailsErrorState(error: LocaleKeys.ops));
    }
  }

  List<int> answers = [];
  Map<int, int>? answersMap = {};
  var answersList = [];

  void addToAnswerList({required int qId, required int aId}) {
    answersMap!.addEntries([MapEntry(qId, aId)]);

    emit(ChoseAnswerState());
    answersList = [];
    var splayTreeMap = SplayTreeMap.of(answersMap!);
    splayTreeMap.forEach((k, v) => answersList.add(v));
  }

  late bool submitLoading = false;
  late bool submitConnectionError = false;

  void submit(int stageId) async {
    if (answersList.length != stageDetails!.questions!.length) {
      emit(AnswerAllQuestion(LocaleKeys.answer_all_q.tr()));
    } else {
      submitLoading = true;
      emit(AllQuestionsAnswered());
      emit(SubmitAnswersLoadingState());
      try {
        await API().postData(
            endPoint: EndPoints.finishStage + '$stageId',
            data: {'answers[]':answersList.toString()
            }).then((value) {
          submitLoading = false;
          emit(SubmitAnswersSuccessState(LocaleKeys.done));
          print('data = '+value.data.toString());

          print('status code = '+value.statusCode.toString());

          if (value.data['status'] == 1) {
            print('when status = 1 => '+value.data['message']);
            emit(StagePassedState(value.data['message']));
          } else {
            if(value.statusCode==201){
              emit(StagePassedState(value.data['message']));
            }else{
              print('when status = else => '+ value.data['message']);
              emit(StageFailedState(value.data['message']));
            }


          }
        });
      } on DioError catch (e) {
        if (e.type.name == 'other') {
          submitLoading = false;
          emit(
              SubmitErrorConnectionState(error: LocaleKeys.chek_internet.tr()));

        } else if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.receiveTimeout) {
          submitLoading = false;
          emit(SubmitErrorConnectionState(error: LocaleKeys.no_internet.tr()));
        } else {
          submitLoading = false;
          emit(SubmitAnswersErrorState(error:LocaleKeys.ops));
        }
      } catch (e) {
        submitLoading = false;
        emit(SubmitErrorConnectionState(error: LocaleKeys.ops.tr()));
      }
    }
  }
}
