class AddressModel{
  String? label;
  String? street;
  String? city;
  String? country;
  String? region;
  String? postcode;

  AddressModel(
      {this.label,
        this.street,
        this.city,
        this.country,
        this.region,
        this.postcode});

  AddressModel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    street = json['street'];
    city = json['city'];
    country = json['country'];
    region = json['region'];
    postcode = json['postcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['label'] = label;
    data['street'] = street;
    data['city'] = city;
    data['country'] = country;
    data['region'] = region;
    data['postcode'] = postcode;
    return data;
  }
}