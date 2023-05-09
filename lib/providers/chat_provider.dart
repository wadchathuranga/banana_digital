import 'package:flutter/material.dart';

import '../models/chat_model.dart';
import '../services/chat_api_services.dart';

class ChatProvider with ChangeNotifier {
  List<ChatModel> chatList = [];

  List<ChatModel> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(ChatModel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    chatList.addAll(await ChatApiServices.sendMessageGPT(
      message: msg,
      modelId: chosenModelId,
    ));
    notifyListeners();
  }
}