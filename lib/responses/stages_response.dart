import 'package:mal/model/stage_model.dart';

class StageResponse {
  List<Stage>? stages = [];

  StageResponse.fromJson(Map<String, dynamic> json) {
    json['stages']
        .forEach((stage) => stages!.add(Stage.fromJson(stage)));
  }
} //end of response
