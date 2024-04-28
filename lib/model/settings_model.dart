class Settings {
  int? id;
  String? logo;
  String? logoFooter;
  String? googleplay;
  String? apple;
  String? facebook;
  String? twitter;
  String? youtube;
  String? linkedin;
  String? instagram;
  String? tiktok;
  String? telegram;
  String? phone;
  String? email;
  String? privacy;
  String? about;
  String? faq;
  String? stagesForm;
  String? adsForm;
  String? websiteForm;
  int? maintenanceMoode;
  int? maintenanceYear;
  int? maintenanceMonth;
  int? maintenanceDays;
  int? maintenanceHours;
  int? maintenanceMinutes;
  int? maintenanceSeconds;
  String? maintenanceTitle;
  String? maintenanceDescription;
  String? createdAt;
  String? updatedAt;

  Settings(
      {this.id,
        this.logo,
        this.logoFooter,
        this.googleplay,
        this.apple,
        this.facebook,
        this.twitter,
        this.youtube,
        this.linkedin,
        this.instagram,
        this.tiktok,
        this.telegram,
        this.phone,
        this.email,
        this.privacy,
        this.about,
        this.faq,
        this.stagesForm,
        this.adsForm,
        this.websiteForm,
        this.maintenanceMoode,
        this.maintenanceYear,
        this.maintenanceMonth,
        this.maintenanceDays,
        this.maintenanceHours,
        this.maintenanceMinutes,
        this.maintenanceSeconds,
        this.maintenanceTitle,
        this.maintenanceDescription,
        this.createdAt,
        this.updatedAt});

  Settings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    logoFooter = json['logo_footer'];
    googleplay = json['googleplay'];
    apple = json['apple'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    youtube = json['youtube'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
    telegram = json['telegram'];
    phone = json['phone'];
    email = json['email'];
    privacy = json['privacy'];
    about = json['about'];
    faq = json['faq'];
    stagesForm = json['stages_form'];
    adsForm = json['ads_form'];
    websiteForm = json['website_form'];
    maintenanceMoode = json['maintenance_moode'];
    maintenanceYear = json['maintenance_year'];
    maintenanceMonth = json['maintenance_month'];
    maintenanceDays = json['maintenance_days'];
    maintenanceHours = json['maintenance_hours'];
    maintenanceMinutes = json['maintenance_minutes'];
    maintenanceSeconds = json['maintenance_seconds'];
    maintenanceTitle = json['maintenance_title'];
    maintenanceDescription = json['maintenance_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['logo'] = logo;
    data['logo_footer'] = logoFooter;
    data['googleplay'] = googleplay;
    data['apple'] = apple;
    data['facebook'] = facebook;
    data['twitter'] = twitter;
    data['youtube'] = youtube;
    data['linkedin'] = linkedin;
    data['instagram'] = instagram;
    data['tiktok'] = tiktok;
    data['telegram'] = telegram;
    data['phone'] = phone;
    data['email'] = email;
    data['privacy'] = privacy;
    data['about'] = about;
    data['faq'] = faq;
    data['stages_form'] = stagesForm;
    data['ads_form'] = adsForm;
    data['website_form'] = websiteForm;
    data['maintenance_moode'] = maintenanceMoode;
    data['maintenance_year'] = maintenanceYear;
    data['maintenance_month'] = maintenanceMonth;
    data['maintenance_days'] = maintenanceDays;
    data['maintenance_hours'] = maintenanceHours;
    data['maintenance_minutes'] = maintenanceMinutes;
    data['maintenance_seconds'] = maintenanceSeconds;
    data['maintenance_title'] = maintenanceTitle;
    data['maintenance_description'] = maintenanceDescription;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}