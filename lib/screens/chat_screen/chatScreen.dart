import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../../providers/chat_provider.dart';
import '../../../widgets/LanguagePicker.dart';
import './ChatWidget.dart';
import './TextWidget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  String? accessToken;

  bool _isTyping = false;

  late ScrollController _listScrollController;
  late TextEditingController textEditingController;
  late FocusNode focusNode;

  var selectedValue;
  bool dropdownEnabled = true;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
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
    final tag = UserSharedPreference.getTagValue();
    final lang = UserSharedPreference.getLanguage();
    return Scaffold(
      backgroundColor: AppColors.chatScaffoldBackgroundColor,
      // appBar: AppBar(
      //   leading: const MenuWidget(),
      //   title: const Text('Chat'),
      //   actions: <Widget>[
      //     // LanguagePicker(),
      //     IconButton(
      //       onPressed: () {
      //         UserSharedPreference.clearTag();
      //         chatProvider.chatList.clear();
      //         _isTyping = false;
      //         selectedValue = null;
      //         setState(() { });
      //       },
      //       icon: const Icon(Icons.clear_sharp),
      //     ),
      //     const PopupMenu(),
      //   ],
      // ),
      body: SafeArea(
        child: Column(
          children: [
            if (chatProvider.getChatList.isNotEmpty)
              Flexible(
              child: ListView.builder(
                controller: _listScrollController,
                itemCount: chatProvider.getChatList.length,
                itemBuilder: (context, index) {
                  return ChatWidget(
                    msg: chatProvider.getChatList[index].response!,
                    chatIndex: chatProvider.getChatList[index].chatIndex!,
                    isCures: chatProvider.getChatList[index].toCures ?? false,
                    dropdownData:  chatProvider.getChatList[index].diseases == null ? [] : chatProvider.getChatList[index].diseases!,
                  );
                },
              ),
            )
            else
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppLocalizations.of(context)!.selectLanguage),
                    const LanguagePicker(),
                  ],
                ),
              ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(height: 2),
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
                                    labelText: AppLocalizations.of(context)!.dropdown,
                                    labelStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  items: chatProvider.getChatList.last.diseases!.map((value) {
                                    return DropdownMenuItem(
                                      value: value.id
                                          .toString(),
                                      child: Text('${value.nameDisplay} ${(value.confidence == null) ? '' : '(${(value.confidence! * 100).toStringAsFixed(2)}%)'}'),
                                    );
                                  }).toList(),
                                  onChanged: dropdownEnabled ? (newValueSelected) async {
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      selectedValue = newValueSelected!;
                                    });
                                    await sendChoseMsgForBot(chatProvider: chatProvider, tag: tag, lang: lang, diseaseId: int.parse(newValueSelected.toString()));
                                  } : null,
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
                                  await sendMessageFCT(chatProvider: chatProvider, msg: textEditingController.text, tag: tag, lang: lang);
                                },
                                decoration: InputDecoration.collapsed(
                                  hintText: AppLocalizations.of(context)!.commonMsg,
                                  hintStyle: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Colors.white),
                            onPressed: () async {
                              await sendMessageFCT(chatProvider: chatProvider, msg: textEditingController.text, tag: tag, lang: lang);
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
      floatingActionButton: (chatProvider.getChatList.isEmpty)
          ? null
          : FloatingActionButton(
              onPressed: () {
                UserSharedPreference.clearTag();
                chatProvider.chatList.clear();
                _isTyping = false;
                selectedValue = null;
                setState(() { });
              },
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: const Icon(Icons.clear_sharp),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
    );
  }

  void scrollListToEND() {
    _listScrollController.animateTo(_listScrollController.position.maxScrollExtent, duration: const Duration(seconds: 1), curve: Curves.easeInOut);
  }

  Future<void> sendChoseMsgForBot({required ChatProvider chatProvider, required String? tag, required String? lang, required int diseaseId}) async {
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        dropdownEnabled = false;
        focusNode.unfocus();
      });
      chatProvider.sendMessageApi2AndGetAnswers(msg: msg, accessToken: accessToken!, tag: tag, lang: lang!, diseaseId: diseaseId)
          .then((value) => {
        scrollListToEND(),
        setState(() {
          selectedValue = null;
          _isTyping = false;
          dropdownEnabled = true;
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

  Future<void> sendMessageFCT({required ChatProvider chatProvider, required String msg, required String? tag, required String? lang}) async {
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
    if (msg.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "Please type a message"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      chatProvider.sendMessageAndGetAnswers(msg: msg, accessToken: accessToken!, tag: tag, lang: lang)
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
