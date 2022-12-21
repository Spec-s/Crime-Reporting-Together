// ignore_for_file: prefer_const_constructors

import 'package:crimereporting/constants/routes.dart';
import 'package:crimereporting/views/Welcome.dart';
import 'package:crimereporting/views/bottom_navigation.dart';
import 'package:crimereporting/views/forget_password.dart';
import 'package:crimereporting/views/loginview.dart';
import 'package:crimereporting/views/registration_view.dart';
import 'package:crimereporting/views/verify_email.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),

      // routes are used to let the application be aware of a builder widget
      //which will be used further into the application.
      //Always remember to add routes to this part so it can take effect on the entire program
      routes: {
        loginroute: (context) => const LoginView(),
        registerroute: (context) => const RegisterView(),
        homepageroute: (context) => const BottomNav(),
        verifyEmailroute: (context) => const VerifyEmail(),
        forgetpasswordroute: (context) => const ForgetPassword(),
        welcomepageroute: (context) => const WelcomePage(),
      },
    );
  }
}
