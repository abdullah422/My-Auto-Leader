
import 'package:mal/model/question_model.dart';
import 'package:mal/model/stage_details_model.dart';

class StageDetailsResponse {
  StageDetails ? stageDetails;
  List<StageDetails>? subStages = [];

  StageDetailsResponse.fromJson(Map<String, dynamic> json) {
    stageDetails = StageDetails.fromJson(json['stage']);
    /*if(json['questions'] !=null && json['questions']!=[]){
      json['questions']
          .forEach((question) => questions!.add(Question.fromJson(question),),);
    }
    if(json['sub_stages'] !=null && json['sub_stages']!=[]){
      json['sub_stages']
          .forEach((sub) => subStages!.add(StageDetails.fromJson(sub)));
    }*/

    /*json['sub_stages']
        .forEach((sub) => subStages!.add(StageDetails.fromJson(sub)));*/
  }
} //end of response