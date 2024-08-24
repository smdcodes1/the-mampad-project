import 'package:the_project/model/fromplace_model.dart';

class FromplaceViewModel {
  FromplaceModel data;
  FromplaceViewModel({required this.data});

  int? get id => data.id;
  String? get places => data.places;

   @override
    bool operator ==(Object other) =>
    identical(this, other) ||
    other is FromplaceViewModel && runtimeType == other.runtimeType && id == other.id;

    @override
    int get hashCode => id.hashCode;
}