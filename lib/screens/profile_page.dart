// import 'dart:convert';
//
// import 'package:async/async.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// // import 'package:image_cropper/image_cropper.dart';
// // import 'package:image/image.dart' as Img;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:image_picker/image_picker.dart';
//
// import 'package:path/path.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../main.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//
//   // File _image;
//   // var userId;
//   // String currentImgUrl;
//   // String networkImgName;
//
//   //network images location path url here
// //  String networkImgUrl = "http://192.168.43.206/flutter/profilePic/";
//   String networkImgUrl = "https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/profilePic/";
//
//   bool _isLoading = false;
//
//   final _formKey = GlobalKey<FormState>();
//
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//
//   // SharedPreferences sharedPreferences;
//   // String currentEmail;
//
//   @override
//   void initState() {
//     super.initState();
//     getSession();
//   }
//
//   //check user still logged in
//   getSession() async {
//   //   sharedPreferences = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     usernameController.text = sharedPreferences.getString('session_username');
//   //     emailController.text = sharedPreferences.getString('session_email');
//   //     currentEmail = sharedPreferences.getString('session_email');
//   //   });
//     _getCurrentProPic();
//   }
//
//   //get current profile image
//   _getCurrentProPic() async {
//     // var jsonImage = null;
//     // final responseImg = await http.post(
//     //     "https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/viewProPic.php",
//     //     body: {'email': currentEmail});
//     // if (responseImg.statusCode == 200) {
//     //   jsonImage = json.decode(responseImg.body);
//     //   print(jsonImage);
//     //   if (jsonImage[0]['image'] != "") {
//     //     //for ignore error memory leak or delay of load network data
//     //     if (mounted) {
//     //       setState(() {
//     //         networkImgName = jsonImage[0]['image'];
//     //         print(networkImgName);
//     //       });
//     //     }
//     //   } else if (jsonImage[0]['msg'] == 'error') {
//     //     msg = 'Server Connection Error!';
//     //     showToast();
//     //     print(responseImg.body);
//     //   } else {
//     //     msg = 'Please upload your profile picture';
//     //     showToast();
//     //     print(responseImg.body);
//     //   }
//     // } else {
//     //   msg = 'System Error!';
//     //   showToast();
//     //   print(responseImg.body);
//     // }
//   }
//
//
//
//
//   //toast msg method
//   void showToast(String msg) {
//     Fluttertoast.showToast(
//         msg: msg,
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     //choose image & upload to db
// //     Future changeImage(ImageSource source) async {
// //       //get image camera or gallery
// //       File imageFromMobileDevice = await ImagePicker.pickImage(source: source);
// //       //crop & compress image
// //       File croppedSelectedImg = await ImageCropper.cropImage(
// //         sourcePath: imageFromMobileDevice.path,
// //         aspectRatioPresets: [
// //           CropAspectRatioPreset.original,
// //           CropAspectRatioPreset.square,
// //           CropAspectRatioPreset.ratio3x2,
// //           CropAspectRatioPreset.ratio4x3,
// //           CropAspectRatioPreset.ratio5x3,
// //           CropAspectRatioPreset.ratio5x4,
// //           CropAspectRatioPreset.ratio7x5,
// //           CropAspectRatioPreset.ratio16x9
// //         ],
// //         compressQuality: 100,
// //         compressFormat: ImageCompressFormat.jpg,
// //         maxHeight: 700,
// //         maxWidth: 700,
// //         androidUiSettings: AndroidUiSettings(
// //             toolbarColor: Colors.blue,
// //             toolbarTitle: "Cropper Tool",
// //             toolbarWidgetColor: Colors.white,
// //             initAspectRatio: CropAspectRatioPreset.original,
// //             lockAspectRatio: false),
// //         /*iosUiSettings: IOSUiSettings(
// //           minimumAspectRatio: 1.0,
// //         ),*/
// //       );
// //
// //       final tmpDir = await getExternalStorageDirectory();
// //       final path = tmpDir.path;
// //
// //       String imgName = currentEmail;
// //
// //       Img.Image image = Img.decodeImage(croppedSelectedImg.readAsBytesSync());
// //       Img.Image smallerImage = Img.copyResize(image,
// //           height: 500,
// //           width: 500); //resize uploading image size changing image with & height
// //
// //       var compressedImage = File("$path/${imgName}_image.jpg")
// //         ..writeAsBytesSync(Img.encodeJpg(smallerImage,
// //             quality: 85)); //compress the image quality changing quality
// //
// //       setState(() {
// //         _image = compressedImage;
// //         print('Image Path: $_image');
// //       });
// //
// //       //upload image to db -------------------------------------------------------------------------------------------------
// //       var stream = http.ByteStream(DelegatingStream.typed(_image.openRead()));
// //
// //       var length = await _image.length();
// //
// // //      var uri = Uri.parse("http://192.168.43.206/flutter/uploadProfileImage.php");
// //       var uri = Uri.parse("https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/uploadProfileImage.php");
// //
// //       var request = http.MultipartRequest("POST", uri);
// //
// //       var multipartFile = http.MultipartFile("image", stream, length,
// //           filename: basename(_image.path));
// //
// //       request.fields['email'] = currentEmail;
// //       request.files.add(multipartFile);
// //
// //       var response = await request.send();
// //
// //       response.stream.transform(utf8.decoder).listen((event) {
// //         print(event);
// //       });
// //
// //       if (response.statusCode == 200) {
// //         msg = 'Profile Picture Updated';
// //         showToast();
// //         await Future.delayed(Duration(seconds: 2));
// //         msg = 'App should be restart';
// //         showToast();
// //         //for reload the details when details updated but it is not working!
// // //        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
// //         print("Image Uploaded");
// //       } else {
// //         print("Image Upload Failed!");
// //       }
// //     }
//
//     //update user details
//     void _updateProfile() async {
//       // var jsonUpdate = null;
//       // final response = await http.post("https://pastpaperssusl.000webhostapp.com/mobile_app_config/flutter/updateProfile.php", body: {
//       //   'currentEmail': currentEmail,
//       //   'username': usernameController.text.trim(),
//       //   'email': emailController.text.trim(),
//       // });
//       //
//       // if (response.statusCode == 200) {
//       //   jsonUpdate = json.decode(response.body);
//       //   print(jsonUpdate);
//       //   if (jsonUpdate[0]['msg'] == 'updated') {
//       //     setState(() {
//       //       sharedPreferences.setString(
//       //           'session_username', usernameController.text);
//       //       sharedPreferences.setString('session_email', emailController.text);
//       //       _isLoading = false;
//       //     });
//       //     msg = 'Profile Updated';
//       //     showToast();
//       //     //for reload the details when details updated but it is not working!
//       //     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyApp()), (Route<dynamic> route) => false);
//       //   } else {
//       //     setState(() {
//       //       _isLoading = false;
//       //     });
//       //     msg = 'Server Connection Error!';
//       //     showToast();
//       //     print(response.body);
//       //   }
//       // } else {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   msg = 'System Error!';
//       //   showToast();
//       //   print(response.body);
//       // }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Container(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(30.0),
//                           child: CircleAvatar(
//                             radius: 80,
// //                            backgroundColor: Colors.blue,
// //                            backgroundImage: AssetImage('assets/ashe_logo.png'),
//                             child: ClipOval(
//                               child: SizedBox(
//                                 height: 150,
//                                 width: 150,
//                                 child: _image != null
//                                     ? Image.file(
//                                         _image,
//                                         fit: BoxFit.cover,
//                                       )
//                                     : Container(
//                                         child:
//                                             networkImgName.toString() == "null"
//                                                 ? const Image(
//                                                     image: AssetImage(
//                                                         'assets/ashe_logo.png'),
//                                                   )
//                                                 : Image.network(
//                                                     "$networkImgUrl$networkImgName",
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                       ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 130,
//                         bottom: 40,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.blue,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.camera_alt,
//                               size: 25,
//                               color: Colors.white,
//                             ),
//                             onPressed: () {
//                               // changeImage(ImageSource.camera);
//                             },
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         right: 240,
//                         bottom: 40,
//                         child: CircleAvatar(
//                           backgroundColor: Colors.blue,
//                           child: IconButton(
//                             icon: Icon(
//                               Icons.image,
//                               size: 25,
//                               color: Colors.white,
//                             ),
//                             onPressed: () {
//                               // changeImage(ImageSource.gallery);
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(padding: EdgeInsets.only(top: 15)),
//                   Padding(
//                     padding: const EdgeInsets.all(18.0),
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: <Widget>[
//                           TextFormField(
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'User Name',
//                               suffixIcon: Icon(
//                                 Icons.edit,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             controller: usernameController,
//                           ),
//                           const Padding(padding: EdgeInsets.all(5.0)),
//                           TextFormField(
//                             validator: (email) {
//                               RegExp regExp = RegExp(
//                                   r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
//                               if (email!.trim().isEmpty) {
//                                 return "Email is required!";
//                               } else if (!regExp.hasMatch(email)) {
//                                 return "Invalid Email Format!";
//                               } else {
//                                 return null;
//                               }
//                             },
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Email',
//                               suffixIcon: Icon(
//                                 Icons.edit,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             controller: emailController,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                       child: const Text('Update Details'),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           setState(() {
//                             _isLoading = true;
//                           });
//                           _updateProfile();
//                         }
//                       }),
//                 ],
//               ),
//             ),
//           ),
//           Center(
//             child: !_isLoading
//                 ? null
//                 : Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     color: Colors.black54,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const <Widget>[
//                         CircularProgressIndicator(),
//                         Padding(
//                           padding: EdgeInsets.all(10.0),
//                           child: Text(
//                             'Please wait...',
//                             style: TextStyle(
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
