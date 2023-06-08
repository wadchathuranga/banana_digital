import 'package:banana_digital/screens/authentication/login_page.dart';
import 'package:banana_digital/services/shared_preference.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class PopupMenu extends StatelessWidget {
  const PopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
        String? route = ModalRoute.of(context)?.settings.name;
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MyApp()),
                  (Route<dynamic> route) => false);
        }
        if (value == 'logout') {
          // logout logic here
          UserSharedPreference.userLogOut();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()), (Route<dynamic> route) => false);
        }
      },
    );
  }
}

