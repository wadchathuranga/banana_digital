import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  //loading progress
  bool _isLoading = false;

  //get shared preference
  var email;

  //toast message
  var msg;

  //text editing controller
  TextEditingController _newPasswordController = TextEditingController();

  //password visible method
  bool _obSecurePassword = true;

  //form key & validation
  GlobalKey<FormState> _newPasswordKey = GlobalKey();
  bool _validation = false;
  void _toggle() {
    setState(() {
      _obSecurePassword = !_obSecurePassword;
    });
  }


  @override
  void initState() {
    super.initState();
    getSession();
  }

  //check user still logged in
  getSession() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      // email = sharedPreferences.getString('session_email');
    });
  }

  //reset password method
  _resetPassword() async {
    var jsonDataArray = null;
    // final response = await http.post(
    //     "https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/resetPassword.php",
    //     body: {
    //       'email': email,
    //       'password': _newPasswordController.text.trim(),
    //     });

//    final response = await http.post("http://192.168.43.206/flutter/resetPassword.php", body: {
//      'email': _emailController.text.trim(),
//      'password': _newPasswordController.text.trim(),
//    });

    // if (response.statusCode == 200) {
    //   jsonDataArray = json.decode(response.body);
    //   print(jsonDataArray);
    //   if (jsonDataArray[0]['msg'] == 'updated') {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //     msg = 'Password Updated';
    //     showToast();
    //     Navigator.pop(context);
    //   } else {
    //     msg = 'Server Connection Error!';
    //     showToast();
    //     print(response.body);
    //   }
    // } else {
    //   msg = 'System Error!';
    //   showToast();
    //   print(response.body);
    // }
  }

  //toast msg method
  void showToast() {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Reset'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
//        width: MediaQuery.of(context).size.width,
//        height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Form(
                      key: _newPasswordKey,
                      // autovalidate: _validation,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            controller: _newPasswordController,
                            // validator: validateNewPassword,
                            obscureText: _obSecurePassword,
                            decoration: InputDecoration(
                              labelText: 'New Password',
                              prefixIcon: Icon(Icons.vpn_key),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  _toggle();
                                },
                                child: _obSecurePassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                              ),
                            ),
                          ),
                          TextFormField(
                            // validator: validateReNewConfirmPassword,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Confirm New Password',
                              prefixIcon: Icon(Icons.vpn_key),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Text('Reset Password'),
                              onPressed: () {
                                passwordFormValidationController();
                              },
                            ),
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
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
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

  void passwordFormValidationController() {
    // if (_newPasswordKey.currentState.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   _resetPassword();
    // } else {
    //   setState(() {
    //     _validation = true;
    //   });
    // }
  }

  //email validate method
  String validateEmail(String email) {
    RegExp regExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (email.trim().length == 0) {
      return "Email is required!";
    } else if (!regExp.hasMatch(email)) {
      return "Incorrect email format!";
    } else {
      return '';
    }
  }

  //password validate method
  String validateNewPassword(String password) {
//    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
//    RegExp regExp = new RegExp(pattern);
    if (password.trim().length == 0) {
      return "Password is required!";
    }
//    else if(!regExp.hasMatch(password)) {
//      return "Week Password";
//    }
    else {
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
      return '';
//      }
    }
  }

  //confirmPassword validate method
  String validateReNewConfirmPassword(String rePassword) {
    if (rePassword.trim().length == 0) {
      return "Confirm Password is required!";
    } else if (_newPasswordController.text.trim() != rePassword.trim()) {
      return "Password not matched!";
    } else {
      return '';
    }
  }
}
