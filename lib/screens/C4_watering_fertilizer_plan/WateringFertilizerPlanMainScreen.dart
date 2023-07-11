import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../services/C3_harvest_prediction_api_service.dart';
import '../../services/C4_watering_fertilizer_api_service.dart';
import '../../models/FertilizerPlanModel.dart';
import '../../services/weather_api_service.dart';
import '../../models/CurrentWeatherModel.dart';
import '../../screens/C4_watering_fertilizer_plan/WateringPlanResultScreen.dart';
import '../../models/WateringPlanModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import './FertilizerPlanResultScreen.dart';

class WateringFertilizerPlanMainScreen extends StatefulWidget {
  const WateringFertilizerPlanMainScreen({Key? key}) : super(key: key);

  @override
  State<WateringFertilizerPlanMainScreen> createState() => _WateringFertilizerPlanMainScreenState();
}

class _WateringFertilizerPlanMainScreenState extends State<WateringFertilizerPlanMainScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  CroppedFile? croppedImg;

  CurrentWeatherModel? weatherData;

  final _qaFormKey = GlobalKey<FormState>();
  TextEditingController plantDensityController = TextEditingController();
  TextEditingController soilPhController = TextEditingController();
  TextEditingController stemDimeterController = TextEditingController();
  TextEditingController plantHeightController = TextEditingController();

  bool isLoading = false;

  final List leafColor = ["Yellow", "Green"];
  var selectedLeafColor;

  final List waterSource = ["River", "Rainwater harvesting", "Municipal supply", "Well", "Canal"];
  var selectedWaterSource;

  final List organicMatterContent = ["Low", "Moderate", "High"];
  var selectedOrganicMatterContent;

  final List cropRotation = ["Yes", "No"];
  var selectedCropRotation;

  final List pestDiseaseInfestation = ["Yes", "No"];
  var selectedPestDiseaseInfestation;

  final List slope = ["Low", "Medium", "None", "High"];
  var selectedSlope;

  final List irrigationMethod = ["Drip", "Sprinkler", "Flood"];
  var selectedIrrigationMethod;

  final List fertilizerUsedLastSeason = ["Organic", "Inorganic"];
  var selectedFertilizerUsedLastSeason;

  final List soilTexture = ["Loamy", "Clayey", "Sandy"];
  var selectedSoilTexture;

  final List soilColor = ["Red", "Brown", "Yellow", "Dark", "Black"];
  var selectedSoilColor;

  final List<Map<String, String>> stage = [
    {"name": "Vegetative", "value": "vegetative"},
    {"name": "Pseudostem formation", "value": "pseudostem_formation"},
    {"name": "Shooting", "value": "shooting"},
    {"name": "Inflorescence initiation", "value": "inflorescence_initiation"},
    {"name": "Flowering", "value": "flowering"},
    {"name": "Fruit development", "value": "fruit_development"},
    {"name": "Harvest", "value": "harvest"}];
  var selectedStage;

  late List<dynamic> varietyList = [];
  var selectedVariety;

  String? locationRegion;
  String? localTime;
  String? name;
  String? tzId;
  int? humidity;
  double? temperature;
  double? avgTemperature;
  double? rainfall;
  double? avgRainfall;
  String? soilMoisture;

  String? accessToken;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() { });
    });
    getAvgWeatherData();
    getAllVarieties();
    getCurrentWeatherData();
    getSoilMoistureData();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
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
      selectedVariety = null;
      selectedStage = null;
    });
  }

  Future getAllVarieties() async {
    try {

      http.Response response = await C3HarvestPredictionApiService.getAllVarieties(accessToken: accessToken!);

      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          varietyList = jsonDecode(response.body);
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
        print("================= Catch Error: (getAllVarieties) ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future getSoilMoistureData() async {
    try {
      final soilMoistureRes = await WeatherApiService.getSoilMoistureData();

      if (soilMoistureRes.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          soilMoisture = jsonDecode(soilMoistureRes.body)['feeds'][0]['field1'];
        });
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error: (getSoilMoistureData) ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future getAvgWeatherData() async {
    try {
      final response = await WeatherApiService.getAvgWeatherData();

      if (!mounted) return;
      setState(() {
        avgTemperature = response['avgTemperature'];
        avgRainfall = response['avgRainfall'];
      });
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error: (getAvgWeatherData) ====================");
        print(err);
        print("==================================================");
      }
      Navigator.pop(context);
    }
  }

  Future getCurrentWeatherData() async {
    try {
      final response = await WeatherApiService.getCurrentWeatherData();

      final resData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        weatherData = CurrentWeatherModel.fromJson(resData);
        if (!mounted) return;
          setState(() {
            locationRegion = weatherData!.location!.region;
            name = weatherData!.location!.name;
            humidity = weatherData!.current!.humidity;
            temperature = weatherData!.current!.tempC;
            rainfall = weatherData!.current!.precipMm;
          });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: err.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error: (getWeatherData) ====================");
        print(err);
        print("==================================================");
      }
      Navigator.pop(context);
    }
  }

  Future makeRequestBody() async {
    print('===============${double.parse(soilPhController.text).toStringAsFixed(1)}');
    Map<String, String> dataBody = {
      // 'pH': double.parse(soilPhController.text).toStringAsFixed(1),
      'pH': soilPhController.text,
      'organic_matter_content': selectedOrganicMatterContent.toString().toLowerCase(),
      'avg_temperature': avgTemperature!.toStringAsFixed(2),
      'temperature': temperature.toString(),
      'avg_rainfall': avgRainfall!.toStringAsFixed(2),
      'rainfall': rainfall.toString(),
      'humidity': humidity.toString(),
      'plant_height': plantDensityController.text.trim(),
      'leaf_color': selectedLeafColor.toString(),
      'stem_diameter': stemDimeterController.text.trim(),
      'plant_density': plantDensityController.text.trim(),
      'soil_moisture': soilMoisture.toString(),
      'soil_texture': selectedSoilTexture.toString(),
      'soil_color': selectedSoilColor.toString(),
      'water_source': selectedWaterSource.toString(),
      'irrigation_method': selectedIrrigationMethod.toString(),
      'fertilizer_used_last_season': selectedFertilizerUsedLastSeason.toString().toLowerCase(),
      'crop_rotation': selectedCropRotation.toString().toLowerCase(),
      'pest_disease_infestation': selectedPestDiseaseInfestation.toString().toLowerCase(),
      'slope': selectedSlope.toString().toLowerCase(),
      "stage": selectedStage.toString(),
      "variety": selectedVariety.toString(),
    };

    if (tabController.index == 0) {
      await callToMakeThePlans(WATERING_PLAN, dataBody, croppedImg);
    } else {
      await callToMakeThePlans(FERTILIZER_PLAN, dataBody, croppedImg);
    }
  }

  Future callToMakeThePlans(urlConst, dataBody, croppedImg) async {
    try {

      http.StreamedResponse response = await C4WateringFertilizerApiService.predictThePlan(accessToken: accessToken!, urlConst: urlConst, croppedImg: croppedImg, dataBody: dataBody);

      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        final data = await jsonDecode(resString);
        print('===================\n${data}'); /// TODO: bug
        if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        if ( tabController.index == 0) {
          final wateringPlan = WateringPlanModel.fromJson(data);
          if (wateringPlan.error != null || wateringPlan.wateringPlan == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget(label: wateringPlan.error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                WateringPlanResultScreen(wateringPlan: wateringPlan)));
          }
        } else {
          final fertilizerPlan = FertilizerPlanModel.fromJson(data);
          if (fertilizerPlan.error != null || fertilizerPlan.fertilizerPlan == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: TextWidget(label: fertilizerPlan.error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                FertilizerPlanResultScreen(fertilizerPlan: fertilizerPlan)));
          }
        }
      }
      else {
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
    } catch (exception, stackTrace) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: TextWidget(label: exception.toString()),
          backgroundColor: Colors.red,
        ),
      );
      if (kDebugMode) {
        print("================= Catch Error: (callToMakeThePlans) ====================");
        print(exception);
        print("==================================================");
      }
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
      );
    }
  }


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

    // function
    Future pickImage(ImageSource source) async {
      //get image from camera or gallery
      final pickedImage = await ImagePicker().pickImage(source: source);

      //crop & compress image
      final croppedSelectedImg = await ImageCropper().cropImage(
        sourcePath: pickedImage!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 700,
        maxWidth: 700,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Cropper Tool",
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
        ],
      );
      if (croppedSelectedImg != null) {
        setState(() {
          croppedImg = croppedSelectedImg;
        });
      }
    }

    return WillPopScope(
      onWillPop: () {
        if (tabController.index != 0) {
          setState(() {
            isLoading = false;
            tabController.index = 0;
          });
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: (tabController.index == 0) ? const Text('Watering Plan') : const Text('Fertilizer Plan'),
          actions: [
            if (weatherData != null && soilMoisture != null && avgTemperature != null && avgRainfall != null)
              IconButton(
                onPressed: () {
                  if (tabController.index == 0) Navigator.pushNamed(context, '/C4_watering_history');
                  if (tabController.index == 1) Navigator.pushNamed(context, '/C4_fertilizer_history');
                },
                icon: const Icon(Icons.history),
            ),
            const SizedBox(
              width: 15,
            ),
          ],
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: 'Watering', icon: Icon(Icons.water_drop_outlined)),
              Tab(text: 'Fertilizer', icon: Icon(Icons.hourglass_bottom))
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Current Region',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Temperature (avg) ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Rainfall (avg)',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Humidity',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Soil Moisture',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: (weatherData != null && soilMoisture != null && avgTemperature != null && avgRainfall != null) ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(':  ${locationRegion.toString()}/${name.toString()}'),
                                    const SizedBox(height: 5),
                                    Text(':  ${temperature!.toStringAsFixed(2)} (${avgTemperature!.toStringAsFixed(2)}) °C'),
                                    const SizedBox(height: 5),
                                    Text(':  ${rainfall!.toStringAsFixed(2)} (${avgRainfall!.toStringAsFixed(2)}) mm'),
                                    const SizedBox(height: 5),
                                    Text(':  ${humidity.toString()} %'),
                                    const SizedBox(height: 5),
                                    Text(':  ${soilMoisture.toString()} m³/m³'),
                                  ],
                                ) : const SpinKitRing(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Form(
                      key: _qaFormKey,
                      child: Column(
                        children: [
                          if (weatherData != null && soilMoisture != null && avgTemperature != null && avgRainfall != null)
                            const Column(
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
                          const SizedBox(height: 10),
                          if (weatherData != null && soilMoisture != null && avgTemperature != null && avgRainfall != null)
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _imageWidget(),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => pickImage(ImageSource.camera),
                                      child: const SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Icon(Icons.camera_alt),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed: () => pickImage(ImageSource.gallery),
                                      child: const SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Icon(Icons.image_search),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          buildSizedBox(),
                          if (weatherData != null && soilMoisture != null && avgTemperature != null && avgRainfall != null)
                            Column(
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
                                      items: varietyList.map((variety) {
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
                                        labelText: 'Stage',
                                      ),
                                      items: stage.map((item) {
                                        return DropdownMenuItem(
                                          value: item['value'].toString(),
                                          child: Text(item['name'].toString()),
                                        );
                                      }).toList(),
                                      onChanged: (newValueSelected) {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        setState(() {
                                          selectedStage = newValueSelected!;
                                        });
                                      },
                                      value: selectedStage,
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
                                      controller: plantDensityController,
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
                                      controller: stemDimeterController,
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
                                      controller: plantHeightController,
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
                                      controller: soilPhController,
                                    ),
                                  ),
                                ],
                              ),
                              buildSizedBox(),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
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
                                          ),
                                        ),
                                      ),
                                      onPressed: () =>  clearFormData(),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 1,
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
                                           tabController.index == 0 ? 'Watering Plan' : 'Fertilizer Plan',
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (_qaFormKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          makeRequestBody();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(height: 100),
                                SpinKitCubeGrid(
                                  itemBuilder: (BuildContext context, int index) {
                                    return const DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                        ],
                      ),
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
      ),
    );
  }

  Widget _imageWidget() {
    if (croppedImg != null) {
      final imgPath = croppedImg!.path;
      return SizedBox(
          height: 150,
          width: 150,
          child: Image.file(File(imgPath)));
    } else {
      return SizedBox(
        height: 150,
        width: 150,
        child: Container(
          color: Colors.black12,
          child: const Icon(
            Icons.image_sharp,
            size: 120,
            color: Colors.black12,
          ),
        ),
      );
    }
  }

}
