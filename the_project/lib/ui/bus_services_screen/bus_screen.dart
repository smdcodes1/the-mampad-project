
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/view_model/from_place_view_model.dart';
import 'package:the_project/view_model/toplace_view_model.dart';

class BusScreen extends StatefulWidget {
  BusScreen({super.key});

  @override
  State<BusScreen> createState() => _BusScreenState();
}

class _BusScreenState extends State<BusScreen> {
//  ApiProvider? _apiProvider;
 
//   @override
//   void initState() {
//     _apiProvider= Provider.of<ApiProvider>(context, listen: false);
//     _apiProvider!.fetchDropdownItems1();

//     super.initState();
//   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: Text(
          'Bus Services',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => 
            HomeScreen(),));
          }, 
          icon:const Icon(Icons.arrow_back_rounded)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
              },
              icon: const Icon(
                Icons.home_filled,
                color: Color(0xFF151E3D),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(19),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                  
                    Consumer<ApiProvider>(builder: (context, value, child) {
                      final _dropdownItems1= value.fromPlaceData;
                      //  if (_fromplaceModel == null && _dropdownItems1.isNotEmpty) {
                        //     _fromplaceModel = _dropdownItems1.first;
                        //       fetchDropdownItems2(_fromplaceModel!.id);
                        //       }
                      return value.fromPlaceLoading ? const Center(child: CircularProgressIndicator(strokeAlign: BorderSide.strokeAlignInside,))
                      : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<FromplaceViewModel>(
                              hint: const Text("Select a place"),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your place';
                                }
                                return null;
                              },
                              isExpanded: true,
                              value: value.fromplaceModel,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF151E3D),
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(
                                color: Color(0xFF151E3D),
                                fontFamily: 'Poppins',
                              ),
                              onChanged: (newValue) {
                                // _dropdownItems2.clear();

                                setState(() {
                                  value.toplaceModel = null;
                                  value.fromplaceModel = newValue!;
                                });
                                if (newValue != null) {
                                  value
                                      .fetchDropdownItems2(value.fromplaceModel!.id!);
                                }
                              },
                              items: _dropdownItems1
                                  .map<DropdownMenuItem<FromplaceViewModel>>((e) {
                                return DropdownMenuItem<FromplaceViewModel>(
                                  value: e,
                                  child: Text(e.places.toString()),
                                );
                              }).toList(),
                              selectedItemBuilder: (context) {
                                return _dropdownItems1.map<Widget>((e) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e.places.toString(),
                                      style: const TextStyle(
                                        color: Color(0xFF151E3D),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          );
                    },),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 0.8,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    
                  //  if(_fromplaceModel != null)
                    Consumer<ApiProvider>(builder: (context, value, child) {
                      final _dropdownItems2= value.toPlaceData;
                      return value.toPlaceLoading 
                      ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField(
                              hint: const Text('Select a place'),
                              value: null,
                              items: [],
                              onChanged: null,
                              style: const TextStyle(
                                color: Color(0xFF151E3D),
                                fontFamily: 'Poppins',
                              ),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ) 
                      : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField<ToplaceViewModel>(
                              hint: const Text('Select a place'),
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select your place';
                                }
                                return null;
                              },
                              isExpanded: true,
                              value: value.toplaceModel,
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF151E3D),
                              ),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                color: const Color(0xFF151E3D),
                                fontFamily: 'Poppins',
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  value.toplaceModel = newValue!;
                                });
                                if (newValue != null) {
                                  value.
                                  fetchBusServices(
                                    value.toplaceModel!.placeallocationId);
                                }
                              },
                              items: _dropdownItems2.isNotEmpty
                                  ? _dropdownItems2
                                      .map<DropdownMenuItem<ToplaceViewModel>>((e) {
                                      return DropdownMenuItem<ToplaceViewModel>(
                                        value: e,
                                        child: Text(e.places.toString()),
                                      );
                                    }).toList()
                                  : [
                                      const DropdownMenuItem<ToplaceViewModel>(
                                          value: null,
                                          child: Text("No items available")),
                                    ],
                              selectedItemBuilder: (context) {
                                return _dropdownItems2.map<Widget>((e) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      e.places.toString(),
                                      style: TextStyle(
                                        color: Color(0xFF151E3D),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              // onTap: () {
                              //   Webservice()
                              //   .fetchBusServices(
                              //       _toplaceModel!.placeallocationId);
                              // },
                            ),
                          );
                    },),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // if (_toplaceModel != null)
        
            Consumer<ApiProvider>(builder: (context, value, child) {
              return value.isBustimeLoading ? const Center(child: Text('No Data found'))
              : Column(
                    children: List.generate(value.busData.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: 160,
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 160,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF151E3D),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(9),
                                      bottomLeft: Radius.circular(9)),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  height: 160,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(9),
                                        bottomRight: Radius.circular(9)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              value.busData[index].fromplace.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                            const Icon(
                                              Icons.trending_flat_outlined,
                                              color: Colors.green,
                                              size: 30,
                                            ),
                                            Text(
                                              value.busData[index].toplace.toString(),
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          value.busData[index].description.toString(),
                                          style: TextStyle(
                                            color: Colors.lightGreen.shade600,
                                            fontFamily: 'Poppins',
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Container(
                                            height: 0.8,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        ...List.generate(
                                            value.busData[index].bustime!.length, (index1) {
                                          return _bustimeSection(
                                              value.busData[index].bustime![index1].busname,
                                              value.busData[index].bustime![index1].time);
                                        }),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                  );
            },),
          ],
        ),
      ),
    );
  }

  Widget _bustimeSection(String time, String busname) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          time,
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w400,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          '.................',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
        Text(
          busname,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        )
      ],
    );
  }
}
