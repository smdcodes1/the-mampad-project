import 'package:the_project/model/category_model.dart';

class CategoryViewModel {
  CategoryModel data;
  CategoryViewModel({required this.data});

  int? get id => data.id;
  int? get isSubcategory => data.isSubcategory;
  int? get isBus => data.isBus;
  int? get isBloodbank => data.isBloodbank;
  int? get emergency => data.emergency;
  int? get totalItems => data.totalItems;
  String? get category => data.category;
  String? get image => data.image;
}