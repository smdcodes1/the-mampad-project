import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/view_model/service_view_model.dart';
import 'package:url_launcher/url_launcher.dart';


class BloodDonorScreen extends StatefulWidget {
 BloodDonorScreen({super.key, required this.catname, required this.catid});
 final int catid;
 final String catname;
  @override
  State<BloodDonorScreen> createState() => _BloodDonorScreenState();
}

class _BloodDonorScreenState extends State<BloodDonorScreen> {
  //  int activeIndex= 0;
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
  @override
  void initState() {
    vm!.serviceData.clear();
    // _apiProvider!.clearService();
    // futureBanner= Webservice().fetchBanner(widget.catid);
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
        leading: IconButton(
          onPressed: () {
           Navigator.pop(context, true);
          }, 
          icon:const Icon(Icons.arrow_back_rounded)),
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
      
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Column(
            
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
            // FutureBuilder(
            //   future: futureBanner, 
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //     return CarouselSlider.builder(
            //     itemCount: snapshot.data!.length, 
            //     itemBuilder: (context, index, realIndex) {
            //       final urlImage= snapshot.data![index].image;
            //       return Container(
            //         margin: const EdgeInsets.symmetric(horizontal: 3),
                    
            //         decoration: BoxDecoration(
            //          color: Colors.grey,
            //          borderRadius: BorderRadius.circular(9),
            //         ),
            //         child: Image.network(
            //          "https://mampadbusiness.cyralearnings.com/bannerimages/" + urlImage,
            //          fit: BoxFit.cover,
            //         ),
            //       );
            //     }, 
            //     options: CarouselOptions(
            //       height: 110,
            //       enlargeCenterPage: true,
            //       enlargeStrategy: CenterPageEnlargeStrategy.height,
            //       onPageChanged: (index, reason) {
            //         // setState(() {
            //         //   activeIndex= index;
            //         // });
            //       },
            //     ));
            //     } else {
            //       return Center(child: CircularProgressIndicator());
            //     }
            //   },),
            //     const SizedBox(height: 32,),
            // AnimatedSmoothIndicator(
            //   activeIndex: activeIndex, 
            //   count: _images.length, 
            //   effect: WormEffect(dotHeight: 9, dotWidth: 9),
            //   ),
            // const SizedBox(height: 10,),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8),
              //   child: InkWell(
              //     onTap: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => BloodDonateScreen(),
              //           ));
              //     },
              //     child: Card(
              //         elevation: 0,
              //         color: Color.fromARGB(223, 227, 239, 255),
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(6)),
              //         child: SizedBox(
              //           height: 100,
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
              //                       image: DecorationImage(
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
              //                               fontFamily: 'Poppins',),
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
              //                               // size: 30,
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
            // if(context.read<ApiProvider>().serviceModel != null) 
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
                          : Column(
              children: List.generate(value.serviceData.length, (index) {
               return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide.none,
                    ),
                    leading: value.serviceData[index].image != null ? Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage("https://mampadbusiness.cyralearnings.com/serviceimage/" + value.serviceData[index].image!),
                       fit: BoxFit.fill)
                    ),
                  
                  ) : null,
                    // contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    // dense: true,
                    title: Text(
                    value.serviceData[index].servicename.toString(), 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      fontFamily: 'Poppins',),),
                      subtitle: Text(
                      value.serviceData[index].area.toString(), 
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      ),
                      tileColor: Colors.white,
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
                              child: const Center(child: Icon(Icons.phone_outlined, color: Color(0xFF151E3D),)),),
                          ),
                         const SizedBox(width: 3,),
                          InkWell(
                            onTap: () async {
                             final result= await Share.shareWithResult('Name: ${value.serviceData[index].servicename}\nBlood Grp: ${widget.catname}\nArea: ${value.serviceData[index].area}');
                            log(result.status.toString());
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade50,
                              child: const Icon(Icons.share, color: Color(0xFF151E3D),)
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              );
              })
            )
                  : _searchItems.isEmpty
                      ? const Center(child: Text("No data available"))
                      : Column(
              children: List.generate(value.serviceData.length, (index) {
               return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Colors.transparent,
                  elevation: 0,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide.none,
                    ),
                    leading: value.serviceData[index].image != null ? Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage("https://mampadbusiness.cyralearnings.com/serviceimage/" + value.serviceData[index].image!),
                       fit: BoxFit.fill)
                    ),
                  
                  ) : null,
                    // contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    // dense: true,
                    title: Text(
                    value.serviceData[index].servicename.toString(), 
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 16, 
                      fontFamily: 'Poppins',),),
                      subtitle: Text(
                      value.serviceData[index].area.toString(), 
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      ),
                      tileColor: Colors.white,
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
                              child: const Center(child: Icon(Icons.phone_outlined, color: Color(0xFF151E3D),)),),
                          ),
                         const SizedBox(width: 3,),
                          InkWell(
                            onTap: () async {
                             final result= await Share.shareWithResult('Name: ${value.serviceData[index].servicename}\nBlood Grp: ${widget.catname}\nArea: ${value.serviceData[index].area}');
                            log(result.status.toString());
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.blueGrey.shade50,
                              child: const Icon(Icons.share, color: Color(0xFF151E3D),)
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              );
              })
            );
                      })
            ],
          ),
        ),
      ),
    );
  }
}
