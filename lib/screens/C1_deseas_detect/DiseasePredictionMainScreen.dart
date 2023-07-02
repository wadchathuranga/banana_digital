import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/C1_disease_detection_api_service.dart';
import '../../models/DiseaseDetectionModel.dart';
import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../widgets/Loading.dart';
import '../chat_screen/TextWidget.dart';
import './DiseaseDetectionResultScreen.dart';

class DiseasePredictionMainScreen extends StatefulWidget {
  const DiseasePredictionMainScreen({Key? key}) : super(key: key);

  @override
  State<DiseasePredictionMainScreen> createState() => _DiseasePredictionMainScreenState();
}

class _DiseasePredictionMainScreenState extends State<DiseasePredictionMainScreen> {

  CroppedFile? _croppedImg;
  bool isLoading = false;

  String? accessToken;

  @override
  void initState() {
    accessToken = UserSharedPreference.getAccessToken().toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

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
      setState(() {
        _croppedImg = croppedSelectedImg;
      });
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Disease Detection'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _croppedImg = null;
              });
              Navigator.pushNamed(context, '/C1_disease_history');
            },
            icon: const Icon(Icons.history),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Select Image to Classify',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Text(
                      'Upload a new photo from your camera or gallery bellow, and once you have finalized the image selection, press the activated button to proceed with classification process.'),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 25,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    pickImage(ImageSource.camera);
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Camera'),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppColors.primaryColor,
                                radius: 25,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.image_search,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Gallery'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _imageWidget(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 6 * 4,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: _croppedImg == null
                              ? null
                              : () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _proceedToClassification(_croppedImg);
                                },
                          child: const Text(
                            'Proceed to Classification',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  _imageWidget() {
    if (_croppedImg != null) {
      final imgPath = _croppedImg!.path;
      return SizedBox(
          width: MediaQuery.of(context).size.width / 6 * 4,
          height: 250,
          child: Image.file(File(imgPath)));
    } else {
      return SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width / 6 * 4,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.black12,
          ),
          child: const Icon(
            Icons.image_sharp,
            size: 250,
            color: Colors.black12,
          ),
        ),
      );
    }
  }

  Future _proceedToClassification(imageFile) async {
    try {
      // // string to uri
      // var uri = Uri.parse(DISEASE_DETECTION);
      //
      // // create multipart request
      // var request = http.MultipartRequest("POST", uri);
      //
      // // multipart that takes file
      // var multipartFile = await http.MultipartFile.fromPath('image', imageFile.path);
      //
      // // add file to multipart
      // request.files.add(multipartFile);
      //
      // // herders
      // var headers = {
      //   'Authorization': 'Bearer $accessToken'
      // };
      //
      // // set headers to request
      // request.headers.addAll(headers);
      //
      // // send request

      http.StreamedResponse response = await C1DiseaseDetectionApiService.proceedToClassification(imageFile: imageFile, accessToken: accessToken!);

      if (response.statusCode == 200) {
        final resString = await response.stream.bytesToString();
        Map<String, dynamic> resData = await jsonDecode(resString);
        final diseaseDetection = DiseaseDetectionModel.fromJson(resData);
        if (!mounted) return;
          setState(() {
            isLoading = false;
          });
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => DiseaseDetectionResultScreen(data: diseaseDetection)));
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
        print("================= Catch Error ====================");
        print(err);
        print("==================================================");
      }
    }
  }
}
