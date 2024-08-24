
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyScreeen extends StatefulWidget {
  EmergencyScreeen({super.key});
  // final int catid;

  @override
  State<EmergencyScreeen> createState() => _EmergencyScreeenState();
}

class _EmergencyScreeenState extends State<EmergencyScreeen> {
  // late Future<List<EmergencyModel>> futureService1;

  // @override
  // void initState() {
  //   futureService1 = Webservice().fetchEmergencyService(widget.catid);
  //   //  futureService2= Webservice().fetchEmergencyService(5);
  //   //  futureService3= Webservice().fetchEmergencyService(5);
  //   super.initState();
  // }
 
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: Text(
          'Emergency',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => 
            HomeScreen(),));
          }, 
          icon:const Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => 
                 HomeScreen(),));
              },
              icon: const Icon(
                Icons.home_filled,
                color: Color(0xFF151E3D),
              )),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Consumer<ApiProvider>(builder: (context, value, child) {
          return value.isEmergencyLoading ? const Center(child: CircularProgressIndicator())
          : Column(
                  children: List.generate(
                value.emergencyData.length,
                (index) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                   _firstSection(
                    value.emergencyData[index].category.toString()),
        
                   ...List.generate(value.emergencyData[index].service!.length, (index1) {
                    return _secondSection(
                      value.emergencyData[index].service![index1].servicename, 
                      value.emergencyData[index].service![index1].area, 
                      value.emergencyData[index].service![index1].phonenumber.toString());
                  },),
                  ],
                  
                ),
              ));
        },)
      ),
    );
  }
  Widget _firstSection (String title) {
     return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          foreground: Paint()
                            ..shader = LinearGradient(colors: <Color>[
                              Colors.pinkAccent,
                              Colors.deepPurpleAccent,
                              Colors.red
                            ]).createShader(Rect.fromLTWH(0.0, 0.0, 350, 300))),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    ),
                  );
    }
  Widget _secondSection (String title, String subtitle, String phoneNumber) {
    return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                    side: BorderSide.none,
                  ),
                  title: Text(
                  title, 
                  style: TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold, 
                    fontFamily: 'Poppins',),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    ),
                  subtitle: Text(
                  subtitle, 
                  style: TextStyle(
                    color: Colors.grey, 
                    fontFamily: 'Poppins',),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    ),
                  trailing: InkWell(
                    onTap: () async {
                       final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
                        if (!await launchUrl(phoneUri)) {
                          throw 'Could not launch $phoneUri';
                        }
                    },
                    child: CircleAvatar(backgroundColor: Colors.blueGrey.shade50,
                     child: Center(child: Icon(Icons.call_outlined, color: Color(0xFF151E3D),)),),
                  ),
                tileColor: Colors.white,
                ),
              ),
            );
  }
}

