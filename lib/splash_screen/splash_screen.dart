import 'package:findmotto/Assistants/assistant_methods.dart';
import 'package:findmotto/global/global.dart';
import 'package:findmotto/screens/login_screen.dart';
import 'package:findmotto/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  startTimer(){
    Timer(Duration(seconds: 3), () async{
      if(await firebaseAuth.currentUser != null){
        firebaseAuth.currentUser != null ? AssistantMethods.readCurrentOnlineUserInfo(): null;
        Navigator.push(context, MaterialPageRoute(builder: (c) => Mainscreen()));
      } 
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();

  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'FindMotto',

          style:  TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,

          ),
        ),
      ),
    );
  }
}