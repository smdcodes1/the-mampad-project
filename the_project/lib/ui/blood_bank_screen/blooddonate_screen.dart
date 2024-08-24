import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/widgets/blood_radiotile_widget.dart';
import 'package:the_project/widgets/my_button.dart';
import 'package:the_project/widgets/my_formfield.dart';

class BloodDonateScreen extends StatefulWidget {
  BloodDonateScreen({super.key});

  @override
  State<BloodDonateScreen> createState() => _BloodDonateScreenState();
}

class _BloodDonateScreenState extends State<BloodDonateScreen> {
  // BloodRadioTileModel? _bloodRadioTileModel;

  String? radioButtonItem;

  int? id;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerArea = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey();


  ApiProvider? _apiProvider;
  @override
 void initState() {
    _apiProvider= Provider.of<ApiProvider>(context, listen: false);
    _apiProvider!.fetchBloodRadiotile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        title: Text(
          'BLOOD DONATION',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xffE8E8E8),
        actions: [
         IconButton(
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => 
              HomeScreen(),));
          }, 
          icon:  const Icon(
            Icons.home_filled,
            color: Color(0xFF151E3D),
          ),)
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics:const BouncingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: MyFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    editingcontroller: _controllerName,
                    leadingicon: Icon(Icons.person),
                    hinttext: 'Enter your Name',
                    labeltext: 'Enter your Name',
                    obscuretext: false),
              ),
              const SizedBox(
                height: 10,
              ),
             Consumer<ApiProvider>(builder: (context, value, child) {
               return value.isBloodloading ? const Center(child: CircularProgressIndicator())
               : MasonryGridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                crossAxisCount: 2, 
                itemCount: value.bloodData.length,
                itemBuilder: (context, index) {
           
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: BloodRadioTileWidget(
                      value: value.bloodData[index].id!, 
                      id: id, 
                      onChanged: (val) {
                        setState(() {
                            radioButtonItem = value.bloodData[index].category.toString();
                            id = val!;
                          });
                   
                      }, 
                      title: Text(
                          value.bloodData[index].category.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ), 
                      color:const Color(0xFF151E3D)),
                  );
                },);
             },),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your mobile';
                      }
                      return null;
                    },
                    editingcontroller: _controllerPhone,
                    leadingicon: Icon(Icons.call),
                    hinttext: 'Enter your Phone Number',
                    labeltext: 'Enter your Phone Number',
                    obscuretext: false, 
                    maxLength: 10,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your area!!';
                    }
                    return null;
                  },
                  controller: _controllerArea,
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelText: 'Enter your Area',
                    hintText: 'Enter your Area',
                    prefixIcon: const Icon(Icons.location_on_sharp),
                    labelStyle: const TextStyle(fontFamily: 'Poppins'),
                    hintStyle: const TextStyle(fontFamily: 'Poppins'),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                  obscureText: false,
                  maxLines: 3,
                ),
              ),
              // if(_bloodRadioTileModel != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                    text: 'SUBMIT',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // log('name; ' + radioButtonItem.toString());
                        // log('name; ' + id.toString());
                        context.read<ApiProvider>()
                        .applyBlooddonation( 
                         _controllerName.text, 
                         _controllerPhone.text, 
                         _controllerArea.text, 
                         radioButtonItem.toString(), 
                         id).then((response) {
                          if (response!.msg == "success") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                            HomeScreen(),));
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Successfull!'),
                              backgroundColor: Color.fromARGB(255, 175, 5, 152),
                              ));
                             log("Blood grp added");
                          } else {
                               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Failed!'),
                              backgroundColor: Color.fromARGB(255, 175, 5, 152),));
                              log('Blood grp Not added');
                          }
                         });
               
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
