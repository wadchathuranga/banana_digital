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

  final List waterSource = ["River", "Rainwater Harvesting", "Municipal Supply", "Well", "Canal"];
  var selectedWaterSource;

  final List organicMatterContent = ["Low", "Moderate", "High"];
  var selectedOrganicMatterContent;

  final List cropRotation = ["Yes", "No"];
  var selectedCropRotation;

  final List pestDiseaseInfestation = ["Yes", "No"];
  var selectedPestDiseaseInfestation;

  final List slope = ["Low", "Medium", "High", "High"];
  var selectedSlope;

  final List irrigationMethod = ["Drip", "Sprinkle", "Flood"];
  var selectedIrrigationMethod;

  final List fertilizerUsedLastSeason = ["Organic", "Non Organic", "Both Used", "None"];
  var selectedFertilizerUsedLastSeason;

  final List soilTexture = ["Loamy", "Clayey", "Sandy"];
  var selectedSoilTexture;

  final List soilColor = ["Red", "Brown", "Yellow", "Dark", "Black"];
  var selectedSoilColor;


  @override
  Widget build(BuildContext context) {

    // TextFormField common InputDecoration function
    InputDecoration buildInputDecoration(String hintText) {
      return InputDecoration(
        labelText: hintText,
        // labelStyle: const TextStyle(fontSize: 18),
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
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                },
                                // onSaved: (value) => _username = value,
                                decoration: buildInputDecoration('Temperature'),
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
                          ],
                        ),
                        buildSizedBox(),
                        buildSizedBox(),
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
                                  labelText: 'Fertilizer Used Last Season',
                                ),
                                items: fertilizerUsedLastSeason.map((value) {
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
                                    selectedFertilizerUsedLastSeason = newValueSelected!;
                                  });
                                },
                                value: selectedFertilizerUsedLastSeason,
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
                                  labelText: 'Water Source',
                                ),
                                items: waterSource.map((value) {
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
                                    selectedWaterSource = newValueSelected!;
                                  });
                                },
                                value: selectedWaterSource,
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
                                  labelText: 'Organic Matter Content',
                                ),
                                items: organicMatterContent.map((value) {
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
                                    selectedOrganicMatterContent = newValueSelected!;
                                  });
                                },
                                value: selectedOrganicMatterContent,
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
                                  labelText: 'Crop Rotation',
                                ),
                                items: cropRotation.map((value) {
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
                                    selectedCropRotation = newValueSelected!;
                                  });
                                },
                                value: selectedCropRotation,
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
                                  labelText: 'Pest Disease Infestation',
                                ),
                                items: pestDiseaseInfestation.map((value) {
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
                                    selectedPestDiseaseInfestation = newValueSelected!;
                                  });
                                },
                                value: selectedPestDiseaseInfestation,
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
                                  labelText: 'Slope of the Land',
                                ),
                                items: slope.map((value) {
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
                                    selectedSlope = newValueSelected!;
                                  });
                                },
                                value: selectedSlope,
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
                                  labelText: 'Irrigation Method',
                                ),
                                items: irrigationMethod.map((value) {
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
                                    selectedIrrigationMethod = newValueSelected!;
                                  });
                                },
                                value: selectedIrrigationMethod,
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
                                  labelText: 'Soil texture',
                                ),
                                items: soilTexture.map((value) {
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
                                    selectedSoilTexture = newValueSelected!;
                                  });
                                },
                                value: selectedSoilTexture,
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
                                  labelText: 'Soil Color',
                                ),
                                items: soilColor.map((value) {
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
                                    selectedSoilColor = newValueSelected!;
                                  });
                                },
                                value: selectedSoilColor,
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
                                keyboardType: TextInputType.number,
                                decoration: buildInputDecoration('Plant Density'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                },
                                keyboardType: TextInputType.number,
                                decoration: buildInputDecoration('Stem Diameter'),
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
                                keyboardType: TextInputType.number,
                                decoration: buildInputDecoration('Plant Height'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {
                                    return 'Required!';
                                  } else if (double.parse(val) > 0.0 || double.parse(val) <= 14.0) {
                                    return 'It should between 1 and 14';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: buildInputDecoration('Soil pH'),
                                keyboardType: TextInputType.number,
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
      selectedIrrigationMethod = null;
      selectedSlope = null;
      selectedPestDiseaseInfestation = null;
      selectedWaterSource = null;
      selectedOrganicMatterContent = null;
      selectedCropRotation = null;
      selectedFertilizerUsedLastSeason = null;
      selectedSoilTexture = null;
      selectedSoilColor = null;
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
