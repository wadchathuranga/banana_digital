import 'package:banana_digital/models/BananaChatModel.dart';
import 'package:banana_digital/services/shared_preference.dart';
import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/chat_api_services.dart';

class ChatProvider with ChangeNotifier {
  List<BananaChatModel> chatList = [];

  List<BananaChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(BananaChatModel(chatIndex: 0, response: msg, language: 'en', tag: 'default_tag', diseases: []));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers({required String msg, required String accessToken, required String? tag, required String lang}) async {
    chatList.add(
      await ChatApiServices.sendMessage(
        accessToken: accessToken,
        message: msg,
        tag: tag,
        lang: lang,
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessageApi2AndGetAnswers({required String msg, required String accessToken, required String? tag, required String lang, required int diseaseId}) async {
      chatList.add(
        await ChatApiServices.sendMessageToGetDiseasesOrCuresById(
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