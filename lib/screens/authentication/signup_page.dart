import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../utils/app_images.dart';
import './login_page.dart';
import '../screenHome/homeScreen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with SingleTickerProviderStateMixin {

  /*----------------------------------------- Animation -------------------------------------------------*/
  late AnimationController _iconAnimationController;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _iconAnimation = CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(() => setState(() {}));
    _iconAnimationController.forward();
  }
  /*--------------------------------------------- Animation ---------------------------------------------*/

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String msg = '';
  bool _isLoading = false;

  //form key
  final _formKey = GlobalKey<FormState>();

  //password visible method
  bool _obSecureText = true;
  void _toggle() {
    setState(() {
      _obSecureText = !_obSecureText;
    });
  }

  void _signup() async {
      showToast('sign up success');
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const MainPage()), (Route<dynamic> route) => false);
      // var jsonData = null;
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); //local url is http://192.168.43.206/flutter/signupUser.php
      // final response = await http.post("https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/signupUser.php", body: {
      //   'username': usernameController.text.trim(),
      //   'email': emailController.text.trim(),
      //   'password': passwordController.text.trim(),
      // });
      //
      // if (response.statusCode == 200) {
      //   jsonData = json.decode(response.body);
      //   print(jsonData);
      //   if(jsonData[0]['msg'] == 'UserExist') {
      //     setState(() {
      //       _isLoading = false;
      //       msg = 'User Already Exist!';
      //       showToast();
      //       //should clear all data fields
      //     });
      //   }else if(jsonData[0]['msg'] == 'false'){
      //     _isLoading = false;
      //     msg = 'Server Connection Error!';
      //     showToast();
      //   }else{
      //     setState(() {
      //       _isLoading = false;
      //       sharedPreferences.setString('session_username', jsonData[0]['username']);
      //       sharedPreferences.setString('session_email', jsonData[0]['email']);
      //       msg = 'SignUp & LogIn Successful';
      //       showToast();
      //     });
      //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => NavigationDrawer()), (Route<dynamic> route) => false);
      //   }
      // }else{
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   msg = 'System Error!';
      //   showToast();
      //   print(response.body);
      // }
  }

  //lording dialog method
  Future<void> loadingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
//          title: Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: Row(
              children: const <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
                Text('  Please wait...'),
              ],
            ),
          ),
          /*actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],*/
        );
      },
    );
  }

  //toast msg method
  void showToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          const Image(
            image: AssetImage(AppImages.backgroundImg),
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.darken,
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Image(
                  image: const AssetImage(AppImages.logoTW),
                  width: _iconAnimation.value * 120,
                  height: _iconAnimation.value * 120,
                ),
                Form(
                  key: _formKey,
                  child: Theme(
                    data: ThemeData(
                      brightness: Brightness.dark,
                      primarySwatch: Colors.teal,
                      inputDecorationTheme: const InputDecorationTheme(
                        labelStyle: TextStyle(
                          color: Colors.teal,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            controller: usernameController,
                            decoration: const InputDecoration(
                              labelText: "User Name",
                            ),
                            keyboardType: TextInputType.text,
//                            maxLength: 12,
                            validator: (val) => validateUsername(val!),
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) => validateEmail(val!),
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _toggle();
                                },
                                child: _obSecureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: _obSecureText,
                            validator: (val) => validatePassword(val!),
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: "Confirm Password",
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            validator: (val) => validateConfirmPassword(val!),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 40.0),
                          ),
                          MaterialButton(
                            height: 50.0,
                            minWidth: 1000.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: const Text(
                              "SIGNUP",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _signup();
                              }
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 60.0),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Already SignUp? LogIn",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: !_isLoading ? null :
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Please wait...',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //username validate method
  validateUsername(String username) {
    if (username.trim().isEmpty){
      return "User Name is required!";
    }else if (username.trim().length < 3) {
      return "Number of characters must be less than 3";
    }else{
      return null;
    }
  }

  //email validate method
  validateEmail(String email) {
    RegExp regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email.trim().isEmpty){
      return "Email is required!";
    }else if(!regExp.hasMatch(email)){
      return "Invalid Email!";
    }else{
      return null;
    }
  }

  //password validate method
  validatePassword(String password) {
//    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//    RegExp regExp = new RegExp(pattern);
    if (password.trim().isEmpty){
      return "Password is required!";
    }
//    else if(!regExp.hasMatch(password)) {
//      return "Week Password";
//    }
    else{
//      RegExp hasUppercase = RegExp(r'[A-Z]');
//      RegExp hasLowercase = RegExp(r'[a-z]');
//      RegExp hasDigit = RegExp(r'[0-9]');
//      RegExp hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//      if (!hasUppercase.hasMatch(password)) {
//        return "Uppercase Required!";
//      }else if (!hasLowercase.hasMatch(password)) {
//        return "Lowercase Required!";
//      }else if (!hasDigit.hasMatch(password)) {
//        return "Digit Required!";
//      }else if (!hasSpecialCharacter.hasMatch(password)) {
//        return "Special Character Required!";
//      }else if (password.trim().length < 6) {
//        return "6 Characters Required Minimum!";
//      }else {
        return null;
//      }
    }
  }

  //confirmPassword validate method
  validateConfirmPassword(String rePassword) {
    if (rePassword.trim().isEmpty){
      return "Confirm Password is required!";
    }else if (passwordController.text.trim() != rePassword.trim()) {
      return "Password does not matched!";
    }else{
      return null;
    }
  }

}
