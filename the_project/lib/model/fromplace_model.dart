
import 'dart:convert';

FromplaceModel FromplaceModelFromJson(String str) => FromplaceModel.fromJson(json.decode(str));

String FromplaceModelToJson(FromplaceModel data) => json.encode(data.toJson());

class FromplaceModel {
    int id;
    String places;

    FromplaceModel({
        required this.id,
        required this.places,
    });

    factory FromplaceModel.fromJson(Map<String, dynamic> json) => FromplaceModel(
        id: json["id"],
        places: json["places"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "places": places,
    };

    @override
    bool operator ==(Object other) =>
      identical(this, other) ||
      other is FromplaceModel && runtimeType == other.runtimeType && id == other.id;

    @override
    int get hashCode => id.hashCode;
  }
