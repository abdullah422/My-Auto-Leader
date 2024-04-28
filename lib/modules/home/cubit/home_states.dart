abstract class HomeStates {}

class HomeInitialState extends HomeStates {}
class TryAgainState extends HomeStates {}


// get Ads
class GetAllAdsLoadingState extends HomeStates {}
class GetAllAdsSuccessState extends HomeStates {}
class GetAllAdsErrorConnectionState extends HomeStates {
  final String error;

  GetAllAdsErrorConnectionState({required this.error});
}
class GetAllAdsErrorState extends HomeStates {
  final String error;

  GetAllAdsErrorState({required this.error});
}


//get stages states
class GetStagesLoadingState extends HomeStates {}
class GetStagesSuccessState extends HomeStates {}
class GetStagesErrorConnectionState extends HomeStates {
  final String error;

  GetStagesErrorConnectionState({required this.error});
}
class GetStagesErrorState extends HomeStates {
  final String error;
  GetStagesErrorState({required this.error});
}