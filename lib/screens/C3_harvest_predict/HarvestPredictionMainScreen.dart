import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../services/C3_harvest_prediction_api_service.dart';
import '../../models/HarvestPredictionModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_configs.dart';
import '../../widgets/LanguagePicker.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import './HarvestPredictionResultScreen.dart';

class HarvestPredictionMainScreen extends StatefulWidget {
  const HarvestPredictionMainScreen({Key? key}) : super(key: key);

  @override
  State<HarvestPredictionMainScreen> createState() => _HarvestPredictionMainScreenState();
}

class _HarvestPredictionMainScreenState extends State<HarvestPredictionMainScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  // Varieties for day prediction
  TextEditingController harvestDayController = TextEditingController();
  final _varietyFormKey = GlobalKey<FormState>();
  late List<dynamic> varietiesForDay = [];
  var varietyHarvestDayRes;
  var selectedVarietyForDay;
  bool isFetchinData = false;


  // Harvest prediction
  final _qaFormKey = GlobalKey<FormState>();

  TextEditingController heightController = TextEditingController();
  TextEditingController leavesController = TextEditingController();
  TextEditingController phController = TextEditingController();
  TextEditingController spaceController = TextEditingController();

  bool isLoading = false;

  String? accessToken;

  final List varieties = ["Anamalu Banana", "Mysore Banana", "Pisang Awak Banana", "Silk Banana", "Amban Banana"];
  var selectedVariety;

  final List climaticRegions = ["Wet Zone", "Dry Zone", "Intermediate Zone"];
  var selectedClimaticRegion;

  final List plantDensity = ["1", "2", "3","4", "5"];
  var selectedPlantDensity;

  var selectedPesticide;

  final List plantGeneration = ["1", "2", "3","4", "5", "More than 5"];
  var selectedPlantGeneration;

  final List fertilizerTypes = ["Organic", "Non Organic", "Both Used", "None"];
  var selectedFertilizerType;

  final List wateringSchedule = ["Twice a week", "Randomly", "None", "3 times a week", "Daily"];
  var selectedWateringSchedule;

  final List sunlightReceived = ["Low", "Moderate", "High"];
  var selectedSunlightReceived;

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

  void clearFormData() {
    setState(() {
      _qaFormKey.currentState!.reset();
      selectedSunlightReceived = null;
      selectedClimaticRegion = null;
      selectedPlantDensity = null;
      selectedPesticide = null;
      selectedFertilizerType = null;
      selectedPlantGeneration = null;
      selectedVariety = null;
      selectedWateringSchedule = null;
      heightController.clear();
      leavesController.clear();
      phController.clear();
      spaceController.clear();
    });
  }

  void clearHarvestDayForm() {
    setState(() {
      _varietyFormKey.currentState!.reset();
      selectedVarietyForDay = null;
      harvestDayController.clear();
    });
  }

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    tabController = TabController(length: 2, vsync: this);
    getAllVarieties();
    super.initState();
  }

  // predict harvest
  Future estimateHarvest() async {
    try {
      final bodyData = {
        "variety": selectedVariety,
        "agro_climatic_region": selectedClimaticRegion,
        "plant_density": int.parse(selectedPlantDensity),
        "pesticides_used": selectedPesticide,
        "plant_generation": selectedPlantGeneration,
        "fertilizer_type": selectedFertilizerType,
        "amount_of_sunlight": selectedSunlightReceived,
        "watering_schedule": selectedWateringSchedule.toString().toLowerCase(),
        "spacing_between_plants": spaceController.text,
        "number_of_leaves": leavesController.text,
        "soil_ph": double.parse(phController.text),
        "height": double.parse(heightController.text),
      };

      // var url = Uri.parse('$HARVEST_PREDICTION/predict');
      // final response = await http.post(
      //     url,
      //     headers: {
      //       "Content-Type": "application/json",
      //       "Authorization": "Bearer $accessToken",
      //     },
      //     body: jsonEncode(bodyData));

      http.Response response = await C3HarvestPredictionApiService.estimateHarvest(accessToken: accessToken!, bodyData: bodyData);

      final resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        final result = HarvestPredictionModel.fromJson(resData);
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HarvestPredictionResultScreen(result: result)));
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        if (kDebugMode) {
          print(resData['error']);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: resData['error']),
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
        print("================= Catch Error [estimateHarvest()] ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future getAllVarieties() async {
    try {
      // var url = Uri.parse(HARVEST_PREDICTION_GET_ALL_VARITIES);
      // final response = await http.get(
      //   url,
      //   headers: {
      //     "Authorization": "Bearer $accessToken",
      //   },
      // );

      http.Response response = await C3HarvestPredictionApiService.getAllVarieties(accessToken: accessToken!);

      final resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          varietiesForDay = resData;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
            backgroundColor: Colors.red,
          ),
        );
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error [getAllVarieties()] ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future calculateDay(varietyId, age) async {
    try {
      // var url = Uri.parse('$HARVEST_PREDICTION_DAYS?variety=$varietyId&age=$age');
      // final response = await http.get(
      //   url,
      //   headers: {
      //     "Authorization": "Bearer $accessToken",
      //   },
      // );

      http.Response response = await C3HarvestPredictionApiService.calculateHarvestingDay(accessToken: accessToken!, varietyId: varietyId, age: age);

      final resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (!mounted) return;
          setState(() {
            varietyHarvestDayRes = resData['estimated_harvesting_time'];
            isFetchinData = false;
          });
      } else {
        if (kDebugMode) {
          print(response.reasonPhrase);
        }
        if (!mounted) return;
          setState(() {
            isFetchinData = true;
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
          isFetchinData = true;
        });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Harvest Prediction'),
            actions: [
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/C3_harvest_history'),
                icon: const Icon(Icons.history),
              ),
              // const LanguagePicker(),
              const SizedBox(
                width: 10,
              ),
            ],
            bottom: TabBar(
              controller: tabController,
              tabs: const [
                Tab(text: 'Harvest', icon: Icon(Icons.nature_outlined)),
                Tab(text: 'Days', icon: Icon(Icons.calendar_month_outlined))
              ],
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              harvestPredict(),
              harvestDayPredict()
            ],
          ),
        ),
    );
  }

  Widget harvestPredict() {
    return Stack(
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
                                labelText: 'Plant Density',
                              ),
                              items: plantDensity.map((value) {
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
                                  selectedPlantDensity = newValueSelected!;
                                });
                              },
                              value: selectedPlantDensity,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                              },
                              decoration: buildInputDecoration('Spacing between plants'), // The distance between adjacent banana plants
                              keyboardType: TextInputType.number,
                              controller: spaceController,
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
                                labelText: 'Pesticides Used',
                              ),
                              items: ["Yes", "No"].map((value) {
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
                                  selectedPesticide = newValueSelected!;
                                });
                              },
                              value: selectedPesticide,
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
                                labelText: 'Plant Generation',
                              ),
                              items: plantGeneration.map((value) {
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
                                  selectedPlantGeneration = newValueSelected!;
                                });
                              },
                              value: selectedPlantGeneration,
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
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Required!';
                                } else if (double.parse(val) < 0.0 || double.parse(val) > 14.0) {
                                  return 'It should between 1 and 14';
                                } else {
                                  return null;
                                }
                              },
                              decoration: buildInputDecoration('Soil pH'),
                              keyboardType: TextInputType.number,
                              controller: phController,
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
                                labelText: 'Sunlight Received',
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
                              decoration: buildInputDecoration('Number of Leaves'),
                              keyboardType: TextInputType.number,
                              controller: leavesController,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                              },
                              decoration: buildInputDecoration('Height (in feet)'),
                              keyboardType: TextInputType.number,
                              controller: heightController,
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
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'Clear Form',
                              // style: TextStyle(fontSize: 20),
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
                            borderRadius: BorderRadius.circular(10), // Border radius
                          ),
                        ),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                            child: Text(
                              'Estimate the Harvest',
                              // style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_qaFormKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            estimateHarvest();
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

  Widget harvestDayPredict() {
    return Stack(
      fit: StackFit.expand,
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Get remains days to get the harvest',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Using the provided data bellow, you can estimate the banana harvest, press the button to proceed with prediction process.',
                ),
                const SizedBox(height: 30),
                Form(
                  key: _varietyFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              items: varietiesForDay.map((variety) {
                                return DropdownMenuItem(
                                  value: variety['id']
                                      .toString(),
                                  child: Text(variety['variety']
                                      .toString()),
                                );
                              }).toList(),
                              onChanged: (newValueSelected) {
                                FocusScope.of(context).requestFocus(FocusNode());
                                setState(() {
                                  selectedVarietyForDay = newValueSelected!;
                                });
                              },
                              value: selectedVarietyForDay,
                              isExpanded: false,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                              },
                              decoration: buildInputDecoration('Age'),
                              keyboardType: TextInputType.number,
                              controller: harvestDayController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Border radius
                                ),
                              ),
                              child: SizedBox(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: const Center(
                                  child: Text(
                                    'Clear Data',
                                    // style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                              onPressed: () =>  clearHarvestDayForm(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_varietyFormKey.currentState!.validate()) {
                                    calculateDay(selectedVarietyForDay, harvestDayController.text);
                                    setState(() {
                                      isFetchinData = true;
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10), // Border radius
                                  ),
                                ),
                                child: const Text('Calculate'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      if (varietyHarvestDayRes != null)
                        Text(
                            varietyHarvestDayRes.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          child: !isFetchinData
              ? null
              : const LoadingWidget(),
        ),
      ],
    );
  }


}
