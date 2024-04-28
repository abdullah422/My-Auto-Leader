import '../model/notification_model.dart';

class NotificationResponse {

  List<Notification> ? notifications = [];

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    json['notifications']
        .forEach((noti) => notifications!.add(Notification.fromJson(noti)));
  }
} //end of response
