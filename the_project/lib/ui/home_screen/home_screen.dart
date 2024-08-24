
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/class_shared.dart';
import 'package:the_project/ui/authentication_screen/login_page.dart';
import 'package:the_project/ui/blood_bank_screen/blood_screen.dart';
import 'package:the_project/ui/blood_bank_screen/blooddonate_screen.dart';
import 'package:the_project/ui/bus_services_screen/bus_screen.dart';
import 'package:the_project/ui/emergency_screen/emergency_screen.dart';
import 'package:the_project/ui/home_screen/view_all_homescreen.dart';
import 'package:the_project/ui/view_category_screen/view_category_screen.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // String? name;
  // bool _isMounted = true;
  
  int activeIndex = 0;

  ApiProvider? _apiProvider;
  @override
  void initState() {
    _loadUser();
    _apiProvider= Provider.of<ApiProvider>(context, listen: false);
    _apiProvider!.fetchBanner(0);
    _apiProvider!.fetchHomeCategory('', '1');
    super.initState();
  }

   Future<void> _loadUser() async {
    _apiProvider = Provider.of<ApiProvider>(context, listen: false);
    await _apiProvider!.loadUser();
  }


  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
      
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
          
            Consumer<ApiProvider>(builder: (context, value, child) {
              return value.isBannerLoading ? const Center(child: CircularProgressIndicator())
              : Column(
                    children: [
                      CarouselSlider.builder(
                          itemCount: value.bannerData.length,
                          itemBuilder: (context, index, realIndex) {
                            final urlImage = value.bannerData[index].image;
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                'https://mampadbusiness.cyralearnings.com/bannerimages/' +
                                    urlImage.toString(),
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 190,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            onPageChanged: (index, reason) {
                              setState(() {
                                activeIndex = index;
                              });
                            },
                          )),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: AnimatedSmoothIndicator(
                          activeIndex: activeIndex,
                          count: value.bannerData.length,
                          effect: WormEffect(dotHeight: 9, dotWidth: 9),
                        ),
                      ),
                    ],
                  );
            },),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                'Information about Mampad',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Poppins'),
              ),
              TextButton(
               onPressed: () {
                // _apiProvider!.fetchHomeCategory('', '1');
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                HomeScreenNew(),));
               },
               child: Text(
              'View All', 
              style: TextStyle(
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Poppins'),
               ),
              )
                ],
              )
            ),
          Consumer<ApiProvider>(builder: (context, value, child) {
            // log(value.categoryData.length.toString());
            return value.isHomeCatLoading ? const Center(child: CircularProgressIndicator())
            : StaggeredGrid.count(
                    crossAxisCount: 3,
                    children: List.generate(value.homeCategoryData.length, (index) {
                      final routelist= value.homeCategoryData[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                        
                          if (routelist.isBus == 1) {
                            value.fetchDropdownItems1();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BusScreen(),));
                          } else if (routelist.isBloodbank == 1) {
                            // value.fetchBanner(value.homeCategoryData[index].id!);
                            // value.fetchSubcategory(value.homeCategoryData[index].id!);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            BloodScreen(catid: value.homeCategoryData[index].id!),));
                          } else if (routelist.emergency == 1) {
                            value.fetchEmergencyService(value.homeCategoryData[index].id!);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            EmergencyScreeen(),));
                          } else {
                            // value.fetchBanner(value.categoryData[index].id);
                            // value.fetchSubcategory(value.categoryData[index].id);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => 
                            ViewCategoryScreen(catid: value.homeCategoryData[index].id!,
                              catname: value.homeCategoryData[index].category.toString()),));
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
                                        image: NetworkImage("https://mampadbusiness.cyralearnings.com/categoryimage/" + value.homeCategoryData[index].image.toString()),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  value.homeCategoryData[index].category.toString(),
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
                                value.homeCategoryData[index].totalItems != 0
                                ? Text(
                                  value.homeCategoryData[index].totalItems.toString() + ' items',
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
          },),
          ],
        ),
      ),
      drawer: Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
          
            Consumer<ApiProvider>(builder: (context, value, child) {
            if (value.userModel == null) {
              return Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF151E3D),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 10,),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "GUEST ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ));
            }
              return value.isUserDataLoading
              ? const Center(child: CircularProgressIndicator())
             
              : Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                color: const Color(0xFF151E3D),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        value.userModel!.name.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 10,),
                     Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        value.userModel!.phone.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: 22,
                          fontFamily: 'Poppins',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ));
            },),
           
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text(
                'Bus Services',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                _apiProvider!.fetchDropdownItems1();
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                BusScreen(),));
              },
            ),
            ListTile(
              title: Text(
                'Blood Donation Form',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => 
                BloodDonateScreen(),));
              },
            ),
      
            const Divider(
              color: Colors.black45,
            ),
            ListTile(
              title: Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'About',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  letterSpacing: 0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Store.setLoggedIn(false).then((value) => Store.clear());
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              },
            )
          ],
        ),
      ),
          ),
    );
  }
}
