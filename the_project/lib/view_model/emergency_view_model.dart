import 'package:the_project/model/emergency_model.dart';

class EmergencyViewModel {
  EmergencyModel data;
  EmergencyViewModel({required this.data});

  int? get id => data.id;
  String? get category => data.category;

  List<Service>? get service => data.service;
}