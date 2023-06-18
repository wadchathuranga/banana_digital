import 'dart:convert';
import 'package:banana_digital/models/User.dart';
import 'package:banana_digital/services/shared_preference.dart';
import 'package:banana_digital/utils/app_configs.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {

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
  static Future userProfile(String accessToken) async {
    try {
      var url = Uri.parse(USER_PROFILE_GET);
      final userRes = await http.get(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          });
      return userRes;
    } catch (err) {
      throw Exception(err);
    }
  }

  // PATCH: Update user profile details
  static Future updateUserProfile(String firstname, String lastname, String accessToken) async {
    try {
      var url = Uri.parse(USER_PROFILE_UPDATE);
      final response = await http.patch(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $accessToken",
          },
          body: jsonEncode({
            "first_name": firstname,
            "last_name": lastname,
          }));
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }

  // PATCH: Update user profile picture
  static Future updateUserProfilePicture(String accessToken, CroppedFile imageFile) async {
    try {
      // string to uri
      var uri = Uri.parse(USER_PROFILE_UPDATE);

      // create multipart request
      var request = http.MultipartRequest("PATCH", uri);

      // multipart that takes file
      var multipartFile = await http.MultipartFile.fromPath('profile_pic', imageFile.path, filename: '${UserSharedPreference.getUserName().toString()}.jpg');

      // add file to multipart
      request.files.add(multipartFile);

      // herders
      var headers = {
        'Authorization': 'Bearer $accessToken'
      };

      // set headers to request
      request.headers.addAll(headers);

      // send request
      http.StreamedResponse response = await request.send();
      return response;
    } catch (err) {
      throw Exception(err);
    }
  }


}