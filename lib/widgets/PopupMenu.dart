import 'package:banana_digital/screens/authentication/login_page.dart';
import 'package:banana_digital/services/shared_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../providers/chat_provider.dart';
import '../services/google_api_service.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: "restart",
          child: Text("Restart App"),
        ),
        const PopupMenuItem(
          value: "logout",
          child: Text("Logout"),
        ),
      ],
      onSelected: (value) async {
        if (value == 'restart') {
          UserSharedPreference.clearTag();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MyApp()),
                  (Route<dynamic> route) => false);
        }
        if (value == 'logout') {
          final loginType = UserSharedPreference.getLoginType();
          if (kDebugMode) {
            print('===== User Logged Out [TYPE]: $loginType =====');
          }
          if (loginType == 'google') {
            await GoogleSignInApi.logout();
          }
          provider.chatList.clear();
          UserSharedPreference.userLogOut();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
        }
      },
    );
  }
}

