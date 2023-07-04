import 'package:banana_digital/screens/zoom_drawer_menu/menu_widget.dart';
import 'package:flutter/material.dart';
import '../../utils/app_images.dart';
import 'GridView.dart';
import '../../widgets/PopupMenu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('Banana Digital'),
        actions: const <Widget>[
          PopupMenu(),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Text(
                          'Welcome To Banana Digital',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GridViewCard(
                          title: 'Identify Pests and Diseases using Images',
                          icon: Icons.person_outline,
                          img: AppImages.c1,
                          value: '1',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GridViewCard(
                          title:
                              'Identify Banana Diseases using Questionnaires',
                          icon: Icons.list_alt_outlined,
                          img: AppImages.c2,
                          value: '2',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: GridViewCard(
                          title:
                              'Estimate Harvest of Banana using Questionnaires',
                          icon: Icons.person_outline,
                          img: AppImages.c3,
                          value: '3',
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GridViewCard(
                          title: 'Supply Fertilizer and water management plan',
                          icon: Icons.list_alt_outlined,
                          img: AppImages.c4,
                          value: '4',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
