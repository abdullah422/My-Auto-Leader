class Ads {
  int? id;
  String? title;
  String? description;
  String? image;
  String? link;
  String? createdAt;
  String? updatedAt;

  Ads(
      {this.id,
        this.title,
        this.description,
        this.image,
        this.link,
        this.createdAt,
        this.updatedAt});

  Ads.fromJson(Map<String, dynamic> json) {
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
} //end of model
