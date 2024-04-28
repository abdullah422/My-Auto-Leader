class UserProfile {
  int? id;
  int? userId;
  String? userToken;
  String? phoneNumber;
  String? image;
  String? telegramUsername;
  String? createdAt;
  String? updatedAt;
  String? userDetailsName;
  String? userDetailsSecondName;
  String? userDetailsGender;
  String? joinDate;
  String? productValidity;
  String? expireDate;
  String? simplyUrl;

  UserProfile(
      {this.id,
        this.userId,
        this.userToken,
        this.phoneNumber,
        this.image,
        this.telegramUsername,
        this.createdAt,
        this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userToken = json['user_token'];
    phoneNumber = json['phone_number'];
    image = json['image'];
    telegramUsername = json['telegram_username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userDetailsName = json['user_detail_name'];
    userDetailsSecondName = json['user_detail_second_name'];
    userDetailsGender = json['user_detail_gender'];
    joinDate = json['join_date'];
    productValidity = json['product_validity'];
    expireDate = json['expire_date'];
    simplyUrl = json['simply_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['user_token'] = userToken;
    data['phone_number'] = phoneNumber;
    data['image'] = image;
    data['telegram_username'] = telegramUsername;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}