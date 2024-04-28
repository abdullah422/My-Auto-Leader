import '../model/message_model.dart';

class MessageResponse {
  List<Message>? messages = [];

  MessageResponse.fromJson(Map<String, dynamic> json) {
    json['messages']
        .forEach((message) => messages!.add(Message.fromJson(message)));
  }
} //end of response
