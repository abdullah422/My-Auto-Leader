abstract class LayoutStates {}

class LayoutInitialState extends LayoutStates {}


//Ads
class ChangeBottomNavBarState extends LayoutStates {}
class GetMessagesSuccessState extends LayoutStates {}
class GetMessagesErrorState extends LayoutStates {
  final String error;

  GetMessagesErrorState(this.error);
}










class GetAllNotificationLoadingState extends LayoutStates {}

class GetAllNotificationSuccessState extends LayoutStates {}

class GetAllNotificationErrorState extends LayoutStates {
  final String error;

  GetAllNotificationErrorState(this.error);
}
class GetNotiErrorConnectionState extends LayoutStates {
  final String ? error;

  GetNotiErrorConnectionState({this.error});
}


//images

class ImageLoadedState extends LayoutStates {}
class RemoveSelectedImageState extends LayoutStates {}