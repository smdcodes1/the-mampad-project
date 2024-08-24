
class BannerModel {
    int id;
    int categoryid;
    String image;

    BannerModel({
        required this.id,
        required this.categoryid,
        required this.image,
    });

    factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        categoryid: json["categoryid"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoryid": categoryid,
        "image": image,
    };
}