class User {
  late int id;
  late String username;
  late String email;
  late String image;
  late String phone;

  User();

  User.fromJson(Map<String, dynamic> json) {
    id = json['id']??1;
    username = json['username']??'';
    email = json['email']??'';
    image = json['image']??'';
    phone = json['phone']??'';
  }
} //end of model
