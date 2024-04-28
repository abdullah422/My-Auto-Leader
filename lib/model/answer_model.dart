class Answers {
  int? id;
  int? questionId;
  String? answer;
  String? status;
  String? createdAt;
  String? updatedAt;

  Answers(
      {this.id,
        this.questionId,
        this.answer,
        this.status,
        this.createdAt,
        this.updatedAt});

  Answers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    answer = json['answer'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_id'] = questionId;
    data['answer'] = answer;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}