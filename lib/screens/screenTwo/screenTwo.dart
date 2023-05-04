import 'package:banana_digital/components/LanguagePicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Two'),
        actions: const <Widget>[
          // Center(
          //   child: Text(
          //       AppLocalizations.of(context)!.language,
          //       style: const TextStyle(fontSize: 20),
          //   ),
          // ),
          LanguagePicker(),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.formTitle),
      ),
    );
  }
}
