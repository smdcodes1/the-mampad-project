import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/view_model/service_view_model.dart';
import 'package:url_launcher/url_launcher.dart';


class ViewServiceScreen extends StatefulWidget {
 ViewServiceScreen({super.key, required this.catid, required this.catname});
 final int catid;
 final String catname;

  @override
  State<ViewServiceScreen> createState() => _ViewServiceScreenState();
}

class _ViewServiceScreenState extends State<ViewServiceScreen> {
 

  int activeIndex= 0;
  final ScrollController _scrollController = ScrollController();
  int productCurrentpage = 1;
  int searchProductCurrentpage = 1;
  List<ServiceViewModel> _searchItems = [];
  List<ServiceViewModel> _searchpaginationItems = [];
  bool isSearch = false;
  bool isloading = true;
  bool searchscroll = false;
  bool testing = false;
  String? enteredKeywords;

  ApiProvider? vm;
  // BannerProvider? _bannerProvider;
  @override
  void initState() {
    vm= Provider.of<ApiProvider>(context, listen: false);
    vm!.serviceData.clear();
    // _apiProvider!.clearService();
    // _bannerProvider= Provider.of<BannerProvider>(context, listen: false);
   vm!.fetchBanner(widget.catid);
    vm!
    .fetchServcie(productCurrentpage, "viewall", widget.catid)
    .then((value) => _searchItems = value)
    .then((value) => isloading = false);
    vm!
    .fetchSearchService(1, "", "ccc", widget.catid);
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
        itemViewModel.fetchServcie(productCurrentpage, '', widget.catid);
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
          itemViewModel.fetchSearchService(
              searchProductCurrentpage, enteredKeywords!, "ccc", widget.catid);
          _searchpaginationItems.addAll(vm!.searchServiceData);
        }
      }
    }
  }
  void _runFilter(String enteredKeyword) {
    isSearch = true;
    testing = true;
    vm = Provider.of<ApiProvider>(context, listen: false);

    List<ServiceViewModel> results = [];
    List<ServiceViewModel> searchresults = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        isSearch = false;
      });

      results = vm!.serviceData;
    } else {
      setState(() {
        enteredKeywords = enteredKeyword;
      });

      log("qqq----$enteredKeyword");

      if (testing) {
        log("testing value === $testing");
        vm!
            .fetchSearchService(1, enteredKeyword, "ccc", widget.catid)
            .then((value) => searchresults = vm!.searchServiceData
                .where((item) => item.servicename!
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
            
            Navigator.pop(context, true);
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
      ),
    body: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
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
          // const SizedBox(height: 10,),
         Consumer<ApiProvider>(builder: (context, value, child) {
          if (value.bannerData.isEmpty) {
            return const SizedBox();
          }
           return value.isBannerLoading ? const Center(child: CircularProgressIndicator())
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
              //   activeIndex= index;
              // });
            },
          )),
          //  const SizedBox(height: 24,),
          //  AnimatedSmoothIndicator(
          //   activeIndex: activeIndex, 
          //   count: snapshot.data!.length, 
          //   effect: WormEffect(dotHeight: 9, dotWidth: 9),
          //   ),
            ],
          );
         },),
         
          const SizedBox(height: 10,),
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
                        ? const Center(child: Text("No data available"))
                        : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: value.serviceData.length,
                      itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: ListTile(
                leading: value.serviceData[index].image != null ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    image: DecorationImage(image: NetworkImage("https://mampadbusiness.cyralearnings.com/serviceimage/" + value.serviceData[index].image!),
                     fit: BoxFit.fill)
                  ),
                
                ) : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                dense: true,
              title: Text(
               value.serviceData[index].servicename.toString(), 
               style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Poppins',),
                
                ),
              subtitle: Text(
               value.serviceData[index].area.toString(), 
               style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.normal, 
                fontFamily: 'Poppins',),
             
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                onTap: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: value.serviceData[index].phonenumber.toString());
                  if (!await launchUrl(phoneUri)) {
                    throw 'Could not launch $phoneUri';
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade50,
                  child: Center(child: Icon(Icons.phone_outlined, color: Color(0xFF151E3D),)),),
              ),
               const SizedBox(width: 3,),
              InkWell(
                      onTap: () async {
                      //  final result= await Share.shareWithResult('Name: ${value.serviceData[index].servicename}\nBlood Grp: ${widget.catname}\nArea: ${value.serviceData[index].area}');
                      // log(result.status.toString());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade50,
                        child: const Icon(Icons.share, color: Color(0xFF151E3D),)
                      ),
                    ),
                ],
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide.none,
              ),
              // onTap: () {},
              ),
            ),
          );
                      },)
                : _searchItems.isEmpty
                    ? const Center(child: Text("No data available"))
                    : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      itemCount: value.serviceData.length,
                      itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: ListTile(
                leading: value.serviceData[index].image != null ? Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    image: DecorationImage(image: NetworkImage("https://mampadbusiness.cyralearnings.com/serviceimage/" + value.serviceData[index].image!),
                     fit: BoxFit.fill)
                  ),
                
                ) : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                dense: true,
              title: Text(
               value.serviceData[index].servicename.toString(), 
               style: TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontFamily: 'Poppins',),
                
                ),
              subtitle: Text(
               value.serviceData[index].area.toString(), 
               style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.normal, 
                fontFamily: 'Poppins',),
             
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                onTap: () async {
                  final Uri phoneUri = Uri(scheme: 'tel', path: value.serviceData[index].phonenumber.toString());
                  if (!await launchUrl(phoneUri)) {
                    throw 'Could not launch $phoneUri';
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey.shade50,
                  child: Center(child: Icon(Icons.phone_outlined, color: Color(0xFF151E3D),)),),
              ),
               const SizedBox(width: 3,),
              InkWell(
                      onTap: () async {
                      //  final result= await Share.shareWithResult('Name: ${value.serviceData[index].servicename}\nBlood Grp: ${widget.catname}\nArea: ${value.serviceData[index].area}');
                      // log(result.status.toString());
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blueGrey.shade50,
                        child: const Icon(Icons.share, color: Color(0xFF151E3D),)
                      ),
                    ),
                ],
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide.none,
              ),
              // onTap: () {},
              ),
            ),
          );
                      },);
                    })
        ],
      ),
    ),
    );
  }
}