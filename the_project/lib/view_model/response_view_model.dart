

import 'package:the_project/model/response_model.dart';

class ResponseViewModel {
  ResponseModel data;
  ResponseViewModel({required this.data});

  String? get msg => data.msg;
}