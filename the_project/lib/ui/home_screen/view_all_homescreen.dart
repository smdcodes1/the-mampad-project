import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/blood_bank_screen/blood_screen.dart';
import 'package:the_project/ui/bus_services_screen/bus_screen.dart';
import 'package:the_project/ui/emergency_screen/emergency_screen.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/ui/view_category_screen/view_category_screen.dart';
import 'package:the_project/view_model/category_view_model.dart';

class HomeScreenNew extends StatefulWidget {
  const HomeScreenNew({super.key});

  @override
  State<HomeScreenNew> createState() => _HomeScreenNewState();
}

class _HomeScreenNewState extends State<HomeScreenNew> {
  final ScrollController _scrollController = ScrollController();
  int productCurrentpage = 1;
  int searchProductCurrentpage = 1;
  List<CategoryViewModel> _searchItems = [];
  List<CategoryViewModel> _searchpaginationItems = [];
  bool isSearch = false;
  bool isloading = true;
  bool searchscroll = false;
  bool testing = false;
  String? enteredKeywords;
  
  
  @override
 void initState() {
    super.initState();
    Provider.of<ApiProvider>(context, listen: false).categoryData.clear();
    Provider.of<ApiProvider>(context, listen: false)
        .fetchCategory(productCurrentpage, "viewall")
        .then((value) => _searchItems = value)
        .then((value) => isloading = false);
    Provider.of<ApiProvider>(context, listen: false)
        .fetchSearchcategory(1, "", "ccc");
    _scrollController.addListener(_onScroll);
    _searchItems= Provider.of<ApiProvider>(context, listen: false).categoryData;
    _searchpaginationItems= Provider.of<ApiProvider>(context, listen: false).searchCategoryData;
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _onScroll() {
    log("qqqqqqqqqqqqqqqqqqqqqqqqqqq---$isSearch");
    if (isSearch == false) {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        productCurrentpage++;
        var itemViewModel =
            Provider.of<ApiProvider>(context, listen: false);
        itemViewModel.fetchCategory(productCurrentpage, '');
      }
      // productCurrentpage = 1;
    } else {
      log("serch addd");
      if (vm!.checking == true) {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          searchProductCurrentpage++;
          var itemViewModel =
              Provider.of<ApiProvider>(context, listen: false);
          itemViewModel.fetchSearchcategory(
              searchProductCurrentpage, enteredKeywords!, "ccc");
          _searchpaginationItems.addAll(vm!.searchCategoryData);
        }
      }
    }
  }
  ApiProvider? vm;
  void _runFilter(String enteredKeyword) {
     isSearch = true;
     testing = true;
    vm = Provider.of<ApiProvider>(context, listen: false);

    List<CategoryViewModel> results = [];
    List<CategoryViewModel> searchresults = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearch = false;
      });

      results = vm!.categoryData;
    } else {
      setState(() {
        enteredKeywords = enteredKeyword;
      });

      log("qqq----$enteredKeyword");

      if (testing) {
        log("testing value === $testing");
        vm!
            .fetchSearchcategory(1, enteredKeyword, "ccc")
            .then((value) => searchresults = vm!.searchCategoryData
                .where((item) => item.category!
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
                .toList())
            .then((value) {
          setState(() {
            _searchpaginationItems = searchresults;
          });
        }).then((value) {
          setState(() {
            testing = false;
          });
        });
      }
    }

    setState(() {
      _searchItems = results;
    });
    log("_searchpaginationItems == ${_searchpaginationItems.length}");

    log("dddddddddddddddd == $isSearch");
  }
//  void _runFilter(String enteredKeyword) {
//   vm = Provider.of<ApiProvider>(context, listen: false);

//   List<CategoryViewModel> results = [];
//   List<CategoryViewModel> searchresults = [];

//   if (enteredKeyword.isEmpty) {
//     log("No keyword entered. Showing all category data.");

//     // Show the entire categoryData without filtering
//     setState(() {
//       _searchItems = vm!.categoryData;
//     });
//   } else {
//     log("Entered keyword: $enteredKeyword");

//     // Fetch and show search results for the current keyword
//     vm!.fetchSearchcategory(1, enteredKeyword, "ccc").then((value) {
//       searchresults = vm!.searchCategoryData;

