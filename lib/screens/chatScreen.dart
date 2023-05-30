import 'dart:developer';

import 'package:banana_digital/screens/zoom_drawer_menu/menu_widget.dart';
import 'package:banana_digital/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../widgets/ChatWidget.dart';
import '../../widgets/LanguagePicker.dart';
import '../../widgets/TextWidget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isTyping = false;

  // List<ChatModel> chatList = [];
  late ScrollController _listScrollController;
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  @override
  void initState() {
    _listScrollController = ScrollController();
    textEditingController = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
      backgroundColor: chatScaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: chatScaffoldBackgroundColor,
        leading: const MenuWidget(),
        title: const Text('Chat'),
        actions: const <Widget>[
          // Center(
          //   child: Text(
          //       AppLocalizations.of(context)!.language,
          //       style: const TextStyle(fontSize: 20),
          //   ),
          // ),
          LanguagePicker(),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length, //chatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].msg, //chatList[index].msg,
                    chatIndex: chatProvider.getChatList[index].chatIndex, //chatList[index].chatIndex,
                  );
                },
              ),
            ),
            if(_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(height: 15),
            Material(
              color: cardColor,
              child: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 5.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.white),
                          controller: textEditingController,
                          onSubmitted: (value) async {
                            await sendMessageFCT(chatProvider: chatProvider);
                          },
                          decoration: const InputDecoration.collapsed(
                            hintText: 'How can I help you',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
                          await sendMessageFCT(chatProvider: chatProvider);
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
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(_listScrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  Future<void> sendMessageFCT({required ChatProvider chatProvider}) async {
    // avoid send another msg before coming response of previous one
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "You can't send multiple messages at a time!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // avoid sending empty msg
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "Please type a message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        // chatList.add(ChatModel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      // chatList.addAll(await ApiServices.sendMessage(
      //   message: textEditingController.text,
      //   modelId: modelsProvider.getCurrentModel,
      // ));
      chatProvider.sendMessageAndGetAnswers(msg: msg, chosenModelId: "gpt-3.5-turbo-0301");
      setState(() {});
    } catch (error) {
      log("Error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      scrollListToEND();
      setState(() {
        _isTyping = false;
      });
    }
  }
}
