import 'package:mal/model/stage_details_model.dart';

abstract class StagesStates {}

class StagesInitialState extends StagesStates {}


//get stages states
class GetStagesLoadingState extends StagesStates {}
class GetStagesSuccessState extends StagesStates {}
class GetStagesErrorState extends StagesStates {
  final String error;

  GetStagesErrorState(this.error);
}

//get stage details
class GetStageDetailsLoadingState extends StagesStates {}
class GetStageDetailsSuccessState extends StagesStates {
  final StageDetails stageDetails;

  GetStageDetailsSuccessState({required this.stageDetails});
}
class GetStageDetailsErrorState extends StagesStates {
  final String error;

  GetStageDetailsErrorState({required this.error});
}



// submit answers
class SubmitAnswersLoadingState extends StagesStates {}
class SubmitAnswersSuccessState extends StagesStates {
  final String message;

  SubmitAnswersSuccessState(this.message);

}
class StagePassedState extends StagesStates {
  final String message;

  StagePassedState(this.message);

}
class StageFailedState extends StagesStates {
  final String message;

  StageFailedState(this.message);

}
class SubmitErrorConnectionState extends StagesStates {
  final String error;

  SubmitErrorConnectionState({required this.error});
}
class SubmitAnswersErrorState extends StagesStates {
  final String error;

  SubmitAnswersErrorState({required this.error});
}

class ChoseAnswerState extends StagesStates {}
class AnswerAllQuestion extends StagesStates {
  final String message;

  AnswerAllQuestion(this.message);
}
class AllQuestionsAnswered extends StagesStates {

}


class TestState extends StagesStates {}
