
import 'dart:convert';

BloodRadioTileModel bloodRadioTileModelFromJson(String str) => BloodRadioTileModel.fromJson(json.decode(str));

String bloodRadioTileModelToJson(BloodRadioTileModel data) => json.encode(data.toJson());

class BloodRadioTileModel {
    int id;
    String category;
    String image;
    int isSubcategory;
    int parentCategoryId;
    String area;
    int isBloodbank;
    int isBus;
    int isactive;
    int emergency;

    BloodRadioTileModel({
        required this.id,
        required this.category,
        required this.image,
        required this.isSubcategory,
        required this.parentCategoryId,
        required this.area,
        required this.isBloodbank,
        required this.isBus,
        required this.isactive,
        required this.emergency,
    });

    factory BloodRadioTileModel.fromJson(Map<String, dynamic> json) => BloodRadioTileModel(
        id: json["id"],
        category: json["category"],
        image: json["image"],
        isSubcategory: json["is_subcategory"],
        parentCategoryId: json["parent_category_id"],
        area: json["area"],
        isBloodbank: json["is_bloodbank"],
        isBus: json["is_bus"],
        isactive: json["isactive"],
        emergency: json["emergency"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "image": image,
        "is_subcategory": isSubcategory,
        "parent_category_id": parentCategoryId,
        "area": area,
        "is_bloodbank": isBloodbank,
        "is_bus": isBus,
        "isactive": isactive,
        "emergency": emergency,
    };
}
