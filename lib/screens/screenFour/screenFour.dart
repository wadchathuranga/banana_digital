import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/Loading.dart';

class ScreenFour extends StatefulWidget {
  const ScreenFour({Key? key}) : super(key: key);

  @override
  State<ScreenFour> createState() => _ScreenFourState();
}

class _ScreenFourState extends State<ScreenFour> {

  late final GlobalKey<FormFieldState> _key;
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

  final List presenceOfPets = ["Aphids", "None", "Caterpillars"];
  var selectedPresenceOfPets;


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
      appBar: AppBar(
        title: const Text('Four'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
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
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12.0),
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
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                },
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Plant density'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Plant density', '(number of plants per unit area)'),
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
                                decoration: buildInputDecoration('Soil texture'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Soil texture', 'Soil texture'),
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
                                decoration: buildInputDecoration('Soil color'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Soil color', 'Soil color'),
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
                                decoration: buildInputDecoration('Temperature'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Temperature', '(in degrees Celsius)'),
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
                                decoration: buildInputDecoration('Humidity (in percentage)'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Humidity (in percentage)', 'Humidity (in percentage)'),
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
                                decoration: buildInputDecoration('Rainfall (in mm)'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Rainfall (in mm)', 'Rainfall (in mm)'),
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
                                decoration: buildInputDecoration('Water source'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Water source', 'Water source (Well, River, Canal, Rainwater harvesting, Municipal supply)'),
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
                                decoration: buildInputDecoration('Irrigation method'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Irrigation method', 'Irrigation method (Drip, Flood, Sprinkler)'),
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
                                decoration: buildInputDecoration('Fertilizer type used in the previous season'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Fertilizer type used in the previous season', '(Organic, Inorganic, both)'),
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
                                decoration: buildInputDecoration('Crop rotation'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Crop rotation', 'Crop rotation (Yes, No)'),
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
                                decoration: buildInputDecoration('Pest and disease infestation'),
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Pest and disease infestation', 'Pest and disease infestation (Yes, No)'),
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
                                decoration: buildInputDecoration('Slope of the land'), // The height of the plant
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () => bottomSheet('Slope of the land', 'Slope of the land (None, Low, Medium, High)'),
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
                                'Proceed',
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
        ],
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
