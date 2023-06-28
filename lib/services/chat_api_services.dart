import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:banana_digital/services/shared_preference.dart';
import 'package:http/http.dart' as http;
import '../models/BananaChatModel.dart';
import '../models/chat_model.dart';

import '../utils/app_configs.dart';

class ChatApiServices {

  // send message
  static Future sendMessage({ required String accessToken, required String message, required String? tag, required String lang }) async {
    try {
      print('SEND MSG TAG ==================>>>>>>> $tag');
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

      print('RESPONSE MSG TAG ==================>>>>>>> ${jsonDecRes['tag']}');

      return BananaChatModel.fromJson(jsonDecRes);
    } catch (error) {
      log("Error [sendMessage()]: $error");
      rethrow;
    }
  }

  // send msg get answers from diseases
  static Future sendMessageToGetDiseasesOrCuresById({ required String accessToken, required String message, required String? tag, required String lang, required int diseaseId }) async {
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
        };
      } else {
        var response = await http.get(
          Uri.parse("$BASE_URI/disease/$diseaseId?language=$lang"),
          headers: {"Authorization": "Bearer $accessToken"},
        );

        dynamic jsonDecRes = jsonDecode(response.body);
        res = {
          "response": [jsonDecRes],
        };
      }

      // tag clear because of flow completed here
      UserSharedPreference.clearTag();

      return BananaChatModel.fromJson(res);
    } catch (error) {
      log("Error $error");
      rethrow;
    }
  }

  // Send Message using ChatGPT API
  static Future<List<ChatModel>> sendMessageGPT(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      // Map jsonResponse = jsonDecode(response.body);
      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        // log("jsonResponse[choices]text ${jsonResponse["choices"][0]["text"]}");
        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => ChatModel(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}