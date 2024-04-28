import 'package:mal/model/ads_model.dart';

class AdsResponse {

  List<Ads> ? adss = [];

  AdsResponse.fromJson(Map<String, dynamic> json) {
    json['ads']
        .forEach((ads) => adss!.add(Ads.fromJson(ads)));
  }
} //end of response
