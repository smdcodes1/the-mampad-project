import 'package:the_project/model/busservices_model.dart';
import 'package:the_project/model/bustime_model.dart';


class BusServiceViewModel {
  BusServicesModel data;
  BusServiceViewModel({required this.data});

  int? get id => data.id;
  String? get fromplace => data.fromplace;
  String? get toplace => data.toplace;
  String? get description => data.description;

  List<Bustime>? get bustime => data.bustime;

  
}
