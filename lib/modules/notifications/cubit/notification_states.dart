abstract class NotificationStates {}

class NotificationInitialState extends NotificationStates {}

// get notification

class GetAllNotificationLoadingState extends NotificationStates {}

class GetAllNotificationSuccessState extends NotificationStates {}

class GetAllNotificationErrorState extends NotificationStates {
  final String error;

  GetAllNotificationErrorState(this.error);
}
class GetNotiErrorConnectionState extends NotificationStates {
  final String ? error;

  GetNotiErrorConnectionState({this.error});
}
