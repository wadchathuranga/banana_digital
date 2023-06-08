import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../services/shared_preference.dart';
import './screenHome/homeScreen.dart';
import './authentication/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  // SharedPreferences sharedPreferences;
  // String username;
  // String email;

  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => checkLoginStatus(),
    );
  }

  //check user still logged in
  checkLoginStatus() async {
    //check user still logged in or not
    final token = UserSharedPreference.getAccessToken();
    if (kDebugMode) {
      print('========== Access Token: $token ==========');
    }
    if (token != null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const MainPage()), (Route<dynamic> route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
    }

    // sharedPreferences = await SharedPreferences.getInstance();
    // username = sharedPreferences.getString('session_username');
    // email = sharedPreferences.getString('session_email');
    // if(username == null && email == null) {
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
    // }else{
    //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()), (Route<dynamic> route) => false);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Image(
            image: AssetImage("assets/blue_background.jpg"),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white12,
                        child: Image(
                          width: 100,
                          height: 100,
                          image: AssetImage('assets/logoW.png'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text('Copyright @ www.bananadigital.com / alright received.', style: TextStyle(fontSize: 15, color: Colors.white30),)
            ],
          ),
        ],
      ),
    );
  }
}