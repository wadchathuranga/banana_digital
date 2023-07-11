import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../services/C2_disease_identification_api_service.dart';
import '../../models/DiseaseIdentificationModel.dart';
import '../../screens/chat_screen/chatScreen.dart';
import '../../services/shared_preference.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import 'DiseaseIdentificationResultScreen.dart';


class DiseaseIdentificationMainScreen extends StatefulWidget {
  const DiseaseIdentificationMainScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseIdentificationMainScreen> createState() => _DiseaseIdentificationMainScreenState();
}

class _DiseaseIdentificationMainScreenState extends State<DiseaseIdentificationMainScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  String? accessToken;

  final _qaFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  var selectedLeafColor;
  var selectedLeafSpots;
  var selectedLeafWilting;
  var selectedLeafCurling;
  var selectedStuntedGrowth;
  var selectedStemColor;
  var selectedRootRot;
  var selectedAbnormalFruiting;
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
    accessToken = UserSharedPreference.getAccessToken().toString();
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
  Future diseaseIdentification(lang) async {
      try {
        final dataBody = {
          "leaf_color": selectedLeafColor,
          "leaf_spots": selectedLeafSpots,
          "leaf_wilting": selectedLeafWilting,
          "leaf_curling": selectedLeafCurling,
          "stunned_growth": selectedStuntedGrowth,
          "stem_color": selectedStemColor,
          "root_rot": selectedRootRot,
          "abnormal_fruiting": selectedAbnormalFruiting,
          "presence_of_pests": selectedPresenceOfPets,
        };

        http.Response response = await C2DiseaseIdentificationApiService.identifyDiseases(accessToken: accessToken!, dataBody: dataBody, lang: lang);
        if (response.statusCode == 200) {
          Map<String, dynamic> resData = jsonDecode(response.body);
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
          final result = DiseaseIdentificationModel.fromJson(resData);
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiseaseIdentificationResultScreen(result: result)));
        } else {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (err) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: err.toString()),
            backgroundColor: Colors.red,
          ),
        );
        if (kDebugMode) {
          print("================= Catch Error: [diseaseIdentification()] ====================");
          print(err);
          print("==================================================");
        }
      }
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
        appBar: AppBar(
          title: (tabController.index == 0) ? Text(AppLocalizations.of(context)!.chatTabName) : Text(AppLocalizations.of(context)!.identifyDiseaseTabName),
          actions: <Widget>[
            Center(
              child: Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (tabController.index == 0) const SizedBox(width: 25),
            if (tabController.index != 0)
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/C2_disease_identification_history'),
                  icon: const Icon(Icons.history),
                ),
              ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.chatTabName, icon: const Icon(Icons.chat)),
              Tab(text: AppLocalizations.of(context)!.identifyDiseaseTabName, icon: const Icon(Icons.search_sharp))
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
      selectedStuntedGrowth = null;
      selectedLeafSpots = null;
      selectedStemColor = null;
      selectedLeafWilting = null;
    });
  }

  Widget diseaseIdentifyBySymptoms() {
    final List leafColor = [
      {"name": AppLocalizations.of(context)!.yellow, "value": "Yellow"},
      {"name": AppLocalizations.of(context)!.brown, "value": "Brown"},
      {"name": AppLocalizations.of(context)!.paleGreen, "value": "Pale Green"},
      {"name": AppLocalizations.of(context)!.darkGreen, "value": "Dark Green"},
    ];
    final List leafSpots = [
      {"name": AppLocalizations.of(context)!.black, "value": "Black"},
      {"name": AppLocalizations.of(context)!.brown, "value": "Brown"},
      {"name": AppLocalizations.of(context)!.none, "value": "None"},
    ];
    final List leafWilting = [
      {"name": AppLocalizations.of(context)!.yes, "value": "Yes"},
      {"name": AppLocalizations.of(context)!.no, "value": "No"},
    ];
    final List leafCurling = [
      {"name": AppLocalizations.of(context)!.yes, "value": "Yes"},
      {"name": AppLocalizations.of(context)!.no, "value": "No"},
    ];
    final List rootRot = [
      {"name": AppLocalizations.of(context)!.yes, "value": "Yes"},
      {"name": AppLocalizations.of(context)!.no, "value": "No"},
    ];
    final List stemColor = [
      {"name": AppLocalizations.of(context)!.yellow, "value": "Yellow"},
      {"name": AppLocalizations.of(context)!.brown, "value": "Brown"},
      {"name": AppLocalizations.of(context)!.green, "value": "Green"},
      {"name": AppLocalizations.of(context)!.black, "value": "Black"},
      {"name": AppLocalizations.of(context)!.red, "value": "Red"},
    ];
    final List stuntedGrowth = [
      {"name": AppLocalizations.of(context)!.slow, "value": "Slow Growth"},
      {"name": AppLocalizations.of(context)!.normal, "value": "Normal"},
    ];
    final List abnormalFruiting = [
      {"name": AppLocalizations.of(context)!.normal, "value": "Normal"},
      {"name": AppLocalizations.of(context)!.distorted, "value": "Distorted"},
    ];
    final List presenceOfPets = [
      {"name": AppLocalizations.of(context)!.aphids, "value": "Aphids"},
      {"name": AppLocalizations.of(context)!.none, "value": "None"},
      {"name": AppLocalizations.of(context)!.caterpillars, "value": "Caterpillars"},
      {"name": AppLocalizations.of(context)!.mites, "value": "Mites"},
    ];
    final lang = UserSharedPreference.getLanguage();
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.formTitle,
                            textAlign: TextAlign.start,
                            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                                labelText: AppLocalizations.of(context)!.leafColor,
                              ),
                              items: leafColor.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.leafSpots,
                              ),
                              items: leafSpots.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.leafCurling,
                              ),
                              items: leafCurling.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.leafWilting,
                              ),
                              items: leafWilting.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.stemColor,
                              ),
                              items: stemColor.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.rootRot,
                              ),
                              items: rootRot.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.abnormalFruiting,
                              ),
                              items: abnormalFruiting.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.presenceOfPets,
                              ),
                              items: presenceOfPets.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
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
                                labelText: AppLocalizations.of(context)!.stuntedGrowth,
                              ),
                              items: stuntedGrowth.map((value) {
                                return DropdownMenuItem(
                                  value: value['value']
                                      .toString(),
                                  child: Text(value['name']
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedStuntedGrowth = newValueSelected!;
                                });
                              },
                              value: selectedStuntedGrowth,
                              isExpanded: false,
                            ),
                          ),
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
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.clear,
                              style: const TextStyle(fontSize: 16),
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
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.identifyDisease,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_qaFormKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            diseaseIdentification(lang);
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

  // void bottomSheet(String name, String desc) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (builder) {
  //         return SizedBox(
  //           // height: MediaQuery.of(context).size.height * 0.20,
  //           width: MediaQuery.of(context).size.width,
  //           // color: Colors.deepPurple.shade300,
  //           child: SingleChildScrollView(
  //             child: Padding(
  //               padding: const EdgeInsets.all(30.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 children: [
  //                   SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           name,
  //                           style: const TextStyle(
  //                             fontSize: 20,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         Text(
  //                           desc,
  //                           style: const TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

}
