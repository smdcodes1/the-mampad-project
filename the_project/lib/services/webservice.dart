import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:the_project/model/banner_model.dart';
import 'package:the_project/model/blood_raadiotile_model.dart';
import 'package:the_project/model/busservices_model.dart';
import 'package:the_project/model/category_model.dart';
import 'package:the_project/model/emergency_model.dart';
import 'package:the_project/model/fromplace_model.dart';
import 'package:the_project/model/response_model.dart';
import 'package:the_project/model/subcategory_model.dart';
import 'package:the_project/model/service_model.dart';
import 'package:the_project/model/toplace_model.dart';
import 'package:the_project/model/user_model.dart';

class Webservice {
//registration
Future<ResponseModel?> signup(String name, mobile) async {
  
  final Map<String, dynamic> data= {
    'name': name,
    'phone': mobile,
   
  };
//  print(data.toString());
 final response= await Dio().post(
  "https://mampadbusiness.cyralearnings.com/api/registration.php",
  data: data,
 );
//  print(response.statusCode);
  // log(response.data);
 if (response.statusCode == 200) {
  // Map<String, dynamic> responseData = response.data;
  // //  var userData= responseData;
  // var _result;
  // ResponseModel ws= ResponseModel.fromJson(responseData);
  // _result= {'status': true, 'message': ws.msg, 'WebService': ws};
  // return _result;
 var responseData= response.data;
  return ResponseModel.fromJson(responseData);
 } else {
  log('Please try again after sometime');
 
 }
 }
 //already register
 Future<ResponseModel?> login(String mobile) async {
  
  final Map<String, dynamic> data= {
    'phone': mobile,
   
  };
//  print(data.toString());
 final response= await Dio().post(
  "https://mampadbusiness.cyralearnings.com/api/already_register_user.php",
  data: data,
 );
//  print(response.statusCode);
  // log(response.data);
 if (response.statusCode == 200) {
  // Map<String, dynamic> responseData = response.data;
  // //  var userData= responseData;
  // var _result;
  // ResponseModel ws= ResponseModel.fromJson(responseData);
  // _result= {'status': true, 'message': ws.msg, 'WebService': ws};
  // return _result;
  var responseData= response.data;
  return ResponseModel.fromJson(responseData);
 } else {
  log('Please try again after sometime');
 }
 }
 //fetch user
  Future<UserModel> fetchUser(String username) async {
   final response= await Dio().post(
   'https://mampadbusiness.cyralearnings.com/api/get_user.php',
   data: {'username': username}
   );
  //  log(response.data.toString());
   if (response.statusCode == 200) {
    // log('response: '+response.data.toString());
    var responseData= response.data;
    var jsonString = responseData;
    return userModelFromJson(jsonString);
    
   } else {
    throw Exception('falied to load the user');
    
   }
  }
 //fetch banner
   Future<List<BannerModel>?> fetchBanner(int categoryid) async {
  try {
    final response= await Dio().post(
      'https://mampadbusiness.cyralearnings.com/api/get_banner.php',
    data: {"categoryid": categoryid.toString()}
    );
  // log(response.statusCode.toString());
  // log(response.data.toString());
    if (response.statusCode == 200) {
    
      final parsed= response.data.cast<Map<String, dynamic>>();
      return parsed
             .map<BannerModel>((json) => BannerModel.fromJson(json))
             .toList();
    } else {
      throw Exception('failed to load banners');
      
    }
  } catch (e) {
    log(e.toString());
  }
 }
 //fetch category
  Future<List<CategoryModel>> fetchCategory(String searchkey, query) async {
   final response = await Dio()
        .post("https://mampadbusiness.cyralearnings.com/api/get_category.php", 
         data: {"searchkey": searchkey, "page": query});
    if (response.statusCode == 200) {
          // log(response.data.toString());

      final parsed = response.data.cast<Map<String, dynamic>>();
      return parsed
          .map<CategoryModel>((json) => CategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load category');
    }
  }
 //fetch subcategory
 Future<List<SubcategoryModel>> fetchSubcategory(String searchkey, int query, int categoryid) async {
    final response = await Dio()
        .post("https://mampadbusiness.cyralearnings.com/api/get_subcategory.php", 
         data: {"searchkey": searchkey,"page":query,"categoryid": categoryid.toString()});
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = json.decode(response.data).cast<Map<String, dynamic>>();
      return parsed
          .map<SubcategoryModel>((json) => SubcategoryModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load subcategory');
    }
  }

  //fetch service
 Future<List<ServiceModel>> fetchService(String searchkey, int query, int categoryid, {bool isImageNull = false}) async {
   final response = await Dio()
      .post("https://mampadbusiness.cyralearnings.com/api/get_service.php", 
      data: {"searchkey": searchkey,"page": query,"categoryid": categoryid.toString()},
      );
    // log(response.statusCode.toString());
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      // return parsed
      //     .map<ServiceModel>((json) => ServiceModel.fromJson(json))
      //     .toList();
        return parsed.map<ServiceModel>((e) {
        return ServiceModel(
          id: e["id"] as int?,
          categoryid: e["categoryid"] as int?,
          servicename: e["servicename"] as String,
          image: isImageNull ? null : e["image"] as String?,
          phonenumber: e["phonenumber"] ?? "",
          isPaid: e["isPaid"] as int?,
          area: e["area"] as String,
        );
      }).toList();
    } else {
      throw Exception('Failed to load servicee');
    }
  }

