import 'package:the_project/model/service_model.dart';

class ServiceViewModel {
   ServiceModel data;
  ServiceViewModel({required this.data});

  int? get id => data.id;
  int? get categoryid => data.categoryid;
  int? get phonenumber => data.phonenumber;
  int? get isPaid => data.isPaid;
  String? get servicename => data.servicename;
  String? get image => data.image;
  String? get area => data.area;
}