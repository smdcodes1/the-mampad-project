import 'package:the_project/model/banner_model.dart';

class BannerViewModel {
  BannerModel data;
  BannerViewModel({required this.data});

  int? get id => data.id;
  int? get categoryid => data.categoryid;
  String? get image => data.image;
}