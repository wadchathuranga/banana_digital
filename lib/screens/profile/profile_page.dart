import 'dart:convert';
import 'dart:io';
import 'package:banana_digital/services/auth_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/shared_preference.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_configs.dart';
import '../../widgets/Loading.dart';
import '../../widgets/PopupMenu.dart';
import '../../utils/app_images.dart';
import '../../widgets/TextWidget.dart';
import '../zoom_drawer_menu/menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  CroppedFile? _croppedImg;

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? accessToken;
  String? proPic;

  void refreshState() {
    firstnameController.text = UserSharedPreference.getFirstName().toString();
    lastnameController.text = UserSharedPreference.getLastName().toString();
    emailController.text = UserSharedPreference.getEmail().toString();
    proPic = UserSharedPreference.getProPic().toString();
    usernameController.text = UserSharedPreference.getUserName().toString();
    accessToken = UserSharedPreference.getAccessToken().toString();
  }

  @override
  void initState() {
    refreshState();
    super.initState();
  }

  @override
  void dispose() {
    firstnameController.clear();
    lastnameController.clear();
    usernameController.clear();
    emailController.clear();
    super.dispose();
  }

  //update user details
  Future _updateProfile() async {
    // var url = Uri.parse(USER_PROFILE_UPDATE);
    // final response = await http.patch(
    //     url,
    //     headers: {
    //       "Content-Type": "application/json",
    //       "Authorization": "Bearer $accessToken",
    //     },
    //     body: jsonEncode({
    //       "first_name": firstnameController.text,
    //       "last_name": lastnameController.text,
    //     }));
    final response = await AuthApiService.updateUserProfile(firstnameController.text.trim(), lastnameController.text.trim(), accessToken!);

    if (response.statusCode == 200) {
      await UserSharedPreference.setFirstName(firstnameController.text);
      await UserSharedPreference.setLastName(lastnameController.text);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "User Updated."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "Something went wrong!"),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

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

    // Upload image
    Future uploadProfileImage(imageFile) async {
      try {
        // // string to uri
        // var uri = Uri.parse(USER_PROFILE_UPDATE);
        //
        // // create multipart request
        // var request = http.MultipartRequest("PATCH", uri);
        //
        // // multipart that takes file
        // var multipartFile = await http.MultipartFile.fromPath('profile_pic', imageFile.path, filename: '${UserSharedPreference.getUserName().toString()}.jpg');
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
        // http.StreamedResponse response = await request.send();
        final response = await AuthApiService.updateUserProfilePicture(accessToken!, imageFile);

        setState(() {
          isLoading = false;
        });

        if (response.statusCode == 200) {
          final resString = await response.stream.bytesToString();
          final resData = await jsonDecode(resString);
          UserSharedPreference.setProPic(resData['profile_pic']);
          refreshState();
          setState(() {
            isLoading = false;
            _croppedImg = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: TextWidget(label: "User Profile Updated."),
              backgroundColor: Colors.green,
            ),
          );
        }
        else {
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


    return Scaffold(
      appBar: AppBar(
        leading: const MenuWidget(),
        title: const Text('Profile'),
        actions: const [
          PopupMenu()
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child:  Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: CircleAvatar(
                            radius: 80,
//                            backgroundColor: Colors.blue,
//                            backgroundImage: AssetImage(AppImages.deProPic),
                            child: ClipOval(
                              child: SizedBox(
                                height: 155,
                                width: 155,
                                child: _imageWidget(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 110,
                        bottom: 40,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
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
                      ),
                      Positioned(
                        right: 230,
                        bottom: 40,
                        child: CircleAvatar(
                          backgroundColor: AppColors.primaryColor,
                          child: IconButton(
                            icon: const Icon(
                              Icons.image,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              pickImage(ImageSource.gallery);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                        onPressed: _croppedImg == null
                            ? null
                            : () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    uploadProfileImage(_croppedImg);
                                  }
                                },
                        child: const Text('Update Image'),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 50)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'User Name',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: usernameController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                validator: (email) {
                                  RegExp regExp = RegExp(
                                      r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                  if (email!.trim().isEmpty) {
                                    return "Email is required!";
                                  } else if (!regExp.hasMatch(email)) {
                                    return "Invalid Email Format!";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                controller: emailController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'First Name',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                controller: firstnameController,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.trim().isEmpty) {return 'Required!';} else {return null;}
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  labelText: 'Last Name',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.edit,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                controller: lastnameController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text('Update Details'),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  _updateProfile();
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: !isLoading
                ? null
                : const LoadingWidget(msg: 'Updating...'),
          ),
        ],
      ),
    );
  }

  // image widget
  _imageWidget() {
    if (_croppedImg != null) {
      final imgPath = _croppedImg!.path;
      return Image.file(File(imgPath));
    } else {
      return proPic != 'null'
          ? Image(
        fit: BoxFit.cover,
        image: NetworkImage(proPic!),
      )
          : Image(
        fit: BoxFit.cover,
        image: AssetImage(AppImages.deProPic),
      );
    }
  }

}
