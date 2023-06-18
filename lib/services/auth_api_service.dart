import 'dart:convert';
import 'package:banana_digital/models/User.dart';
import 'package:banana_digital/utils/app_configs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {

  // POST: User login
  static Future userLogin(String username, String password) async {
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
            "username": username,
            "password": password,
          }));
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }

  // GET: User profile
  static Future userProfile(String token) async {
    try {
      var url = Uri.parse(USER_PROFILE_GET);
      final userRes = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          });
      return userRes;
    } catch (err) {
      throw Exception(err);
    }
  }

  // POST: User signup
  static Future userSignup(String username, String email, String firstname, String lastname, String password, String rePassword) async {
    try {
      var url = Uri.parse(USER_SIGN_UP);
      final response = await http.post(
          url,
          body: {
            "username": username,
            "email": email,
            "first_name": firstname,
            "last_name": lastname,
            "password": password,
            "re_password": rePassword,
          });
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }
}