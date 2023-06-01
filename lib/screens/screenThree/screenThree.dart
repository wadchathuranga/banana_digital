import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../widgets/LanguagePicker.dart';
import '../../widgets/Loading.dart';


class ScreenThree extends StatefulWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  State<ScreenThree> createState() => _ScreenThreeState();
}

class _ScreenThreeState extends State<ScreenThree> {

  final _qaFormKey = GlobalKey<FormState>();

  bool isLoading = false;

  final List varieties = ["Anamalu Banana", "Mysore Banana", "Pisang Awak Banana", "Silk Banana", "Amban Banana"];
  var selectedVariety;

  final List climaticRegions = ["Wet Zone", "Dry Zone", "Intermediate Zone"];
  var selectedClimaticRegion;

  final List fertilizerTypes = ["Organic", "Non Organic", "Both Used", "None"];
  var selectedFertilizerType;

  final List wateringSchedule = ["Twice a week", "Randomly", "None", "3 times a week", "Daily"];
  var selectedWateringSchedule;

  final List sunlightReceived = ["Low", "Moderate", "High"];
  var selectedSunlightReceived;


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
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.formTitle,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                          'Using the provided data bellow, you can estimate the banana harvest, press the button to proceed with prediction process.',
                      ),
                    ],
                  ),
                ),
                buildSizedBox(),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Form(
                    key: _qaFormKey,
                      child: Column(
                        children: [
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
                                    labelText: 'Variety',
                                  ),
                                  items: varieties.map((variety) {
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
                                      selectedVariety = newValueSelected!;
                                    });
                                  },
                                  value: selectedVariety,
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
                                    labelText: 'Agro Climatic Region',
                                  ),
                                  items: climaticRegions.map((value) {
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
                                      selectedClimaticRegion = newValueSelected!;
                                    });
                                  },
                                  value: selectedClimaticRegion,
                                  isExpanded: false,
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  validator: (val) {
                                    if (val!.isEmpty) {
                                      return 'Required!';
                                    }
                                    // else if (int.parse(val!) > 5) {
                                    //   return 'Should between 1 - 5 ';
                                    // }
                                    else {
                                      return null;
                                    }
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('Plant density'), // The number of banana plants per unit area of land
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('Spacing between plants'), // The distance between adjacent banana plants
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('Plant generation'), // Whether the plant is a first generation or subsequent generation plant
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
                                    labelText: 'Fertilizer Type',
                                  ),
                                  items: fertilizerTypes.map((value) {
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
                                      selectedFertilizerType = newValueSelected!;
                                    });
                                  },
                                  value: selectedFertilizerType,
                                  isExpanded: false,
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
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
                                    labelText: 'Amount of sunlight received',
                                  ),
                                  items: sunlightReceived.map((value) {
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
                                      selectedSunlightReceived = newValueSelected!;
                                    });
                                  },
                                  value: selectedSunlightReceived,
                                  isExpanded: false,
                                ),
                              ),
                              const SizedBox(width: 10),
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
                                    labelText: 'Watering Schedule',
                                  ),
                                  items: wateringSchedule.map((value) {
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
                                      selectedWateringSchedule = newValueSelected!;
                                    });
                                  },
                                  value: selectedWateringSchedule,
                                  isExpanded: false,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('# banana combs'), // The number of combs (clusters) of bananas produced by the plant
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('# leaves'), // The number of leaves on the plant
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('# days for flower initiation'), // The number of days it takes for the plant to begin producing flowers
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('# bananas in one comb'), // The number of bananas in a single comb
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  validator: (val) {
                                    if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                  },
                                  // onSaved: (value) => _username = value,
                                  decoration: buildInputDecoration('Height (in feet)'), // The height of the plant
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
                        flex: 2,
                        child: ElevatedButton(
                          child: SizedBox(
                            height: 55,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                'Clear Form',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          onPressed: () =>  clearFormData(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
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
              ],
            ),
          ),
          SizedBox(
            child: !isLoading
                ? null
                : const LoadingWidget(),
          ),
        ]
      ),
    );
  }

  void clearFormData() {
    setState(() {
      _qaFormKey.currentState!.reset();
      selectedSunlightReceived = null;
      selectedClimaticRegion = null;
      selectedFertilizerType = null;
      selectedVariety = null;
      selectedWateringSchedule = null;
    });
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
