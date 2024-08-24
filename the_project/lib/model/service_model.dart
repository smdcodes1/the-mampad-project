
import 'dart:convert';

ServiceModel serviceModelFromJson(String str) => ServiceModel.fromJson(json.decode(str));

String serviceModelToJson(ServiceModel data) => json.encode(data.toJson());

class ServiceModel {
    int? id;
    int? categoryid;
    String servicename;
    String? image;
    int phonenumber;
    int? isPaid;
    String area;

    ServiceModel({
        this.id,
        this.categoryid,
        required this.servicename,
        this.image,
        required this.phonenumber,
        this.isPaid,
        required this.area,
    });

    factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        categoryid: json["categoryid"],
        servicename: json["servicename"],
        image: json["image"],
        phonenumber: json["phonenumber"],
        isPaid: json["is_paid"],
        area: json["area"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoryid": categoryid,
        "servicename": servicename,
        "image": image,
        "phonenumber": phonenumber,
        "is_paid": isPaid,
        "area": area,
    };
}
