// ignore_for_file: prefer_const_constructors

import 'package:crimereporting/constants/routes.dart';
import 'package:crimereporting/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/verified.png'),
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(
            //this give padding to the text and keep it symmetrical on all screen
            horizontal: 30,
            vertical: 50,
          ),
          child: Column(children: [
            Text(
              "We've already sent an email verification, please check your email and click the link to verify your email",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "if you haven't recieve the email verification, please check your spam",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Yours Truly, Admin",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 15),
            TextButton(
              onPressed: () async {
                AuthService.firebase().sendEmailVerification();
              },
              child: const Text(
                'Send email verification',
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(height: 180),
            TextButton(
              onPressed: () async {
                await AuthService.firebase().logout();
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushNamedAndRemoveUntil(
                  welcomepageroute,
                  (route) => false,
                );
              },
              child: const Text(
                'Return to Home',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
