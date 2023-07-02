import 'dart:async';
import 'dart:developer';

import 'package:banana_digital/screens/chat_screen/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../services/shared_preference.dart';
import '../../widgets/LanguagePicker.dart';
import '../../widgets/Loading.dart';


class DiseaseIdentificationMainScreen extends StatefulWidget {
  const DiseaseIdentificationMainScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseIdentificationMainScreen> createState() => _DiseaseIdentificationMainScreenState();
}

class _DiseaseIdentificationMainScreenState extends State<DiseaseIdentificationMainScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  final _qaFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List leafColor = ["Yellow", "Brown", "Pale Green"];
  var selectedLeafColor;

  final List leafSpots = ["Black", "Brown", "None"];
  var selectedLeafSpots;

  final List leafWilting = ["Yes", "No"];
  var selectedLeafWilting;

  final List leafCurling = ["Yes", "No"];
  var selectedLeafCurling;

  final List stuntedGrowth = ["Slow Growth", "Normal"];
  var selectedstuntedGrowth;

  final List stemColor = ["Brown", "Black", "Yellow", "Red", "Green"];
  var selectedStemColor;

  final List rootRot = ["Yes", "No"];
  var selectedRootRot;

  final List abnormalFruiting = ["Normal", "Distorted"];
  var selectedAbnormalFruiting;

  final List presenceOfPets = ["Aphids", "None", "Caterpillars", "Mites"];
  var selectedPresenceOfPets;

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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() { });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    return WillPopScope(
      onWillPop: () {
        if (tabController.index != 0) {
          setState(() => tabController.index = 0);
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        // backgroundColor: chatScaffoldBackgroundColor,
        appBar: AppBar(
          // backgroundColor: chatScaffoldBackgroundColor,
          title: (tabController.index == 0) ? const Text('Chat bot') : const Text('Disease Identification'),
          actions: <Widget>[
            Center(
              child: Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 25),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Chat', icon: Icon(Icons.chat)),
              Tab(text: 'Disease Identify', icon: Icon(Icons.search_sharp))
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            const ChatScreen(),
            diseaseIdentifyBySymptoms(),
          ],
        ),
      ),
    );
  }

  void clearFormData() {
    setState(() {
      _qaFormKey.currentState!.reset();
      selectedLeafColor = null;
      selectedPresenceOfPets = null;
      selectedAbnormalFruiting = null;
      selectedRootRot = null;
      selectedLeafCurling = null;
      selectedstuntedGrowth = null;
      selectedLeafSpots = null;
      selectedStemColor = null;
      selectedLeafWilting = null;
    });
  }

  Widget diseaseIdentifyBySymptoms() {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Form(
                  key: _qaFormKey,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0, right: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Leaf Color',
                              ),
                              items: leafColor.map((variety) {
                                return DropdownMenuItem(
                                  value: variety
                                      .toString(),
                                  child: Text(variety
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedLeafColor = newValueSelected!;
                                });
                              },
                              value: selectedLeafColor,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Leaf Spots',
                              ),
                              items: leafSpots.map((variety) {
                                return DropdownMenuItem(
                                  value: variety
                                      .toString(),
                                  child: Text(variety
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedLeafSpots = newValueSelected!;
                                });
                              },
                              value: selectedLeafSpots,
                              isExpanded: false,
                            ),
                          ),
                        ],
                      ),
                      buildSizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Leaf Curling',
                              ),
                              items: leafCurling.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedLeafCurling = newValueSelected!;
                                });
                              },
                              value: selectedLeafCurling,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Leaf Wilting',
                              ),
                              items: leafWilting.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedLeafWilting = newValueSelected!;
                                });
                              },
                              value: selectedLeafWilting,
                              isExpanded: false,
                            ),
                          ),
                        ],
                      ),
                      buildSizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Stem Color',
                              ),
                              items: stemColor.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedStemColor = newValueSelected!;
                                });
                              },
                              value: selectedStemColor,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Root Rot',
                              ),
                              items: rootRot.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedRootRot = newValueSelected!;
                                });
                              },
                              value: selectedRootRot,
                              isExpanded: false,
                            ),
                          ),
                        ],
                      ),
                      buildSizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val== null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Abnormal Fruiting',
                              ),
                              items: abnormalFruiting.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedAbnormalFruiting = newValueSelected!;
                                });
                              },
                              value: selectedAbnormalFruiting,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Presence of Pets',
                              ),
                              items: presenceOfPets.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedPresenceOfPets = newValueSelected!;
                                });
                              },
                              value: selectedPresenceOfPets,
                              isExpanded: false,
                            ),
                          ),
                        ],
                      ),
                      buildSizedBox(),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              validator: (val) {
                                if (val == null) {return 'Required!';} else {return null;}
                              },
                              itemHeight: 50,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: 'Stunted Growth',
                              ),
                              items: stuntedGrowth.map((value) {
                                return DropdownMenuItem(
                                  value: value
                                      .toString(),
                                  child: Text(value
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedstuntedGrowth = newValueSelected!;
                                });
                              },
                              value: selectedstuntedGrowth,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'Clear Form',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        onPressed: () =>  clearFormData(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'Identify the Disease',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        onPressed: () {
                          clearFormData();
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
            ],
          ),
        ),
        SizedBox(
          child: !isLoading
              ? null
              : const LoadingWidget(),
        ),
      ],
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
