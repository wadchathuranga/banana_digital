import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../services/auth_api_service.dart';
import '../../services/shared_preference.dart';
import '../../models/User.dart';
import '../../services/google_api_service.dart';
import '../../utils/app_images.dart';
import '../../main.dart';
import '../chat_screen/TextWidget.dart';
import './signup_page.dart';


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
     final response = await AuthApiService.userLogin(usernameController.text.trim(), passwordController.text.trim());

     if (response.statusCode == 200) {
       final decodedData = jsonDecode(response.body);
       UserSharedPreference.setAccessToken(decodedData['access_token']);
       if (kDebugMode) {
         print('========== Login Access Token: ${decodedData['access_token']} ==========');
       }

       final userRes = await AuthApiService.userProfile(decodedData['access_token']);

       if (userRes.statusCode == 200) {
         final decodedUserData = User.fromJson(jsonDecode(userRes.body));
         await UserSharedPreference.setUserName(decodedUserData.userName!);
         await UserSharedPreference.setEmail(decodedUserData.email!);
         await UserSharedPreference.setFirstName(decodedUserData.firstName!);
         await UserSharedPreference.setLastName(decodedUserData.lastName!);
         if (decodedUserData.profilePic != null) {
           await UserSharedPreference.setProPic(decodedUserData.profilePic!);
         }
         if (!mounted) return;
         setState(() {
           _isLoading = false;
         });
         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const MainPage()), (Route<dynamic> route) => false);
         showToast('login success');
       } else {
          final error = jsonDecode(userRes.body);
          if (!mounted) return;
          setState(() {
            _isLoading = false;
          });
          showToast(error['detail'].toString());
       }
     } else if (response.statusCode == 400) {
       final res = jsonDecode(response.body);
       if (!mounted) return;
       setState(() {
         _isLoading = false;
       });
       showToast(res['error_description'].toString());
     } else {
       if (!mounted) return;
       setState(() {
         _isLoading = false;
       });
       showToast('${jsonDecode(response.body)['error']}');
     }
   } catch (err) {
     if (!mounted) return;
     setState(() {
       _isLoading = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: TextWidget(label: err.toString()),
         backgroundColor: Colors.red,
       ),
     );
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
                      padding: const EdgeInsets.all(25.0),
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
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              labelText: "Username",
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.text,
                            obscureText: _obSecureText,
                            validator: (val) => validatePassword(val!),
                            decoration: InputDecoration(border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
                          const SizedBox(height: 20),
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
                            onLongPress: () {
                              setState(() {
                                _formKey.currentState!.reset();
                                usernameController.clear();
                                passwordController.clear();
                              });
                            },
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [ /// TODO: facebook login button
                              // Expanded(
                              //   child: MaterialButton(
                              //     height: 50.0,
                              //     minWidth: 1000.0,
                              //     color: Colors.blueAccent,
                              //     textColor: Colors.white,
                              //     onPressed:facebookSignIn,
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.center,
                              //       children: [
                              //         const Text(
                              //           "Login with",
                              //           style: TextStyle(
                              //             fontSize: 16.0,
                              //           ),
                              //         ),
                              //         const SizedBox(width: 5),
                              //         Image(
                              //           width: 25,
                              //           height: 25,
                              //           image: AssetImage(AppImages.facebook),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              // const SizedBox(width: 10),
                              Expanded(
                                child: MaterialButton(
                                  height: 50.0,
                                  minWidth: 1000.0,
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  onPressed: googleSignIn,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Login with",
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                     Image(
                                       width: 25,
                                       height: 25,
                                       image: AssetImage(AppImages.google),
                                     ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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

  Future googleSignIn() async {
    try {
      GoogleSignInAccount?  user = await GoogleSignInApi.login();
      setState(() {
        _isLoading = true;
      });
      GoogleSignInAuthentication? googleSignInAuthentication = await user!.authentication;
      if (kDebugMode) {
        print('========== Access Token by Google: ${googleSignInAuthentication.accessToken} ==========');
      }
      final response = await AuthApiService.userSignInWithGoogle(googleSignInAuthentication.accessToken!);

      final decodeRes = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('========== Login Access Token: ${decodeRes['access_token']} ==========');
        }
        UserSharedPreference.setAccessToken(decodeRes['access_token']);
        UserSharedPreference.setLoginType('google');

        final userRes = await AuthApiService.userProfile(decodeRes['access_token']);

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
        setState(() {
          _isLoading = false;
        });
        showToast(decodeRes['error_description'].toString());
      } else {
        setState(() {
          _isLoading = false;
        });
        showToast('${decodeRes['error']}');
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future facebookSignIn() async {
    /// TODO
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
