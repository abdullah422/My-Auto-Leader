import '../../../model/contact_model.dart';

class LeadData{
  int? id;
  String? name;
  String? number;
  String? imageName;
  bool isSelected;
  bool isEditShown;
  ContactModel model;

  LeadData(this.id, this.name, this.number, this.model,
      this.imageName, this.isSelected, this.isEditShown);
}