//       setState(() {
//         _searchpaginationItems = searchresults;
//       });

//       // Store the entered keyword for future use
//       setState(() {
//         enteredKeywords = enteredKeyword;
//       });
//     });
//   }

//   log("_searchpaginationItems count: ${_searchpaginationItems.length}");
//   log("Search active: $isSearch");
// }


  @override
  Widget build(BuildContext context) {
    vm = Provider.of<ApiProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: Text(
          'HOME',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Poppins'),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xffE8E8E8),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
            HomeScreen(),));
          }, 
          icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100),
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                   Flexible(
                        child: TextFormField(
                      // cursorColor: Colors.grey.shade600,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Search',
                      ),
                      onChanged: (value) {
                        _searchpaginationItems.clear();
                        searchProductCurrentpage = 1;
                        _runFilter(value);
                      },
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.filter_alt_outlined,
                    color: Colors.grey.shade600,)
                  ],
                ),
              ),
            ),
          ),
            Consumer<ApiProvider>(builder: (context, category, child) {
              
            return isloading == true
                ? const Center(child: Text("Loading .. "))
                // LoadServicesWidget(
                //     page: "ss",
                //   )
                : isSearch == true
                    ? testing == true
                        ? const Center(child: Text("Loading .. "))
                        // LoadServicesWidget(
                        //     page: "ss",
                        //   )
                        : _searchpaginationItems.isEmpty
                        ? const Center(child: Text("No data"))
                        :  StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(category.categoryData.length, (index) {
                      final routelist= category.categoryData[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                        
                          if (routelist.isBus == 1) {
                            category.fetchDropdownItems1();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BusScreen(),));
                          } else if (routelist.isBloodbank == 1) {
                            // value.fetchBanner(value.categoryData[index].id);
                            // value.fetchSubcategory(value.categoryData[index].id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BloodScreen(catid: category.categoryData[index].id!),));
                          } else if (routelist.emergency == 1) {
                            category.fetchEmergencyService(category.categoryData[index].id!);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            EmergencyScreeen(),));
                          } else {
                            // value.fetchBanner(value.categoryData[index].id);
                            // value.fetchSubcategory(value.categoryData[index].id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            ViewCategoryScreen(catid: category.categoryData[index].id!,
                              catname: category.categoryData[index].category.toString()),));
                          }
                           
                          },
                          child: Container(
                            height: 160,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            // padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage("https://mampadbusiness.cyralearnings.com/categoryimage/" + category.categoryData[index].image.toString()),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  category.categoryData[index].category.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5.0),
                                category.categoryData[index].totalItems != 0
                                ? Text(
                                  category.categoryData[index].totalItems.toString() + ' items',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                    : _searchItems.isEmpty
                    ? const Center(child: Text("No data"))
                    :  StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(category.searchCategoryData.length, (index) {
                      final routelist= category.searchCategoryData[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                        
                          if (routelist.isBus == 1) {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BusScreen(),));
                          } else if (routelist.isBloodbank == 1) {
                            // value.fetchBanner(value.categoryData[index].id);
                            // value.fetchSubcategory(value.categoryData[index].id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BloodScreen(catid: category.categoryData[index].id!),));
                          } else if (routelist.emergency == 1) {
                            category.fetchEmergencyService(category.categoryData[index].id!);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            EmergencyScreeen(),));
                          } else {
                            // value.fetchBanner(value.categoryData[index].id);
                            // value.fetchSubcategory(value.categoryData[index].id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            ViewCategoryScreen(catid: category.categoryData[index].id!,
                              catname: category.categoryData[index].category.toString()),));
                          }
                           
                          },
                          child: Container(
                            height: 160,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            // padding: EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage("https://mampadbusiness.cyralearnings.com/categoryimage/" + category.categoryData[index].image.toString()),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  category.searchCategoryData[index].category.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 5.0),
                                category.searchCategoryData[index].totalItems != 0
                                ? Text(
                                  category.searchCategoryData[index].totalItems.toString() + ' items',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontFamily: 'Poppins',
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ) : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                      }),
          ],
        ),
      ),
    );
  }
}
