import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../components/LanguagePicker.dart';


class ScreenThree extends StatefulWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {

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

    validateFunc(String val) {
      return null;
      // if (val!.trim().isEmpty) {
      //   return 'Required!';
      // } else {
      //   return null;
      // }
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimate Harvest of Banana'),
        actions: const [
          LanguagePicker(),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.formTitle,
                      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                        'Using the provided data bellow, you can estimate the banana harvest, press the button to proceed with prediction process.'),
                    buildSizedBox(),
                    Form(
                      key: _qaFormKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    validator: (val) => validateFunc(val!),
                                    // onSaved: (value) => _username = value,
                                    decoration: buildInputDecoration('Variety'), // The type of banana variety being grown (e.g. Cavendish, Williams, etc.)
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  // child: IconButton(
                                  //   icon: const Icon(Icons.info_outline),
                                  //   onPressed: () => bottomSheet('Variety', 'The type of banana variety being grown (e.g. Cavendish, Williams, etc.)'),
                                  // ),
                                  child: Container(color: Colors.green,),
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
                                    decoration: buildInputDecoration('Agro-climatic region'), // The region in Sri Lanka where the plant is being grown (Wet Zone, Intermediate Zone, or Dry Zone)
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Agro-climatic region', 'The region in Sri Lanka where the plant is being grown (Wet Zone, Intermediate Zone, or Dry Zone)'),
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
                                    decoration: buildInputDecoration('Plant density'), // The number of banana plants per unit area of land
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Plant density', 'The number of banana plants per unit area of land'),
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
                                    decoration: buildInputDecoration('Spacing between plants'), // The distance between adjacent banana plants
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Spacing between plants', 'The distance between adjacent banana plants'),
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
                                    decoration: buildInputDecoration('Plant generation'), // Whether the plant is a first generation or subsequent generation plant
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Plant generation', 'Whether the plant is a first generation or subsequent generation plant'),
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
                                    decoration: buildInputDecoration('Fertilizer type'), // The type of fertilizer used (organic or chemical)
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Fertilizer type', 'The type of fertilizer used (organic or chemical)'),
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
                                    decoration: buildInputDecoration('Soil pH'), // The pH level of the soil where the plant is being grown
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Soil pH', 'The pH level of the soil where the plant is being grown'),
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
                                    decoration: buildInputDecoration('Amount of sunlight received'), // The amount of sunlight the plant receives (low, moderate, or high)
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Amount of sunlight received', 'The amount of sunlight the plant receives (low, moderate, or high)'),
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
                                    decoration: buildInputDecoration('Watering schedule'), // The frequency of watering (daily, twice a week, once a week, or no watering)
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Watering schedule', 'The frequency of watering (daily, twice a week, once a week, or no watering)'),
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
                                    decoration: buildInputDecoration('Number of days for flower initiation'), // The number of days it takes for the plant to begin producing flowers
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Number of days for flower initiation', 'The number of days it takes for the plant to begin producing flowers'),
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
                                    decoration: buildInputDecoration('Number of leaves'), // The number of leaves on the plant
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Number of leaves', 'The number of leaves on the plant'),
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
                                    decoration: buildInputDecoration('Number of banana combs'), // The number of combs (clusters) of bananas produced by the plant
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Number of banana combs', 'The number of combs (clusters) of bananas produced by the plant'),
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
                                    decoration: buildInputDecoration('Number of bananas in one comb'), // The number of bananas in a single comb
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Number of bananas in one comb', 'The number of bananas in a single comb'),
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
                                    decoration: buildInputDecoration('Height (in feet)'), // The height of the plant
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: IconButton(
                                    icon: const Icon(Icons.info_outline),
                                    onPressed: () => bottomSheet('Height (in feet)', 'The height of the plant'),
                                  ),
                                ),
                              ],
                            ),
                            buildSizedBox(),
                            ElevatedButton(
                                child: SizedBox(
                                  height: 50,
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
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            child: !isLoading
                ? null
                : Container(
                  color: Colors.black54,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SpinKitRing(
                        size: 40,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 30,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            RotateAnimatedText(
                              'Processing...',
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                            RotateAnimatedText(
                              'Please wait...',
                              textStyle: const TextStyle(color: Colors.white),
                            ),
                          ],
                          repeatForever: true,
                        ),
                      ),
                    ],
                  ),
                ),
          )
        ]
      ),
    );
  }

  void bottomSheet(String name, String desc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (builder) {
          return Container(
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
