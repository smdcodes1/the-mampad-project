import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

class ResponseModel {
  final String msg;
  ResponseModel({required this.msg});

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(msg: json["msg"],
  );
}