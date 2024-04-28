    import 'answer_model.dart';

class Question {
  int? id;
  int? stageId;
  String? question;
  String? createdAt;
  String? updatedAt;
  List<Answers>? answers;

  Question(
      {this.id,
        this.stageId,
        this.question,
        this.createdAt,
        this.updatedAt,
        this.answers});

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stageId = json['stage_id'];
    question = json['question'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['answers'] != null) {
      answers = <Answers>[];
      json['answers'].forEach((v) {
        answers!.add(Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['stage_id'] = stageId;
    data['question'] = question;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (answers != null) {
      data['answers'] = answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