  //fetch emergency service
   Future<List<EmergencyModel>> fetchEmergencyService(int categoryid) async {
   final response = await Dio()
      .post("https://mampadbusiness.cyralearnings.com/api/get_emergency.php", 
      data: {"categoryid": categoryid.toString()},
      );
    // log(response.statusCode.toString());
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      return parsed
          .map<EmergencyModel>((json) => EmergencyModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load servicee');
    }
  }
  //fetch drop down items1
  Future<List<FromplaceModel>> fetchDropdownItems1() async {
    final response = await Dio()
        .get('https://mampadbusiness.cyralearnings.com/api/get_from_place.php');
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      // return parsed.map<FromplaceModel>((e) {
      //   return FromplaceModel(id: e["id"], places: e["places"]);
      // }).toList();
        return parsed
          .map<FromplaceModel>((json) => FromplaceModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load!');
    }
  }
  //fetch drop down items2
   Future<List<ToplaceModel>> fetchDropdownItems2(int placeid) async {
    final response = await Dio().post(
        'https://mampadbusiness.cyralearnings.com/api/get_to_places.php',
        data: {"placeid": placeid.toString()});
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      // return parsed.map<ToplaceModel>((e) {
      //   return ToplaceModel(
      //       placeallocationId: e["placeallocationId"],
      //       id: e["id"],
      //       places: e["places"],
      //       isactive: e["isactive"]);
      // }).toList();
    return parsed
          .map<ToplaceModel>((json) => ToplaceModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load!');
    }
  }
  //Bus time
    Future<List<BusServicesModel>> fetchBusServices(int? allocationid) async {
    final response = await Dio().post(
        'https://mampadbusiness.cyralearnings.com/api/get_bustime.php',
        data: {"allocationid": allocationid.toString()});

    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      return parsed
          .map<BusServicesModel>((json) => BusServicesModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load!');
    }
  }
  //fetch blood
   Future<List<BloodRadioTileModel>?> fetchBloodRadiotile() async {
   try {
       final response = await Dio()
        .get('https://mampadbusiness.cyralearnings.com/api/get_bloodgrp.php');
    // log(response.data.toString());
    if (response.statusCode == 200) {
      final parsed = response.data.cast<Map<String, dynamic>>();
      return parsed
          .map<BloodRadioTileModel>((json) => BloodRadioTileModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load!');
    }
   } catch (e) {
     log(e.toString());
   }
  }
  //apply blood donation
  Future<ResponseModel?> applyBlooddonation(String name, mobile, area, bloodgrp, catid) async {
  
  final Map<String, dynamic> data= {
    'name': name,
    'phone': mobile,
    'area': area,
    'bloodgrp': bloodgrp,
    'catid': catid,
   
  };
//  print(data.toString());
 final response= await Dio().post(
  "https://mampadbusiness.cyralearnings.com/api/apply_blood_donation.php",
  data: data,
 );
//  print(response.statusCode);
  // log(response.data.toString());
 if (response.statusCode == 200) {
  // Map<String, dynamic> responseData = response.data;
  //  var _result;
  // ResponseModel ws= ResponseModel.fromJson(responseData);
  // _result= {'status': true, 'message': ws.msg, 'WebService': ws};
  // return _result;
  var responseData= response.data;
  return ResponseModel.fromJson(responseData);
 } else {
  log('Please try again after sometime');
 }
 }
}
