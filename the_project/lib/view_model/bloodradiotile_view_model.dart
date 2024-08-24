import 'package:the_project/model/blood_raadiotile_model.dart';

class BloodRadioTileViewModel {
  BloodRadioTileModel data;
  BloodRadioTileViewModel({required this.data});

  int? get id => data.id;
  int? get isSubcategory => data.isSubcategory;
  int? get parentCategoryId => data.parentCategoryId;
  int? get isBloodbank => data.isBloodbank;
  int? get isBus => data.isBus;
  int? get isactive => data.isactive;
  int? get emergency => data.emergency;
  String? get category => data.category;
  String? get image => data.image;
  String? get area => data.area;
}