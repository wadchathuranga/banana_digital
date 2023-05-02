import 'package:banana_digital/screens/profile/profile_page.dart';
import 'package:banana_digital/screens/screenHome/homeScreen.dart';
import 'package:banana_digital/screens/screenFour/screenFour.dart';
import 'package:banana_digital/screens/screenOne/screenOne.dart';
import 'package:banana_digital/screens/screenThree/screenThree.dart';
import 'package:banana_digital/screens/screenTwo/screenTwo.dart';
import 'package:banana_digital/screens/splash_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext? context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main': (context) => const MainPage(),
        '/one': (context) => const  ScreenOne(),
        '/two': (context) => const ScreenTwo(title: 'Two'),
        '/three': (context) => const ScreenThree(title: 'Three'),
        '/four': (context) => const ScreenFour(title: 'Four'),
      },
      // home: const MainPage(),
      // home: SplashScreen(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int currentIndex = 0;

  final screens = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  //double tap to exit
  DateTime current = DateTime.now().subtract(const Duration(milliseconds: 1500));
  Future<bool> popped() {
    DateTime now = DateTime.now();
    if (currentIndex == 0) {
      if (now.difference(current) > const Duration(milliseconds: 1500)){
        current = now;
        Fluttertoast.showToast(
            msg: "Press Again to Exit!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return Future.value(false);
      }else{
        Fluttertoast.cancel();
        return Future.value(true);
      }
    } else {
      final navigationState = navigationKey.currentState!;
      navigationState.setPage(0);
      return Future.value(false);
    }

  }

  @override
  Widget build(BuildContext context) {

    final items = <Widget>[
      const Icon(Icons.home, size: 30),
      const Icon(Icons.person_pin_sharp, size: 30),
      // const Icon(Icons.favorite, size: 30),
    ];

    return WillPopScope(
      onWillPop: () => popped(),
      child: Scaffold(
        body: screens[currentIndex],
        // body: const HomeScreen(),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          child: CurvedNavigationBar(
            key: navigationKey,
            backgroundColor: Colors.transparent,
            items: items,
            index: 0,
            color: Colors.blue,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 250),
            onTap: (index) => {
              setState(()=>{ currentIndex = index }),
            },
          ),
        ),
      ),
    );
  }
}
