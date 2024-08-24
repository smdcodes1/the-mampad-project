import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/ui/view_category_screen/view_service_screen.dart';
import 'package:the_project/ui/view_category_screen/view_subcategory_screen.dart';
import 'package:the_project/view_model/subcategory_view_model.dart';


class ViewCategoryScreen extends StatefulWidget {
 ViewCategoryScreen({super.key, required this.catname, required this.catid});
final int catid;
final String catname;
  @override
  State<ViewCategoryScreen> createState() => _ViewCategoryScreenState();
}

class _ViewCategoryScreenState extends State<ViewCategoryScreen> {

  int activeIndex= 0;
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
    vm!.subcategoryData.clear();
    vm!.fetchBanner(widget.catid);
    vm!
    .fetchSubcategory(productCurrentpage, "viewall", widget.catid)
    .then((value) => _searchItems = value)
    .then((value) => isloading = false);
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
          widget.catname,
          style: TextStyle(
              color: Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 16, 
              fontFamily: 'Poppins',),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
        leading: IconButton(
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => 
              HomeScreen(),));
          }, 
          icon:const Icon(Icons.arrow_back_rounded)),
        actions: [
          IconButton(
            onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => 
               HomeScreen(),));
            }, 
            icon: const Icon(Icons.home_filled, color: Color(0xFF151E3D),)),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics:const BouncingScrollPhysics(),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
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
              if (value.isBannerLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return value.bannerData.isEmpty ? const SizedBox()
              : Column(
            children: [
            CarouselSlider.builder(
            itemCount: value.bannerData.length, 
            itemBuilder: (context, index, realIndex) {
              final urlImage= value.bannerData[index].image;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                
                decoration: BoxDecoration(
                 color: Colors.grey,
                 borderRadius: BorderRadius.circular(9),
                ),
                child: Image.network(
                  'https://mampadbusiness.cyralearnings.com/bannerimages/' + urlImage.toString(),
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
                //   activeIndex= index;
                // });
         },
            )),
          //   const SizedBox(height: 24,),
          // AnimatedSmoothIndicator(
          //     activeIndex: activeIndex, 
          //     count: snapshot.data!.length, 
          //     effect: WormEffect(dotHeight: 9, dotWidth: 9),
          //     ),
                ],
              );
            },),
            const SizedBox(
              height: 10,
            ),
        Consumer<ApiProvider>(builder: (context, value, child) {
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
                      : StaggeredGrid.count(
                    crossAxisCount: 3, 
                    children: List.generate(value.subcategoryData.length, (index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
              value.subcategoryData[index].isSubcategory == 1
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => 
              ViewSubcategoryScreen(
                catid: value.subcategoryData[index].id!, 
                catname: value.subcategoryData[index].category.toString()),)).then((isReset) {
                 if (isReset == true) {
                   value.clearBanner();
                   value.clearSubcategory();
                   value.fetchBanner(widget.catid);
                   value
                    .fetchSubcategory(productCurrentpage, "viewall", widget.catid)
                    .then((value) => _searchItems = value)
                    .then((value) => isloading = false);
                 }
                })
              : Navigator.push(context, MaterialPageRoute(builder: (context) => 
               ViewServiceScreen(
                catid: value.subcategoryData[index].id!, 
                catname: value.subcategoryData[index].category.toString()),)).then((isReset) {
                   if (isReset == true) {
                    // value.clearService();
                     value.clearBanner();
                     value.fetchBanner(widget.catid);
                   }
                });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage('https://mampadbusiness.cyralearnings.com/categoryimage/' + value.subcategoryData[index].image.toString()),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
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
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        value.subcategoryData[index].totalItems.toString() + ' items',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
                    }),)
              : _searchItems.isEmpty
                  ? const Center(child: Text("No data"))
                  : StaggeredGrid.count(
                    crossAxisCount: 3, 
                    children: List.generate(value.subcategoryData.length, (index) {
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
              value.subcategoryData[index].isSubcategory == 1
              ? Navigator.push(context, MaterialPageRoute(builder: (context) => 
              ViewSubcategoryScreen(
                catid: value.subcategoryData[index].id!, 
                catname: value.subcategoryData[index].category.toString()),)).then((isReset) {
                 if (isReset == true) {
                   value.clearBanner();
                   value.clearSubcategory();
                   value.fetchBanner(widget.catid);
                   value
                    .fetchSubcategory(productCurrentpage, "viewall", widget.catid)
                    .then((value) => _searchItems = value)
                    .then((value) => isloading = false);
                 }
                })
              : Navigator.push(context, MaterialPageRoute(builder: (context) => 
               ViewServiceScreen(
                catid: value.subcategoryData[index].id!, 
                catname: value.subcategoryData[index].category.toString()),)).then((isReset) {
                   if (isReset == true) {
                    // value.clearService();
                     value.clearBanner();
                     value.fetchBanner(widget.catid);
                   }
                });
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage('https://mampadbusiness.cyralearnings.com/categoryimage/' + value.subcategoryData[index].image.toString()),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
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
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        value.subcategoryData[index].totalItems.toString() + ' items',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                        ),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
                    }),);
                  })
          ],
        ),
      ),
    );
  }
}
