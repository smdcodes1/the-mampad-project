
class SubcategoryModel {
   
    // int categoryid;
    int id;
    String category;
    String image;
    int isSubcategory;
    int isBus;
    int isBloodbank;
    int emergency;
    int totalItems;


    SubcategoryModel({
        required this.id,
        // required this.categoryid,
        required this.category,
        required this.image,
        required this.isBus,
        required this.isBloodbank,
        required this.emergency,
        required this.totalItems,
       required this.isSubcategory,
    });

    factory SubcategoryModel.fromJson(Map<String, dynamic> json) => SubcategoryModel(
        id: json["id"],
        // categoryid: json["categoryid"],
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
        // "categoryid": categoryid,
        "category": category,
        "image": image,
        "is_subcategory": isSubcategory,
        "is_bus": isBus,
        "emergency": emergency,
        "total_items": totalItems,
        "is_bloodbank": isBloodbank,
    };
}