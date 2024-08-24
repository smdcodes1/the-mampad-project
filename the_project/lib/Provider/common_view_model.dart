import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:the_project/class_shared.dart';
import 'package:the_project/services/webservice.dart';
import 'package:the_project/view_model/banner_view_model.dart';
import 'package:the_project/view_model/bloodradiotile_view_model.dart';
import 'package:the_project/view_model/busservice_view_model.dart';
import 'package:the_project/view_model/category_view_model.dart';
import 'package:the_project/view_model/emergency_view_model.dart';
import 'package:the_project/view_model/from_place_view_model.dart';
import 'package:the_project/view_model/response_view_model.dart';
import 'package:the_project/view_model/service_view_model.dart';
import 'package:the_project/view_model/subcategory_view_model.dart';
import 'package:the_project/view_model/toplace_view_model.dart';
import 'package:the_project/view_model/user_view_model.dart';

class ApiProvider extends ChangeNotifier {
  //pagination tools
  bool hasNextPage = true;
  bool checking = true;
 
  //selected items
  // CategoryModel? _categoryModel;
  // CategoryModel? get categoryModel => _categoryModel;

  // void setCategoryModel(CategoryModel? value) {
  //   _categoryModel = value;
  //   notifyListeners();
  // }

  bool _isBannerLoading= true;
  bool get isBannerLoading => _isBannerLoading;
  List<BannerViewModel> _bannerData= [];
  List<BannerViewModel> get bannerData => _bannerData;
  Future fetchBanner(int categoryid) async {

    _isBannerLoading= true;

    var banner= await Webservice().fetchBanner(categoryid);
    if (banner != null) {
      _bannerData= banner.map((item) => BannerViewModel(data: item)).toList(); 
    }

    _isBannerLoading= false;
    notifyListeners();
  }
  void clearBanner() {
  _bannerData.clear();
 
  notifyListeners();
 }
////////////////////////////////////////
  bool _isHomeCatLoading= true;
  bool get isHomeCatLoading => _isHomeCatLoading;
  List<CategoryViewModel> _homeCategoryData= [];
  List<CategoryViewModel> get homeCategoryData => _homeCategoryData;
  Future<List<CategoryViewModel>> fetchHomeCategory(String searchkey, query) async {
    _isHomeCatLoading= true;
    final results = await Webservice().fetchCategory(searchkey, query);
    _homeCategoryData =
        results!.map((item) => CategoryViewModel(data: item)).toList();
    // log(_categoryData.length.toString());
    _isHomeCatLoading= false;
    notifyListeners();
    return _homeCategoryData;
  }
  
  bool _isCatLoading= true;
  bool get isCatLoading => _isCatLoading;
  List<CategoryViewModel> _categoryData= [];
  List<CategoryViewModel> get categoryData => _categoryData;
  Future<List<CategoryViewModel>> fetchCategory(int page, String isclear) async {
  try {
    log("calling isclear getProductitems==============$isclear");
    if (isclear == "home") {
      hasNextPage = true;
    } else if (isclear == "viewall") {
      if (hasNextPage == false) {
        hasNextPage = true;
      }
    }

    _isCatLoading = true;
    log("calling ==================getProductitems==============$hasNextPage");

    if (hasNextPage == true) {
      final results = await Webservice().fetchCategory("", page);
      List<CategoryViewModel> nextPage =
          results!.map((item) => CategoryViewModel(data: item)).toList();
      if (nextPage.isNotEmpty) {
        _categoryData.addAll(nextPage);
        log("rrrrrrrrrrr ================================================");

        _isCatLoading = false;
      } else {
        log("no page ==================");
        hasNextPage = false;
      }
    }
  } catch (e) {
    print('Error: $e');
  }
  notifyListeners();
  return _categoryData;
}
  bool _isSearchCatLoading= true;
  bool get isSearchCatLoading => _isSearchCatLoading;
  List<CategoryViewModel> _searchCategoryData= [];
  List<CategoryViewModel> get searchCategoryData => _searchCategoryData;

