import 'package:flutter/material.dart';

import 'menu_item.dart';

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const profile = MenuItem('Profile', Icons.person);
  static const chat = MenuItem('Chat', Icons.message);
  static const about = MenuItem('About', Icons.info_outlined);
  static const test = MenuItem('Test Form', Icons.folder_delete_outlined);

  static const all = <MenuItem>[ home, profile, chat, about, test ];
}


class MenuPage extends StatelessWidget {

  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage({Key? key, required this.currentItem, required this.onSelectedItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              ...MenuItems.all.map(buildMenuItem).toList(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItem item) {
    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        selectedTileColor: Colors.black26 ,
        selected: currentItem == item,
        minLeadingWidth: 20,
        leading: Icon(item.icon),
        title: Text(item.title),
        onTap: () => onSelectedItem(item),
      ),
    );
  }
}
