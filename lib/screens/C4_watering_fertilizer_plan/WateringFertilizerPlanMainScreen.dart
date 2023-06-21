import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:banana_digital/models/WateringPlanHistoryModel.dart';
import 'package:banana_digital/screens/C4_watering_fertilizer_plan/WateringPlanResultScreen.dart';
import 'package:http/http.dart' as http;
import 'package:banana_digital/models/WeatherApiModel.dart';
import 'package:banana_digital/services/weather_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/WateringPlanModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../../widgets/TextWidget.dart';

class WateringFertilizerPlanMainScreen extends StatefulWidget {
  const WateringFertilizerPlanMainScreen({Key? key}) : super(key: key);

  @override
  State<WateringFertilizerPlanMainScreen> createState() => _WateringFertilizerPlanMainScreenState();
}

class _WateringFertilizerPlanMainScreenState extends State<WateringFertilizerPlanMainScreen> with SingleTickerProviderStateMixin {

  late TabController tabController;

  CroppedFile? croppedImg;

  WeatherApiModel? weatherData;

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

  String? locationRegion;
  String? localTime;
  String? name;
  String? tzId;
  int? humidity;
  double? avgTemperature;
  double? rainfall;

  String? accessToken;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() { });
    });
    getWeatherData();
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
    });
  }

  Future getWeatherData() async {
    try {
      final response = await WeatherApiService.getWeatherData();
      final resData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        weatherData = WeatherApiModel.fromJson(resData);
        if (mounted) {
          setState(() {
            locationRegion = weatherData!.location!.region;
            localTime = weatherData!.location!.localtime;
            name = weatherData!.location!.name;
            tzId = weatherData!.location!.tzId;
            humidity = weatherData!.current!.humidity;
            avgTemperature = weatherData!.current!.tempC;
            rainfall = weatherData!.current!.precipMm;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: TextWidget(label: response.reasonPhrase.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (err) {
      if (kDebugMode) {
        print("================= Catch Error ====================");
        print(err);
        print("==================================================");
      }
    }
  }


  Future makeThePlans() async {
    Map<String, String> dataBody = {
      'pH': soilPhController.text.trim(),
      'organic_matter_content': selectedOrganicMatterContent.toString().toLowerCase(),
      'avg_temperature': avgTemperature.toString(),
      'avg_rainfall': rainfall.toString(),
      'plant_height': plantDensityController.text.trim(),
      'leaf_color': selectedLeafColor,
      'stem_diameter': stemDimeterController.text.trim(),
      'plant_density': plantDensityController.text.trim(),
      'soil_moisture': '25',
      'soil_texture': selectedSoilTexture,
      'soil_color': selectedSoilColor,
      'temperature': avgTemperature.toString(),
      'humidity': humidity.toString(),
      'rainfall': rainfall.toString(),
      'water_source': selectedWaterSource,
      'irrigation_method': selectedIrrigationMethod,
      'fertilizer_used_last_season': selectedFertilizerUsedLastSeason.toString().toLowerCase(),
      'crop_rotation': selectedCropRotation.toString().toLowerCase(),
      'pest_disease_infestation': selectedPestDiseaseInfestation.toString().toLowerCase(),
      'slope': selectedSlope.toString().toLowerCase(),
    };

    if (tabController.index == 0) {
      await wateringPlan(dataBody, croppedImg);
    } else {
      await fertilizerPlan(dataBody, croppedImg);
    }
  }


  Future wateringPlan(dataBody, croppedImg) async {
    try {
      var headers = {
        'Authorization': 'Bearer $accessToken'
      };
      var url = Uri.parse(WATERING_PLAN); // url define
      var request = http.MultipartRequest(
          'POST', url); // create multipart request
      var multipartFile = await http.MultipartFile.fromPath(
          'soil_image', croppedImg.path);

      request.fields.addAll(dataBody); // set tha data body
      request.files.add(multipartFile); // multipart that takes file
      request.headers.addAll(headers); // set the headers

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        Map<String, dynamic> data = await jsonDecode(resString);
        final wateringPlan = WateringPlanModel.fromJson(data);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
            WateringPlanResultScreen(wateringPlan: wateringPlan)));
      }
      else {
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
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
        print("================= Catch Error ====================");
        print(err);
        print("==================================================");
      }
    }
  }

  Future fertilizerPlan(dataBody, croppedImg) async {
    print("F=====> $dataBody");
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
                                    Text('Current Region ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Avg Temperature (in Celsius) ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Avg Humidity (%) ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Avg Rainfall (in mm) ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('Avg Soil Moisture (%) ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: (weatherData != null) ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(':  ${locationRegion.toString()}/${name.toString()}'),
                                    const SizedBox(height: 5),
                                    Text(':  ${avgTemperature.toString()}'),
                                    const SizedBox(height: 5),
                                    Text(':  ${humidity.toString()}'),
                                    const SizedBox(height: 5),
                                    Text(':  ${rainfall.toString()}'),
                                    const SizedBox(height: 5),
                                    Text(':  ${0.toString()}'),
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
                          if (weatherData != null)
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
                          if (weatherData != null)
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
                          if (weatherData != null)
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
                                            style: TextStyle(fontSize: 20),
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
                                          makeThePlans();
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
