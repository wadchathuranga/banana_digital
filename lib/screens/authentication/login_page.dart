import 'dart:convert';

import 'package:banana_digital/services/auth_api_service.dart';
import 'package:banana_digital/services/shared_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/User.dart';
import '../../utils/app_configs.dart';
import '../../utils/app_images.dart';
import '../../main.dart';
import './signup_page.dart';
import './reset_password.dart';
import '../screenHome/homeScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {

  /*----------------------------------------- Icon Animation -------------------------------------------------*/
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
  /*----------------------------------------- Icon Animation --------------------------------------------------*/


  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

  void _login() async {
   try {
     var url = Uri.parse(USER_SIGN_IN);
     final response = await http.post(
         url,
         headers: {
           "Content-Type": "application/json"
         },
         body: jsonEncode({
           "client_id": CLIENT_ID,
           "client_secret": CLIENT_SECRET,
           "grant_type": GRANT_TYPE,
           "username": usernameController.text.trim(),
           "password": passwordController.text.trim(),
         }));

     if (response.statusCode == 200) {
       final decodedData = jsonDecode(response.body);
       UserSharedPreference.setAccessToken(decodedData['access_token']);
       print('========== Access Token: ${decodedData['access_token']} ==========');

       var url = Uri.parse(USER_PROFILE_GET);
       final userRes = await http.get(
           url,
           headers: {
             "Content-Type": "application/json",
             "Authorization": "Bearer ${decodedData['access_token']}",
           });

       if (userRes.statusCode == 200) {
         final decodedUserData = User.fromJson(jsonDecode(userRes.body));
         await UserSharedPreference.setUserName(decodedUserData.userName!);
         await UserSharedPreference.setEmail(decodedUserData.email!);
         await UserSharedPreference.setFirstName(decodedUserData.firstName!);
         await UserSharedPreference.setLastName(decodedUserData.lastName!);
         if (decodedUserData.profilePic != null) {
           await UserSharedPreference.setProPic(decodedUserData.profilePic!);
         }

         setState(() {
           _isLoading = false;
         });
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const MainPage()), (Route<dynamic> route) => false);
         showToast('login success');
       } else {
          final error = jsonDecode(userRes.body);
          setState(() {
            _isLoading = false;
          });
          showToast(error['detail'].toString());
       }
     } else if (response.statusCode == 400) {
       final res = jsonDecode(response.body);
       setState(() {
         _isLoading = false;
       });
       showToast(res['error_description'].toString());
     } else {
       setState(() {
         _isLoading = false;
       });
       showToast('System Error!');
     }
   } catch (err) {
     setState(() {
       _isLoading = false;
     });
     showToast(err.toString());
     if (kDebugMode) {
       print("================= Catch Error ====================");
       print(err);
       print("==================================================");
     }
   }
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
          Image(
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
                  image: AssetImage(AppImages.logoTW),
                  width: _iconAnimation.value * 120,
                  height: _iconAnimation.value * 120,
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
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
                            keyboardType: TextInputType.text,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Username Required!";
                              }
                              else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              labelText: "Email",
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: _obSecureText,
                            validator: (val) => validatePassword(val!),
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _toggle();
                                },
                                child: _obSecureText ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                              ),
                            ),
                          ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               TextButton(
//                                   onPressed: () {
//                                     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ResetPasswordScreen()));
//                                   },
//                                   child: const Text("Forgot Password?",
//                                     style: TextStyle(
// //                                  fontSize: 20.0,
//                                       color: Colors.teal,
//                                     ),
//                                   ),
//                               ),
//                             ],
//                           ),
                          const Padding(
                            padding: EdgeInsets.only(top: 25.0),
                          ),
                          MaterialButton(
                            height: 50.0,
                            minWidth: 1000.0,
                            color: Colors.teal,
                            textColor: Colors.white,
                            child: const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                _login();
                              }
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 60.0),
                          ),
                          GestureDetector(
                            child: const Text(
                              "New User? SignUp",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const SignupScreen()));
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
                  // CircularProgressIndicator(),
                  SpinKitRing(
                    color: Colors.white,
                    size: 40.0,
                  ),
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

  //email validate method
  validateEmail(String email) {
    RegExp regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email.trim().isEmpty){
      return "Email is required!";
    }else if(!regExp.hasMatch(email)){
      return "Invalid Email Format!";
    }else{
      return null;
    }
  }

  //password validate method
  validatePassword(String password) {
    if (password.trim().isEmpty){
      return "Password is required!";
    }else{
      return null;
    }
  }
  
}
