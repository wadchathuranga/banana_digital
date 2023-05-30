import 'dart:async';
import 'dart:developer';

import 'package:banana_digital/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../widgets/ChatWidget.dart';
import '../../widgets/LanguagePicker.dart';
import '../../widgets/Loading.dart';
import '../../widgets/TextWidget.dart';


class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {

  final _qaFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    // TextFormField common InputDecoration function
    InputDecoration buildInputDecoration(String hintText) {
      return InputDecoration(
        // helperText: "(Wet Zone, Intermediate Zone, or Dry Zone)",
        labelText: hintText,
        labelStyle: const TextStyle(fontSize: 18),
        contentPadding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
    }

    SizedBox buildSizedBox() {
      return const SizedBox(
        height: 15,
      );
    }

    //update user details
    Future _estimatHarvest() async {
      // var data = {
      //   "username": usernameController.text,
      //   "email": emailController.text,
      // };

      Timer(const Duration(seconds: 8), () {
        setState(() {
          isLoading = false;
        });
      });
    }

    validateFunc(String val) {
      return null;
      // if (val!.trim().isEmpty) {
      //   return 'Required!';
      // } else {
      //   return null;
      // }
    }


    return Scaffold(
      // backgroundColor: chatScaffoldBackgroundColor,
      appBar: AppBar(
        // backgroundColor: chatScaffoldBackgroundColor,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 1),
                  child: Form(
                    key: _qaFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Fill the following questionnaire',
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Using the provided data bellow, you can see watering plan, press the button to proceed with prediction process.',
                              ),
                            ],
                          ),
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Leaf Color'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Leaf Color', 'The color of the banana leaf observed as a symptom. Possible values include yellow, brown, irregular patterns of yellowing or lightening, and pale green'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Leaf Spots'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Leaf Spots', 'The presence of spots on the banana leaf. Possible spot colors include black, brown, and yellow.'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Leaf Wilting'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Leaf Wilting', 'Whether the banana leaf shows wilting or not. Possible values are yes or no'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Leaf Curling'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Leaf Curling', 'Whether the banana leaf exhibits curling or not. Possible values are yes or no.'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Stunted Growth'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Stunted Growth', 'The growth pattern of the banana plant. Possible values include slow growth and normal growth'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Stem Color'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Stem Color', 'The color of the stem of the banana plant. Possible colors include brown, black, yellow, red, and green'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Root Rot'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Root Rot', 'Whether the banana plant shows symptoms of root rot or not. Possible values are yes or no'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Abnormal Fruiting'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Abnormal Fruiting', 'The appearance of fruits on the banana plant. Possible values include distorted and normal'),
                              ),
                            ),
                          ],
                        ),
                        buildSizedBox(),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) => validateFunc(val!),
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Presence of Pests'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Presence of Pests', 'The presence of pests on the banana plant. Possible pests include aphids, caterpillars, mites, or none'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(
                    child: SizedBox(
                      height: 55,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          'Estimate the Harvest',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (_qaFormKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        _estimatHarvest();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            child: !isLoading
                ? null
                : const LoadingWidget(),
          ),
        ],
      ),
    );
  }

  void bottomSheet(String name, String desc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return SizedBox(
            // height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width,
            // color: Colors.deepPurple.shade300,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            desc,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

}
