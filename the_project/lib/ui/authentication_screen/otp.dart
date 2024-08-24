import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/class_shared.dart';
import 'package:the_project/ui/authentication_screen/login_page.dart';
import 'package:the_project/ui/authentication_screen/register_page.dart';
import 'package:the_project/ui/home_screen/home_screen.dart';
import 'package:the_project/widgets/my_button.dart';

class verifyOtpPage extends StatefulWidget {
 verifyOtpPage({super.key, required this.phoneNumber});
 String phoneNumber;

  @override
  State<verifyOtpPage> createState() => _verifyOtpPageState();
}

class _verifyOtpPageState extends State<verifyOtpPage> {


  final TextEditingController _pinputController= TextEditingController();
  // String? pinnumber;
  String validPin= '123456';
  GlobalKey<FormState> _formKey= GlobalKey();
  

  int _secondsRemaining= 60;
  Timer? _timer;
  @override
  void initState() {
   startTimer();
    super.initState();
  }
  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_secondsRemaining < 1) {
          timer.cancel();
          
        } else {
          _secondsRemaining--;
        }
      });
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8E8E8),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                 const SizedBox(height: 110,),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Text('OTP Verification',
                      style: TextStyle(
                        fontWeight: FontWeight.w600, 
                        color: Colors.black, 
                        fontSize: 19, 
                        fontFamily: 'Poppins',),),
                   ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Enter the verification code we just sent on your phone number', 
                      style: TextStyle(
                        color: Colors.grey.shade900, 
                        fontFamily: 'Poppins',),),
                    ),
                    const SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text('+91 ' + widget.phoneNumber, 
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
                    const SizedBox(height: 20,),
              
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Pinput(
                        length: 6,
                        defaultPinTheme: PinTheme(
                          height: 50,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF151E3D),
                            ),
                          ),
                          textStyle: TextStyle(
                            color: Colors.black, 
                            fontWeight: FontWeight.w900), 
                        ),
                        controller: _pinputController,
                        pinAnimationType: PinAnimationType.fade,
                        validator: (value) {
                        
                          if (value!.isEmpty || value != validPin) {
                            return "Invalid Pin";
                          }
                          return null;
                        },
                        onCompleted: (pin) {
                          log('success: $pin');
                        },
                        errorBuilder: (errorText, pin) {
                          return Padding(padding: const EdgeInsets.symmetric(vertical: 10), 
                          child: Center(child: Text(errorText ?? "", 
                          style: const TextStyle(color: Colors.red),),),);
                        },
                        // onChanged: (pin) {
                        //   setState(() {
                        //     pinnumber= pin;
                        //   });
                        // },
                      ),
                    ),
                    // const SizedBox(height: 20,),
                    Text('Time remaining: $_secondsRemaining seconds', 
                    style: TextStyle(fontSize: 15, 
                    color: Colors.grey.shade900, 
                    fontFamily: 'Poppins'),),
                    const SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: MyButton(
                    text: 'VERIFY', 
                    onPressed: () {
                     if (_formKey.currentState!.validate()) {
                      // verifyOTP(_pinputController.text);
                      context.read<ApiProvider>()
                      .login(widget.phoneNumber).then((response) {
                       if (response!.msg == "success") {
                          Store.setUsername(widget.phoneNumber);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                          HomeScreen(),));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Login Successfull!'),
                            backgroundColor: Color.fromARGB(255, 175, 5, 152),
                            ));
                       } else {
                             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                              RegisterPage(phoneNumber: widget.phoneNumber),));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Login Failed!'),
                              backgroundColor: Color.fromARGB(255, 175, 5, 152),));
                              log('login failed..');
                       }
                      });

                     } 
                    
                    }),
                ),
                const SizedBox(height: 10,),
                _secondsRemaining == 0
                ? TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
                    LoginPage(),));
                  },
                  child: Text('Resend OTP', 
                  style: TextStyle(
                    color: Colors.grey.shade900, 
                    fontFamily: 'Poppins',),),)
                : Text('Resend OTP', 
                  style: TextStyle(color: Colors.grey.shade900, 
                  fontFamily: 'Poppins'),),
                ],
              ),
            ),
            Positioned(
              left: 15,
              top: 33,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffE8E8E8),
                  shape: BoxShape.circle,
                ),
              child: Center(child: 
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                }, 
                icon: Icon(Icons.arrow_back, 
                color: Colors.black,))),
              ))
          ],
        ),
      ),
    );
  }
}