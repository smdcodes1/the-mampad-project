import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_project/Provider/common_view_model.dart';
import 'package:the_project/ui/authentication_screen/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ApiProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // initialRoute: '/',
        // routes: {
        //   '/' :(context) => const LoginPage(),
        //   // '/otp' :(context) => verifyOtpPage(phoneNumber: ''),
        //   // '/create ac' :(context) => RegisterPage(phoneNumber: ),
        //   '/home' :(context) => HomeScreen(),
        //   '/bus' :(context) => BusScreen(),
        //   '/blood' :(context) => BloodScreen(),
        //   '/blood donation' :(context) => BloodDonateScreen(),
        //   // '/blood donor' :(context) => BloodDonorScreen(),
        //   '/emergency' :(context) => EmergencyScreeen(),
        //   '/medical' :(context) => MedicalScreen(),
        //   // '/medical store' :(context) => MedicalStoreScreen(),
        //   '/shopping' :(context) => const ShoppingScreen(),
        //   // '/food' :(context) => const FoodScreen(),

        // },
        home: const LoginPage(),
      ),
    );
  }
}
