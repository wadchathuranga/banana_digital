import 'package:banana_digital/screens/authentication/login_page.dart';
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
        PopupMenuItem<String>(
          value: "about",
          enabled: route == '/about' ? false : true,
          child: const Text("About"),
        ),
        const PopupMenuItem<String>(
          value: "reset",
          child: Text("Restart App"),
        ),
        const PopupMenuItem(
          value: "logout",
          child: Text("Logout"),
        ),
      ],
      onSelected: (value) async {
        if (value == 'about') {
          Navigator.pushNamed(context, '/about');
        }
        if (value == 'reset') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MyApp()),
                  (Route<dynamic> route) => false);
        }
        if (value == 'logout') {
          // logout logic here
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
        }
      },
    );
  }
}

