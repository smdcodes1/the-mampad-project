import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/blood_bank_screen/blood_donor_screen.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/view_model/subcategory_view_model.dart';




class BloodScreen extends StatefulWidget {
  BloodScreen({super.key, required this.catid});
 final int catid;

  @override
  State<BloodScreen> createState() => _BloodScreenState();
}

class _BloodScreenState extends State<BloodScreen> {
  int activeIndex = 0;
  final ScrollController _scrollController = ScrollController();
  int productCurrentpage = 1;
  int searchProductCurrentpage = 1;
  List<SubcategoryViewModel> _searchItems = [];
  List<SubcategoryViewModel> _searchpaginationItems = [];
  bool isSearch = false;
  bool isloading = true;
  bool searchscroll = false;
  bool testing = false;
  String? enteredKeywords;

  ApiProvider? vm;
  @override
  void initState() {
    vm= Provider.of(context, listen: false);
    // _apiProvider!.clearBanner();
    vm!.subcategoryData.clear();
    vm!
      .fetchSubcategory(productCurrentpage, "viewall", widget.catid)
      .then((value) => _searchItems = value)
      .then((value) => isloading = false);
    vm!.fetchBanner(widget.catid);
    vm!.fetchSearchSubcategory(1, "", "ccc", widget.catid);
    _scrollController.addListener(_onScroll);
    super.initState();
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
        itemViewModel.fetchSubcategory(productCurrentpage, '', widget.catid);
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
          itemViewModel.fetchSearchSubcategory(
              searchProductCurrentpage, enteredKeywords!, "ccc", widget.catid);
          _searchpaginationItems.addAll(vm!.searchSubcategoryData);
        }
      }
    }
  }
  void _runFilter(String enteredKeyword) {
    isSearch = true;
    testing = true;
    vm = Provider.of<ApiProvider>(context, listen: false);

    List<SubcategoryViewModel> results = [];
    List<SubcategoryViewModel> searchresults = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearch = false;
      });

      results = vm!.subcategoryData;
    } else {
      setState(() {
        enteredKeywords = enteredKeyword;
      });

      log("qqq----$enteredKeyword");

      if (testing) {
        log("testing value === $testing");
        vm!
            .fetchSearchSubcategory(1, enteredKeyword, "ccc", widget.catid)
            .then((value) => searchresults = vm!.searchSubcategoryData
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: Text(
          'Blood Bank',
          style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
              fontFamily: 'Poppins',),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => 
            HomeScreen(),));
          }, 
          icon: const Icon(Icons.arrow_back_rounded)),
        actions: [
          IconButton(onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => 
              HomeScreen(),));
          },
           icon: const Icon(Icons.home_filled, 
           color: Color(0xFF151E3D),)),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics:const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
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
                      // cursorColor: primaryTextColor,
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
           Consumer<ApiProvider>(builder: (context, value, child) {
             return value.isBannerLoading ? const Center(child: CircularProgressIndicator())
             : CarouselSlider.builder(
                itemCount: value.bannerData.length,
                itemBuilder: (context, index, realIndex) {
                  final urlImage = value.bannerData[index].image;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Image.network(
                      "https://mampadbusiness.cyralearnings.com/bannerimages/" + urlImage.toString(),
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 190,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    // setState(() {
                    //   activeIndex = index;
                    // });
                  },
                ));
           },),
           
            // const SizedBox(
            //   height: 32,
            // ),
            // AnimatedSmoothIndicator(
            //     activeIndex: activeIndex, 
            //     count: _images.length, 
            //     effect: WormEffect(dotHeight: 9, dotWidth: 9),),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: InkWell(
            //     onTap: () {
               
            //     Navigator.push(context, MaterialPageRoute(builder: (context) => 
            //     BloodDonateScreen(),));
            //     },
            //     child: Card(
            //         elevation: 0,
            //         color: Color.fromARGB(223, 227, 239, 255),
            //         shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(6)),
            //         child: SizedBox(
            //           height: 100,
            //           // width: MediaQuery.of(context).size.width,
            //           child: Row(
            //             children: [
            //               Padding(
            //                 padding: const EdgeInsets.only(left: 3),
            //                 child: Container(
            //                   height: 90,
            //                   width: 90,
            //                   decoration: BoxDecoration(
            //                       color: Colors.transparent,
            //                       borderRadius: BorderRadius.circular(23),
            //                       image: const DecorationImage(
            //                           image: AssetImage(
            //                               'assets/images/blood1.jpg'),
            //                           fit: BoxFit.contain)),
            //                 ),
            //               ),
            //               Flexible(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(6.0),
            //                   child: Wrap(
            //                     children: [
            //                       Padding(
            //                         padding: const EdgeInsets.all(3.0),
            //                         child: Text(
            //                           'DONATE BLOOD, SAVE A LIFE',
            //                           maxLines: 1,
            //                           overflow: TextOverflow.ellipsis,
            //                           style: TextStyle(
            //                               fontSize: 15,
            //                               color: Color(0xFFFF151E3D),
            //                               fontWeight: FontWeight.w900,
            //                               fontFamily: 'Poppins', 
            //                               ),
            //                         ),
            //                       ),
            //                       Padding(
            //                         padding: const EdgeInsets.only(
            //                             left: 3.0, right: 3.0),
            //                         child: Row(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Text(
            //                               "If you interested, click here\n& enter your details ..",
                                          
            //                               style: TextStyle(
            //                                   fontSize: 13,
            //                                   color: Colors.redAccent,
            //                                   fontFamily: 'Poppins', 
            //                                   ),
            //                             ),
            //                             Icon(
            //                               Icons.trending_flat_outlined,
            //                               color: Colors.blueGrey,
            //                               // size: 26,
            //                             ),
            //                           ],
            //                         ),
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         )),
            //   ),
            // ),
         Consumer<ApiProvider>(builder: (context, value, child) {
                     return isloading == true
           ? const Center(child:  Text("Loading .. "))
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
                       : StaggeredGrid.count(
         crossAxisCount: 3, 
         children: List.generate(value.subcategoryData.length, (index) {
           return InkWell(
             onTap: () {
           
              //  value.fetchService(value.subcategoryData[index].id!);
               Navigator.push(context, MaterialPageRoute(builder: (context) => 
               BloodDonorScreen(
                catname: value.subcategoryData[index].category.toString(), 
                catid: value.subcategoryData[index].id!,),)).then((isReset) {
               if (isReset == true) {
               // _apiProvider!.clearService();
                 value.clearBanner();
                 value.fetchBanner(widget.catid);
               }
               });
             },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
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
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Center(
                         child: Container(
                       decoration: BoxDecoration(
                         color: Colors.transparent,
                         borderRadius: BorderRadius.circular(9),
                       ),
                       child: Image(image: NetworkImage(
                         'https://mampadbusiness.cyralearnings.com/categoryimage/' + value.subcategoryData[index].image.toString(),
                       ),
                       height: 60,
                       fit: BoxFit.contain,
                       )
                     )),
                     const SizedBox(height: 10.0),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8),
                       child: Text(
                         value.subcategoryData[index].category.toString(),
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           fontFamily: 'Poppins',
                         ),
                         textAlign: TextAlign.left,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8),
                       child: Text(
                         value.subcategoryData[index].totalItems.toString() + " items",
                         style: TextStyle(
                           fontSize: 14, 
                           color: Colors.grey,
                           fontFamily: 'Poppins', 
                           ),
                         textAlign: TextAlign.left,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 2,
                       ),
                     ),
                     const SizedBox(height: 5.0),
                   ],
                 ),
               ),
             ),
           );
         }),
         )
               : _searchItems.isEmpty
                   ? const Center(child: Text("No data"))
                   : StaggeredGrid.count(
         crossAxisCount: 3, 
         children: List.generate(value.subcategoryData.length, (index) {
           return InkWell(
             onTap: () {
           
              //  value.fetchService(value.subcategoryData[index].id!);
               Navigator.push(context, MaterialPageRoute(builder: (context) => 
               BloodDonorScreen(
                catname: value.subcategoryData[index].category.toString(), 
                catid: value.subcategoryData[index].id!,),)).then((isReset) {
               if (isReset == true) {
               // _apiProvider!.clearService();
                 value.clearBanner();
                 value.fetchBanner(widget.catid);
               }
               });
             },
             child: Padding(
               padding: const EdgeInsets.all(8.0),
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
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     Center(
                         child: Container(
                       decoration: BoxDecoration(
                         color: Colors.transparent,
                         borderRadius: BorderRadius.circular(9),
                       ),
                       child: Image(image: NetworkImage(
                         'https://mampadbusiness.cyralearnings.com/categoryimage/' + value.subcategoryData[index].image.toString(),
                       ),
                       height: 60,
                       fit: BoxFit.contain,
                       )
                     )),
                     const SizedBox(height: 10.0),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8),
                       child: Text(
                         value.subcategoryData[index].category.toString(),
                         style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontSize: 16.0,
                           fontFamily: 'Poppins',
                         ),
                         textAlign: TextAlign.left,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 1,
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8),
                       child: Text(
                         value.subcategoryData[index].totalItems.toString() + " items",
                         style: TextStyle(
                           fontSize: 14, 
                           color: Colors.grey,
                           fontFamily: 'Poppins', 
                           ),
                         textAlign: TextAlign.left,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 2,
                       ),
                     ),
                     const SizedBox(height: 5.0),
                   ],
                 ),
               ),
             ),
           );
         }),
         );
                   })
          ],
        ),
      ),
    );
  }
}
