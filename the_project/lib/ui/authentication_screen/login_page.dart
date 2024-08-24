
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:the_project/class_shared.dart';
import 'package:the_project/ui/authentication_screen/otp.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/widgets/my_button.dart';
import 'package:the_project/widgets/my_formfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  GlobalKey<FormState> _formkey = GlobalKey();

  final TextEditingController _controllerPhone = TextEditingController();
  @override
  void initState() {
  _checkSession().then((value) {
  if (isLoggedIn == true) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
  }
    });
  super.initState();
  }

  late final bool? isLoggedIn;

  Future<void> _checkSession() async {
  isLoggedIn= await Store.getLoggedIn();
  
  log(isLoggedIn.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Sign - In',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 19, 
                    fontFamily: 'Poppins',),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Enter Your Valid Phone number ..\nWe will Send you One Time Password\n( OTP )',
                style: TextStyle(
                  color: Colors.grey.shade900, 
                  fontFamily: 'Poppins',),
              ),
            ),
            const SizedBox(
              height: 90,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  editingcontroller: _controllerPhone,
                  leadingicon: Icon(Icons.call),
                  hinttext: 'Enter Phone Number',
                  labeltext: 'Enter Phone Number',
                  obscuretext: false, 
                  maxLength: 10,),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyButton(
                  text: 'GET OTP',
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
               
                    Store.setLoggedIn(true);
                   
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                    verifyOtpPage(phoneNumber: _controllerPhone.text),));
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
