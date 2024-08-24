
import 'dart:convert';

EmergencyModel emergencyModelFromJson(String str) => EmergencyModel.fromJson(json.decode(str));

String emergencyModelToJson(EmergencyModel data) => json.encode(data.toJson());

class EmergencyModel {
    int id;
    String category;
    List<Service> service;

    EmergencyModel({
        required this.id,
        required this.category,
        required this.service,
    });

    factory EmergencyModel.fromJson(Map<String, dynamic> json) => EmergencyModel(
        id: json["id"],
        category: json["category"],
        service: List<Service>.from(json["service"].map((x) => Service.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "service": List<dynamic>.from(service.map((x) => x.toJson())),
    };
}

class Service {
    String servicename;
    String area;
    int phonenumber;
    String image;

    Service({
        required this.servicename,
        required this.area,
        required this.phonenumber,
        required this.image,
    });

    factory Service.fromJson(Map<String, dynamic> json) => Service(
        servicename: json["servicename"],
        area: json["area"],
        phonenumber: json["phonenumber"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "servicename": servicename,
        "area": area,
        "phonenumber": phonenumber,
        "image": image,
    };
}
