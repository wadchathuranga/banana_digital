import 'package:banana_digital/screens/zoom_drawer_menu/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/app_images.dart';
import '../widgets/PopupMenu.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {


  String? _appName;
  String? _appPackageName;
  String? _appVersion;
  String? _appBuildNumber;

  @override
  void initState() {
    super.initState();
    _getAppInfo();
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState((){
      _appName = packageInfo.appName;
      _appPackageName = packageInfo.packageName;
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('About'),
        actions: const <Widget>[
          PopupMenu(),
        ],
      ),
      // drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  SizedBox(
                  width: 120,
                  height: 120,
                  child: Image(
                    image: AssetImage(AppImages.logoTB),
                    fit: BoxFit.cover,
                    // color: Colors.black54,
                  ),
                ),
                _appVersion != null
                  ?
                Text('v$_appVersion')
                  :
                const Text('0.0.0'),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Divider(indent: 50, endIndent: 50,),
                ),
                const Text(
                    'Musa Base mobile app provides farmers with a range of useful tools and features that can help them to optimize their banana crops, minimize disease outbreaks, and maximize yields. It has the potential to be a valuable resource for banana farmers and can help to promote sustainable and profitable agriculture practices.',
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 50),
                const Text('Developed by Team Musa Base.'),
                const SizedBox(height: 15),
                TextButton.icon(
                  label: const Text('Email'),
                  icon: const Icon(Icons.mail_outline),
                  onPressed: () async {
                    String encodeQueryParameters(Map<String, String> params) {
                      return params.entries
                          .map((MapEntry<String, String> e) =>
                      '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                          .join('&');
                    }

                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'musabase@gmail.com',
                      query: encodeQueryParameters(<String, String>{
                        'subject': 'Musa Base Mobile App',
                      }),
                    );

                    launchUrl(emailLaunchUri);
                  },
                ),
                Link(
                  uri: Uri.parse('https://github.com/###'),
                  target: LinkTarget.defaultTarget,
                  builder: (BuildContext context, FollowLink? followLink) {
                    return TextButton.icon(
                      onPressed: followLink,
                      label: const Text('Github'),
                      icon: const Icon(Icons.phonelink_outlined),
                    );
                  },
                ),
                Link(
                  uri: Uri.parse('https://www.linkedin.com/in/###/'),
                  target: LinkTarget.defaultTarget,
                  builder: (BuildContext context, FollowLink? followLink) {
                    return TextButton.icon(
                      onPressed: followLink,
                      label: const Text('LinkedIn'),
                      icon: const Icon(Icons.phonelink_outlined),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const Text('Copyright @2023 | All rights reserved.'),
                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