   Future<List<CategoryViewModel>> fetchSearchcategory(
      int page, String keyString, String cc) async {
    try {
      log("calling getSearchCategoryitems============================");
      log("page getSearchCategoryitems ==================$page");

      if (cc == "ccc") {
        hasNextPage = true;
      } else if (cc == "vv") {
        if (hasNextPage == false) {
          hasNextPage = true;
        }
      }

      if (hasNextPage == true) {
        _isSearchCatLoading = true;
        final results = await Webservice().fetchCategory(keyString, page);
        List<CategoryViewModel> nextPage =
            results!.map((item) => CategoryViewModel(data: item)).toList();
        log("nextPage length ================${nextPage.length}");
        if (nextPage.isNotEmpty) {
          checking = false;
          this._searchCategoryData =
              results.map((item) => CategoryViewModel(data: item)).toList();

          _isSearchCatLoading = false;
        } else {
          log("no page ==================");
          hasNextPage = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();

    return _searchCategoryData;
  }

  bool _isSubCatLoading= true;
  bool get isSubCatLoading => _isSubCatLoading;
  List<SubcategoryViewModel> _subcategoryData= [];
  List<SubcategoryViewModel> get subcategoryData => _subcategoryData;
  Future<List<SubcategoryViewModel>> fetchSubcategory(int page, String isclear, int categoryid) async {
    try {
      log("calling isclear getProductitems==============$isclear");
      if (isclear == "home") {
        hasNextPage = true;
      } else if (isclear == "viewall") {
        if (hasNextPage == false) {
          hasNextPage = true;
        }
      }

      _isSubCatLoading = true;
      log("calling ==================getProductitems==============$hasNextPage");

      if (hasNextPage == true) {
        final results = await Webservice().fetchSubcategory("", page, categoryid);
        List<SubcategoryViewModel> nextPage =
            results!.map((item) => SubcategoryViewModel(data: item)).toList();
        if (nextPage.isNotEmpty) {
          _subcategoryData.addAll(nextPage);
          log("rrrrrrrrrrr ================================================");

          _isSubCatLoading = false;
        } else {
          log("no page ==================");
          hasNextPage = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
    return _subcategoryData;
  }
  bool _isSearchSubCatLoading= true;
  bool get isSearchSubCatLoading => _isSearchSubCatLoading;
  List<SubcategoryViewModel> _searchSubcategoryData= [];
  List<SubcategoryViewModel> get searchSubcategoryData => _searchSubcategoryData;
  Future<List<SubcategoryViewModel>> fetchSearchSubcategory(
      int page, String keyString, String cc, int categoryid) async {
    try {
      log("calling getSearchCategoryitems============================");
      log("page getSearchCategoryitems ==================$page");

      if (cc == "ccc") {
        hasNextPage = true;
      } else if (cc == "vv") {
        if (hasNextPage == false) {
          hasNextPage = true;
        }
      }

      if (hasNextPage == true) {
        _isSearchSubCatLoading = true;
        final results = await Webservice().fetchSubcategory(keyString, page, categoryid);
        List<SubcategoryViewModel> nextPage =
            results!.map((item) => SubcategoryViewModel(data: item)).toList();
        log("nextPage length ================${nextPage.length}");
        if (nextPage.isNotEmpty) {
          checking = false;
          this._searchSubcategoryData =
              results.map((item) => SubcategoryViewModel(data: item)).toList();

          _isSearchSubCatLoading = false;
        } else {
          log("no page ==================");
          hasNextPage = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();

    return _searchSubcategoryData;
  }
  void clearSubcategory() {
  _subcategoryData.clear();
 
  notifyListeners();
  }

   //selected items
  FromplaceViewModel? _fromplaceModel;
  FromplaceViewModel? get fromplaceModel => _fromplaceModel;
  ToplaceViewModel? _toplaceModel;
  ToplaceViewModel? get toplaceModel => _toplaceModel;
  
  bool _fromPlaceLoading= true;
  bool get fromPlaceLoading => _fromPlaceLoading;
  List<FromplaceViewModel> _fromPlaceData= [];
  List<FromplaceViewModel> get fromPlaceData => _fromPlaceData;
  bool _toPlaceLoading= true;
  bool get toPlaceLoading => _toPlaceLoading;
  List<ToplaceViewModel> _toPlaceData= [];
  List<ToplaceViewModel> get toPlaceData => _toPlaceData;
  
  set fromplaceModel(FromplaceViewModel? value) {
    _fromplaceModel = value;
    notifyListeners();
  }
  set toplaceModel(ToplaceViewModel? value) {
    _toplaceModel = value;
    notifyListeners();
  }

  Future fetchDropdownItems1() async {
    _fromPlaceLoading= true;
    var fromPlace= await Webservice().fetchDropdownItems1();
    if (fromPlace != null) {
      _fromPlaceData= fromPlace.map((item) => FromplaceViewModel(data: item)).toList(); 
    }
    _fromPlaceLoading= false;
    notifyListeners();
  }

  Future fetchDropdownItems2(int placeid) async {
    if (_fromplaceModel != null) {
    _toPlaceLoading= true;
    var toPlace= await Webservice().fetchDropdownItems2(placeid);
    if (toPlace != null) {
      _toPlaceData= toPlace.map((item) => ToplaceViewModel(data: item)).toList(); 
    }
    _toPlaceLoading= false;
    } else {
     null; 
    }
    
    notifyListeners();
  }

  bool _isBustimeLoading= true;
  bool get isBustimeLoading => _isBustimeLoading;
  List<BusServiceViewModel> _busData= [];
  List<BusServiceViewModel> get busData => _busData;
  
  Future fetchBusServices(int? allocationid) async {
    if (_toplaceModel != null) {
    _isBustimeLoading= true;
    var bus= await Webservice().fetchBusServices(allocationid);
    if (bus != null) {
      _busData= bus.map((item) => BusServiceViewModel(data: item)).toList(); 
    }
    _isBustimeLoading= false;
    } else {
     null; 
    }
   
    notifyListeners();
  }
//////////////
  bool _isServiceLoading= true;
  bool get isServiceLoading => _isServiceLoading;
  List<ServiceViewModel> _serviceData= [];
  List<ServiceViewModel> get serviceData => _serviceData;
  ServiceViewModel? _serviceModel;
  ServiceViewModel? get serviceModel => _serviceModel;

  bool isFetchWithImages(int categoryid) {
  const noImageCategories = {11, 13, 14, 15, 16, 17, 18, 19};
  return !noImageCategories.contains(categoryid);
   }
 
    Future<List<ServiceViewModel>> fetchServcie(int page, String isclear, int categoryid) async {
    try {
      log("calling isclear getProductitems==============$isclear");
      if (isclear == "home") {
        hasNextPage = true;
      } else if (isclear == "viewall") {
        if (hasNextPage == false) {
          hasNextPage = true;
        }
      }

      _isServiceLoading = true;
      log("calling ==================getProductitems==============$hasNextPage");

      if (hasNextPage == true) {
      List<ServiceViewModel> nextPage;
        if (isFetchWithImages(categoryid)) {
      
        final _results = await Webservice().fetchService("", page, categoryid);
        nextPage= _results.map((item) => ServiceViewModel(data: item)).toList();
     
          } else {
          
            final _results = await Webservice().fetchService("", page, categoryid, isImageNull: true);
            nextPage= _results.map((item) => ServiceViewModel(data: item)).toList();
          }
        if (nextPage.isNotEmpty) {
          _serviceData.addAll(nextPage);
          log("rrrrrrrrrrr ================================================");

          _isServiceLoading = false;
        } else {
          log("no page ==================");
          hasNextPage = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
    return _serviceData;
  }
  bool _isSearchServiceLoading= true;
  bool get isSearchServiceLoading => _isSearchServiceLoading;
  List<ServiceViewModel> _searchServiceData= [];
  List<ServiceViewModel> get searchServiceData => _searchServiceData;
 
  Future<List<ServiceViewModel>> fetchSearchService(
      int page, String keyString, String cc, int categoryid) async {
    try {
      log("calling getSearchCategoryitems============================");
      log("page getSearchCategoryitems ==================$page");

      if (cc == "ccc") {
        hasNextPage = true;
      } else if (cc == "vv") {
        if (hasNextPage == false) {
          hasNextPage = true;
        }
      }

      if (hasNextPage == true) {
        _isSearchServiceLoading = true;
        List<ServiceViewModel> nextPage;
      if (isFetchWithImages(categoryid)) {
    
        final _results = await Webservice().fetchService(keyString, page, categoryid);
       nextPage= _results.map((item) => ServiceViewModel(data: item)).toList();
          } else {
          
            final _results = await Webservice().fetchService(keyString, page, categoryid, isImageNull: true);
            nextPage= _results.map((item) => ServiceViewModel(data: item)).toList();
          }
        log("nextPage length ================${nextPage.length}");
        if (nextPage.isNotEmpty) {
          checking = false;
          final _results = await Webservice().fetchService(keyString, page, categoryid);
          this._searchServiceData =
              _results.map((item) => ServiceViewModel(data: item)).toList();

          _isSearchServiceLoading = false;
        } else {
          log("no page ==================");
          hasNextPage = false;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();

    return _searchServiceData;
  }
  // void clearService() {
  // _serviceData = [];
 
  // notifyListeners();
  // }
/////////////////
  bool _isEmergencyLoading= true;
  bool get isEmergencyLoading => _isEmergencyLoading;
  List<EmergencyViewModel> _emergencyData= [];
  List<EmergencyViewModel> get emergencyData => _emergencyData;
  Future fetchEmergencyService(int categoryid) async {
    _isEmergencyLoading= true;
    var emergency= await Webservice().fetchEmergencyService(categoryid);
    if (emergency != null) {
      _emergencyData= emergency.map((item) => EmergencyViewModel(data: item)).toList(); 
    }
    _isEmergencyLoading= false;
    notifyListeners();
  }


  bool _isBloodLoading= true;
  bool get isBloodloading => _isBloodLoading;
  List<BloodRadioTileViewModel> _bloodData= [];
  List<BloodRadioTileViewModel> get bloodData => _bloodData;
  Future fetchBloodRadiotile() async {
    _isBloodLoading= true;
    var blood= await Webservice().fetchBloodRadiotile();
    if (blood != null) {
      _bloodData= blood.map((item) => BloodRadioTileViewModel(data: item)).toList(); 
    }
    _isBloodLoading= false;
    notifyListeners();
  }
  
  Future<ResponseViewModel?> applyBlooddonation(name, mobile, area, bloodgrp, catid) async {
    ResponseViewModel? _response;
   final result= await Webservice().applyBlooddonation(name, mobile, area, bloodgrp, catid);
   _response= ResponseViewModel(data: result!);
   log('result in applyBloodDonation: $result');
   notifyListeners();
   return _response;
  }
///////////
  bool _isUserDataLoading= true;
  bool get isUserDataLoading => _isUserDataLoading;
  UserViewModel? _userModel;
  UserViewModel? get userModel => _userModel;

  Future loadUser() async {
    _isUserDataLoading= true;


    String? username = await Store.getUsername();
    if (username != null) {
      var user= await Webservice().fetchUser(username.toString());
      _userModel= UserViewModel(data: user);
    }

    _isUserDataLoading= false;
    // log(json.encode(_userModel));
    notifyListeners();
  }
  /////
  Future <ResponseViewModel?> register(name, mobile) async {
   ResponseViewModel? _response;
   final result= await Webservice().signup(name, mobile);
   _response= ResponseViewModel(data: result!);
   log('result in register: $result');
   notifyListeners();
   return _response;
   
  }

  Future<ResponseViewModel?> login(mobile) async {
  ResponseViewModel? _response;
  final result= await Webservice().login(mobile);
  _response= ResponseViewModel(data: result!);
  log('result in login controller: $result');
  notifyListeners();
  return _response;
  }
}