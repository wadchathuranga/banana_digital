import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/User.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_configs.dart';
import '../../utils/app_images.dart';
import '../../widgets/TextWidget.dart';
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

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  String msg = '';
  bool _isLoading = false;

  //form key
  final _formKey = GlobalKey<FormState>();

  //password hide method
  bool _obSecureText = true;
  void _toggle() {
    setState(() {
      _obSecureText = !_obSecureText;
    });
  }

  void _signup() async {
      try {
        var url = Uri.parse(USER_SIGN_UP);
        final response = await http.post(
            url,
            body: {
              "username": usernameController.text.trim(),
              "email": emailController.text.trim(),
              "first_name": firstnameController.text.trim(),
              "last_name": lastnameController.text.trim(),
              "password": passwordController.text.trim(),
              "re_password": confirmPasswordController.text.trim(),
            });

        if (response.statusCode == 201) {
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
            showToast('User created & logged In');
          }
        } else {
          final resData = jsonDecode(response.body);
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidget(label: resData.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (err) {
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
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: usernameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: "User Name",
                                  ),
                                  keyboardType: TextInputType.text,
//                            maxLength: 12,
                                  validator: (val) => validateUsername(val!),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: "Email",
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) => validateEmail(val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'First Name',
                                  ),
                                  controller: firstnameController,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Last Name',
                                  ),
                                  controller: lastnameController,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
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
                                  keyboardType: TextInputType.text,
                                  obscureText: _obSecureText,
                                  validator: (val) => validatePassword(val!),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: "Confirm Password",
                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  validator: (val) => validateConfirmPassword(val!),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
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
                          const SizedBox(height: 30),
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
        if (password.trim().length < 8) {
          return "Length should be >= 8";
        }
//      else if (!hasLowercase.hasMatch(password)) {
//        return "Lowercase Required!";
//      } else if (!hasDigit.hasMatch(password)) {
//        return "Digit Required!";
//      } else if (!hasSpecialCharacter.hasMatch(password)) {
//        return "Special Character Required!";
//      } else if (!hasUppercase.hasMatch(password)) {
//        return "Uppercase Required!";
//      } else {
//        return null;
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
