
import 'dart:convert';

ToplaceModel ToplaceModelFromJson(String str) => ToplaceModel.fromJson(json.decode(str));

String ToplaceModelToJson(ToplaceModel data) => json.encode(data.toJson());

class ToplaceModel {
    int placeallocationId;
    int id;
    String places;
    int isactive;

    ToplaceModel({
        required this.placeallocationId,
        required this.id,
        required this.places,
        required this.isactive,
    });

    factory ToplaceModel.fromJson(Map<String, dynamic> json) => ToplaceModel(
        placeallocationId: json["placeallocationId"],
        id: json["id"],
        places: json["places"],
        isactive: json["isactive"],
    );

    Map<String, dynamic> toJson() => {
        "placeallocationId": placeallocationId,
        "id": id,
        "places": places,
        "isactive": isactive,
    };

    @override
    bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToplaceModel && runtimeType == other.runtimeType && id == other.id;

    @override
    int get hashCode => id.hashCode;
}
