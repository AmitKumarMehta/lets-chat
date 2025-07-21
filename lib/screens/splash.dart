import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lets_chat/auth/auth_page.dart';




class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3));
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Authpage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF87CEEB), // Sky Blue
              Color.fromARGB(255, 234, 179, 131),
            ], // Peach],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/chat.png',
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: MediaQuery.sizeOf(context).height / 3,
              ),
            ),
            Text('Lets Chat',style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}
