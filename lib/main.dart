import 'package:banana_digital/screens/chatScreen.dart';
import 'package:banana_digital/screens/profile_page.dart';
import 'package:banana_digital/screens/testScreen.dart';
import 'package:banana_digital/screens/zoom_drawer_menu/menu_item.dart';
import 'package:banana_digital/screens/zoom_drawer_menu/menu_page.dart';
import 'package:banana_digital/utils/app_colors.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/local_provider.dart';
import '../screens/AboutScreen.dart';
import '../screens/profile/profile_page.dart';
import '../screens/screenHome/homeScreen.dart';
import '../screens/screenFour/screenFour.dart';
import '../screens/screenOne/oneResultScreen.dart';
import '../screens/screenOne/screenOne.dart';
import '../screens/screenThree/screenThree.dart';
import '../screens/screenTwo/screenTwo.dart';
import '../screens/splash_screen.dart';
import './l10n/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MultiProvider(
      providers:[
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ],
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: const Color(0xfff1f1f1),
          ),
          locale: provider.locale,
          supportedLocales: L10n.all,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/main': (context) => const MainPage(),
            '/one': (context) => const ScreenOne(),
            '/oneResult': (context) => const OneResultScreen(),
            '/two': (context) => const ScreenTwo(),
            '/three': (context) => const ScreenThree(),
            '/four': (context) => const ScreenFour(),
            '/about': (context) => const AboutScreen(),
            '/chat': (context) => const ChatScreen(),
          },
        );
      }
    );
  }

class MainPage extends StatefulWidget {
  const MainPage({super.key});


  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  MenuItem currentItem = MenuItems.home;

  // final navigationKey = GlobalKey<CurvedNavigationBarState>();
  // int currentIndex = 0;

  // final screens = [
  //   const HomeScreen(),
  //   const ChatScreen(),
  //   const ProfileScreen(),
  // ];

  //double tap to exit
  DateTime current = DateTime.now().subtract(const Duration(milliseconds: 1500));
  Future<bool> popped() {
    DateTime now = DateTime.now();
    if (currentItem == MenuItems.home) {
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
      } else{
        Fluttertoast.cancel();
        return Future.value(true);
      }
    } else {
      setState(() => currentItem = MenuItems.home);
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    // final items = <Widget>[
    //   const Icon(Icons.home, size: 30),
    //   const Icon(Icons.chat, size: 30),
    //   const Icon(Icons.person_pin_sharp, size: 30),
    // ];
    //
    // return WillPopScope(
    //   onWillPop: () => popped(),
    //   child: Scaffold(
    //     body: screens[currentIndex],
    //     // body: const HomeScreen(),
    //     bottomNavigationBar: Theme(
    //       data: Theme.of(context).copyWith(
    //         iconTheme: const IconThemeData(color: Colors.white),
    //       ),
    //       child: CurvedNavigationBar(
    //         key: navigationKey,
    //         backgroundColor: Colors.transparent,
    //         items: items,
    //         index: 0,
    //         color: AppColors.primaryColor,
    //         animationCurve: Curves.easeInOut,
    //         animationDuration: const Duration(milliseconds: 250),
    //         onTap: (index) => {
    //           setState(()=>{ currentIndex = index }),
    //         },
    //       ),
    //     ),
    //   ),
    // );
    return WillPopScope(
      onWillPop: () => popped(),
      child: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        // showShadow: true,
        // borderRadius: 40,
        mainScreenTapClose: true,
        angle: 0,
        menuScreenWidth: 250,
        slideWidth: 200,
        menuBackgroundColor: Colors.indigo,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);
              // ZoomDrawer.of(context)!.close(); // AUTO CLOSE THE DRAWER WHEN TAP A MENU TILE
            },
          ),
        ),
      ),
    );
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return const HomeScreen();
      case MenuItems.profile:
        return const ProfileScreen();
      case MenuItems.chat:
        return const ChatScreen();
      case MenuItems.test:
        return const TestScreen();
      default:
        return const AboutScreen();
    }
  }

}
