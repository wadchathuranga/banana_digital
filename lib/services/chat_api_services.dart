import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sentry_flutter/sentry_flutter.dart';

import '../services/shared_preference.dart';
import '../models/BananaChatModel.dart';
import '../utils/app_configs.dart';

class ChatApiServices {

  // send message
  static Future sendMessage({ required String accessToken, required String message, required String? tag, required String? lang }) async {
    try {
      lang ??= 'en';
      if (kDebugMode) {
        print('======================= Language: $lang =======================');
        print('REQUEST MSG SEND TAG ===========>>>>>>> $tag');
      }
      var response = await http.post(
        Uri.parse("$BASE_URI/chatbot?language=$lang"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "msg": message,
          "tag": tag,
        }),
      );

      Map<String, dynamic> jsonDecRes = jsonDecode(response.body);
      await UserSharedPreference.setTagValue(jsonDecRes['tag']);

      if (kDebugMode) {
        print('RESPONSE MSG RECEIVED TAG ===========>>>>>>> ${jsonDecRes['tag']}');
      }

      return BananaChatModel.fromJson(jsonDecRes);
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      throw Exception(error.toString());
    }
  }

  // send msg get answers from diseases
  static Future sendMessageToGetDiseaseOrCuresById({ required String accessToken, required String message, required String? tag, required String lang, required int diseaseId }) async {
    try {
      final Map<String, dynamic> res;
      if (UserSharedPreference.getTagValue() == "management_strategies") {
        var response = await http.get(
          Uri.parse("$BASE_URI/disease/$diseaseId/cure?language=$lang"),
          headers: {"Authorization": "Bearer $accessToken"},
        );

        dynamic jsonDecRes = jsonDecode(response.body);
        res = {
          "response": jsonDecRes,
          "toCures": false,
        };
      } else {
        var response = await http.get(
          Uri.parse("$BASE_URI/disease/$diseaseId?language=$lang"),
          headers: {"Authorization": "Bearer $accessToken"},
        );

        dynamic jsonDecRes = jsonDecode(response.body);
        res = {
          "response": [jsonDecRes],
          "toCures": true,
        };
      }

      // tag clear because of flow completed here
      UserSharedPreference.clearTag();

      return BananaChatModel.fromJson(res);
    } catch (error, stackTrace) {
      await Sentry.captureException(
        error,
        stackTrace: stackTrace,
      );
      throw Exception(error.toString());
    }
  }
}