import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
    int id;
    String category;
    String image;
    int isSubcategory;
    int isBus;
    int isBloodbank;
    int emergency;
    int totalItems;

    CategoryModel({
        required this.id,
        required this.category,
        required this.image,
        required this.isSubcategory,
        required this.isBus,
        required this.isBloodbank,
        required this.emergency,
        required this.totalItems,
    });

    factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        category: json["category"],
        image: json["image"],
        isSubcategory: json["is_subcategory"],
        isBus: json["is_bus"],
        isBloodbank: json["is_bloodbank"],
        emergency: json["emergency"],
        totalItems: json["total_items"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "image": image,
        "is_subcategory": isSubcategory,
        "is_bus": isBus,
        "is_bloodbank": isBloodbank,
        "emergency": emergency,
        "total_items": totalItems,
    };
}
