
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/class_shared.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/widgets/my_button.dart';
import 'package:the_project/widgets/my_formfield.dart';


class RegisterPage extends StatelessWidget {
 RegisterPage({super.key, required this.phoneNumber});
 

  GlobalKey<FormState> _formKey= GlobalKey(); 
  final TextEditingController _controllerName= TextEditingController();
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {}, 
            child: Text('SKIP', 
            style: TextStyle(
              color: const Color(0xFF151E3D), 
              fontWeight: FontWeight.bold, 
              fontFamily: 'Poppins',),)),
        ],
      elevation: 0,
      backgroundColor: const Color(0xffE8E8E8),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 24, 
                        fontFamily: 'Poppins',),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Enter your Details to create account !',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade900, 
                      fontFamily: 'Poppins',),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                    hinttext: 'Enter Name', 
                    labeltext: 'Enter Name', 
                    obscuretext: false
                    ),
                ),
            
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyButton(
                    text: 'SIGN UP', 
                    onPressed: () {
                     if (_formKey.currentState!.validate()) {
                      // print('name; '+ _controllerName.text);
                      // Store.setname(_controllerName.text);
                      Store.setUsername(phoneNumber);
                      Provider.of<ApiProvider>(context, listen: false)
                      .register(_controllerName.text, phoneNumber).then((response) {
                        if (response!.msg == "success") {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => 
                              HomeScreen(),));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Registration Successfull!'),
                                backgroundColor: Color.fromARGB(255, 175, 5, 152),
                                ));
                            } else if(response!.msg == "exists") {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('User already exists'),
                              backgroundColor: Color.fromARGB(255, 175, 5, 152),));
                              log('User already exists');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Registration Failed!'),
                              backgroundColor: Color.fromARGB(255, 175, 5, 152),));
                              log('Registraion failed..');
                            }
                      });
                      
                       
                     }
                      
                    }),
                ),
                const SizedBox(
                  height: 10,
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                //   child: RichText(
                //     text: TextSpan(
                //       text: "Already have an account? ",
                //       children: [
                //         TextSpan(
                //           text: 'Sign in',
                //           style: TextStyle(color: Colors.blueAccent),
                //           recognizer: TapGestureRecognizer()
                //             ..onTap = () {
                //               Navigator.push(context, MaterialPageRoute(builder: (context) => 
                //               LoginPage()));
                //             },
                //         )
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}