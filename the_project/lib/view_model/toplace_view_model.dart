import 'package:the_project/model/toplace_model.dart';

class ToplaceViewModel {
  ToplaceModel data;
  ToplaceViewModel({required this.data});

  int? get id => data.id;
  int? get placeallocationId => data.placeallocationId;
  int? get isactive => data.isactive;
  String? get places => data.places;

  @override
    bool operator ==(Object other) =>
    identical(this, other) ||
    other is ToplaceViewModel && runtimeType == other.runtimeType && id == other.id;

    @override
    int get hashCode => id.hashCode;
}