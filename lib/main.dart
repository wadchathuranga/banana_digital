import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
            primarySwatch: Colors.blue,
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
