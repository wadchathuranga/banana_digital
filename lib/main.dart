import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../screens/C1_deseas_detect/DiseaseDetectionHistoryScreen.dart';
import '../screens/C1_deseas_detect/DiseasePredictionMainScreen.dart';
import '../screens/C2_disease_identification/DiseaseIdentificationMainScreen.dart';
import '../screens/C3_harvest_predict/HarvestPredictionMainScreen.dart';
import '../screens/C3_harvest_predict/HarvestPredictionHistoryScreen.dart';
import '../screens/C4_watering_fertilizer_plan/WateringFertilizerPlanMainScreen.dart';
import '../screens/C4_watering_fertilizer_plan/WateringPlanHistoryScreen.dart';
import '../screens/C4_watering_fertilizer_plan/FertilizerPlanHistoryScreen.dart';
import '../services/shared_preference.dart';
import '../screens/zoom_drawer_menu/menu_item.dart';
import '../screens/zoom_drawer_menu/menu_page.dart';
import '../providers/chat_provider.dart';
import '../providers/local_provider.dart';
import '../screens/AboutScreen.dart';
import '../screens/profile_screen/profile_page.dart';
import '../screens/home_screen/homeScreen.dart';
import '../screens/splash_screen.dart';
import './screens/chat_screen/chatScreen.dart';
import './l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSharedPreference.init();
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
            '/C1_main': (context) => const DiseasePredictionMainScreen(),
            '/C1_disease_history': (context) => const DiseaseDetectionHistoryScreen(),
            '/C2_main': (context) => const DiseaseIdentificationMainScreen(),
            '/C3_main': (context) => const HarvestPredictionMainScreen(),
            '/C3_harvest_history': (context) => const HarvestPredictionHistoryScreen(),
            '/C4_main': (context) => const WateringFertilizerPlanMainScreen(),
            '/C4_watering_history': (context) => const WateringPlanHistoryScreen(),
            '/C4_fertilizer_history': (context) => const FertilizerPlanHistoryScreen(),
            '/chat': (context) => const ChatScreen(),
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

  MenuItem currentItem = MenuItems.home;

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
    return WillPopScope(
      onWillPop: () => popped(),
      child: ZoomDrawer(
        style: DrawerStyle.defaultStyle,
        showShadow: true,
        // borderRadius: 40,
        mainScreenTapClose: true,
        angle: -5,
        menuScreenWidth: 250,
        slideWidth: 200,
        menuBackgroundColor: Colors.indigo,
        mainScreen: getScreen(),
        menuScreen: Builder(
          builder: (context) => MenuPage(
            currentItem: currentItem,
            onSelectedItem: (item) {
              setState(() => currentItem = item);
              ZoomDrawer.of(context)!.close(); // AUTO CLOSE THE DRAWER WHEN TAP A MENU TILE
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
      default:
        return const AboutScreen();
    }
  }

}
