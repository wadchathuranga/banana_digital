import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ScreenOne extends StatefulWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  CroppedFile? _croppedImg;

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: const Text('One'),
      ),
      body: SingleChildScrollView(
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
                            backgroundColor: Colors.black,
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
                            backgroundColor: Colors.black,
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
                _imageWidget(),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 6 * 4,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _croppedImg == null
                          ? null
                          : () {
                              _proceedToClassification();
                            },
                      child: const Text(
                        'Proceed to Classification',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: const [
                    Text(
                      'Classification Results',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 50.0,
                      endIndent: 50.0,
                    ),
                    Text(
                      'Not Found! Please Try Again...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
          color: Colors.black12,
          child: const Icon(
            Icons.image_sharp,
            size: 250,
            color: Colors.black12,
          ),
        ),
      );
    }
  }

  _proceedToClassification() {
    // api call here
  }
}
