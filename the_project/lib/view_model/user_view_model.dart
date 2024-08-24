import 'package:the_project/model/user_model.dart';

class UserViewModel {
  UserModel data;
  UserViewModel({required this.data});

  int? get id => data.id;
  String? get name => data.name;
  String? get phone => data.phone;
}