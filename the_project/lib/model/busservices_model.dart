import 'dart:convert';

import 'package:the_project/model/bustime_model.dart';

BusServicesModel busServicesModelFromJson(String str) => BusServicesModel.fromJson(json.decode(str));

String busServicesModelToJson(BusServicesModel data) => json.encode(data.toJson());

class BusServicesModel {
    int id;
    String fromplace;
    String toplace;
    String description;
    List<Bustime> bustime;

    BusServicesModel({
        required this.id,
        required this.fromplace,
        required this.toplace,
        required this.description,
        required this.bustime,
    });

    factory BusServicesModel.fromJson(Map<String, dynamic> json) => BusServicesModel(
        id: json["id"],
        fromplace: json["fromplace"],
        toplace: json["toplace"],
        description: json["description"],
        bustime: List<Bustime>.from(json["bustime"].map((x) => Bustime.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fromplace": fromplace,
        "toplace": toplace,
        "description": description,
        "bustime": List<dynamic>.from(bustime.map((x) => x.toJson())),
    };

  
}