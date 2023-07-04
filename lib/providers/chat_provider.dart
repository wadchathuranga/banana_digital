import 'package:flutter/material.dart';

import '../services/chat_api_services.dart';
import '../models/BananaChatModel.dart';

class ChatProvider with ChangeNotifier {
  List<BananaChatModel> chatList = [];

  List<BananaChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(BananaChatModel(chatIndex: 0, response: msg, diseases: [])); // language: 'en', tag: 'default_tag',
    notifyListeners();
  }

  Future sendMessageAndGetAnswers({required String msg, required String accessToken, required String? tag, required String? lang}) async {
    try {
      chatList.add(
        await ChatApiServices.sendMessage(
          accessToken: accessToken,
          message: msg,
          tag: tag,
          lang: lang,
        ),
      );
      notifyListeners();
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> sendMessageApi2AndGetAnswers({required String msg, required String accessToken, required String? tag, required String lang, required int diseaseId}) async {
      chatList.add(
        await ChatApiServices.sendMessageToGetDiseaseOrCuresById(
          accessToken: accessToken,
          message: msg,
          tag: tag,
          lang: lang,
          diseaseId: diseaseId,
        ),
      );
    notifyListeners();
  }
}