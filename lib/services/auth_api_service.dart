import 'dart:convert';
import 'package:banana_digital/models/User.dart';
import 'package:banana_digital/utils/app_configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthAPIService {

  static Future<void> userLogin(String username, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // local url is http://192.168.43.206/flutter/loginUser.php

    // var url = Uri.parse(AUTH_SIGN_IN);
    // final response = await http.post(url, body: {
    //   "client_id": CLIENT_ID,
    //   "client_secret": ,
    //   "grant_type": CLIENT_SECRET,
    //   "username": username,
    //   "password": password,
    // });

    var url = Uri.parse('https://dummyjson.com/auth/login');
    final response = await http.post(url, body: {
      "username": "kminchelle",
      "password": "0lelplR"
    });

    final resData = User.fromJson(jsonDecode(response.body));
    pref.setString('username', resData.email!);

    print(jsonDecode(response.body));


    return jsonDecode(response.body);
  }
}