import 'dart:async';
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
import '../widgets/PopupMenu.dart';

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

  var selectedValue;

  @override
  void initState() {
    _isTyping = false;
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
      backgroundColor: AppColors.chatScaffoldBackgroundColor,
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('Chat'),
        actions: const <Widget>[
          // LanguagePicker(),
          PopupMenu(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
              Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].response!,
                    chatIndex: chatProvider.getChatList[index].chatIndex!,
                    dropdownData:  chatProvider.getChatList[index].diseases == null ? [] : chatProvider.getChatList[index].diseases!,
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
              color: AppColors.cardColor,
              child: SizedBox(
                height: 65,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    if (chatProvider.getChatList.isNotEmpty && chatProvider.getChatList.last.chatIndex == 1 && chatProvider.getChatList.last.diseases != null)
                      Row(
                        children: [
                            Expanded(
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                child: DropdownButtonFormField<String>(
                                  validator: (val) {
                                    if (val == null) {return 'Required!';} else {return null;}
                                  },
                                  itemHeight: 50,
                                  decoration: InputDecoration(
                                    iconColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    labelText: 'Select your choice',
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  items: chatProvider.getChatList.last.diseases!.map((value) {
                                    return DropdownMenuItem(
                                      value: value.name
                                          .toString(),
                                      child: Text(value.nameDisplay
                                          .toString()),
                                    );
                                  }).toList(),
                                  onChanged: (newValueSelected) async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      selectedValue = newValueSelected!;
                                    });
                                    await sendChooseddMsgForBot(newValueSelected, chatProvider);
                                  },
                                  value: selectedValue,
                                  isExpanded: false,
                                ),
                              ),
                            ),
                        ],
                      )
                      else
                        Row(
                        children: [
                            Expanded(
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                controller: textEditingController,
                                onSubmitted: (value) async {
                                  // await sendMessageFCT(chatProvider: chatProvider);
                                },
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'How can I help you..?',
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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

  Future<void> sendChooseddMsgForBot(value, chatProvider) async {
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: value);
        focusNode.unfocus();
      });
      chatProvider.sendMessageAndGetAnswers(msg: msg, accessToken: 'HfwGdcWHpiaHF1BnujmUEPbOZmrnvz', tag: 'greating', lang: 'en')
          .then((value) => {
        scrollListToEND(),
        setState(() {
          _isTyping = false;
        }),
      });
      setState(() {});
    } catch (error) {
      log("Error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
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
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatProvider.sendMessageAndGetAnswers(msg: msg, accessToken: 'HfwGdcWHpiaHF1BnujmUEPbOZmrnvz', tag: 'greating', lang: 'en')
          .then((value) => {
                scrollListToEND(),
                setState(() {
                  _isTyping = false;
                }),
              });
      setState(() {});
    } catch (error) {
      log("Error $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: error.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

}
