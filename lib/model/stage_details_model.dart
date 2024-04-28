/*
class StageDetails {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  String? createdAt;
  String? updatedAt;

  StageDetails(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.createdAt,
        this.updatedAt});

  StageDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['link'] = link;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}*/


/*class SubStages {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  int? parentId;
  String? coachName;
  String? createdAt;
  String? updatedAt;
  int? status;
  List<SubStages>? subStages;
  List<Questions>? questions;

  SubStages(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.parentId,
        this.coachName,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.subStages,
        this.questions});

  SubStages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    parentId = json['parent_id'];
    coachName = json['coach_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    if (json['sub_stages'] != null) {
      subStages = <StageDetails>[];
      json['sub_stages'].forEach((v) {
        subStages!.add(StageDetails.fromJson(v));
      });
    }
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }
}*/

/*
class Questions {
  int? id;
  int? stageId;
  String? question;
  String? createdAt;
  String? updatedAt;
  List<Answers>? answers;

  Questions(
      {this.id,
        this.stageId,
        this.question,
        this.createdAt,
        this.updatedAt,
        this.answers});

  Questions.fromJson(Map<String, dynamic> json) {
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

}

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

}
class StageDetails {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  int? parentId;
  String? coachName;
  String? createdAt;
  String? updatedAt;
  int? status;
  List<StageDetails>? subStages;
  List<Questions>? questions;

  StageDetails(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.parentId,
        this.coachName,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.subStages,
        this.questions});

  StageDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    parentId = json['parent_id'];
    coachName = json['coach_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    if (json['sub_stages'] != null) {
      subStages = <StageDetails>[];
      json['sub_stages'].forEach((v) {
        subStages!.add(StageDetails.fromJson(v));
      });
    }
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
  }

}*/


class StageDetails {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  int? parentId;
  String? coachName;
  String? createdAt;
  String? updatedAt;
  int? status;
  List<SubStages>? subStages;
  List<Question>? questions;

  StageDetails(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.parentId,
        this.coachName,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.subStages,
        this.questions});

  StageDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    parentId = json['parent_id'];
    coachName = json['coach_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    if (json['sub_stages'] != null) {
      subStages = <SubStages>[];
      json['sub_stages'].forEach((v) {
        subStages!.add(new SubStages.fromJson(v));
      });
    }
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }
}

class SubStages {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  int? parentId;
  String? coachName;
  String? createdAt;
  String? updatedAt;
  int? status;
  List<StageDetails>? subStages;
  List<Question>? questions;

  SubStages(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.parentId,
        this.coachName,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.subStages,
        this.questions});

  SubStages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    link = json['link'];
    parentId = json['parent_id'];
    coachName = json['coach_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    if (json['sub_stages'] != null) {
      subStages = <StageDetails>[];
      json['sub_stages'].forEach((v) {
        subStages!.add(StageDetails.fromJson(v));
      });
    }
    if (json['questions'] != null) {
      questions = <Question>[];
      json['questions'].forEach((v) {
        questions!.add(new Question.fromJson(v));
      });
    }
  }


}

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
        answers!.add(new Answers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stage_id'] = this.stageId;
    data['question'] = this.question;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.answers != null) {
      data['answers'] = this.answers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['answer'] = this.answer;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}