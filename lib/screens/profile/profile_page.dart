import 'dart:convert';

import 'package:banana_digital/services/shared_preference.dart';
import 'package:banana_digital/utils/app_colors.dart';
import 'package:banana_digital/utils/app_configs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? accessToken;
  String? proPic;

  @override
  void initState() {
    firstnameController.text = UserSharedPreference.getFirstName().toString();
    lastnameController.text = UserSharedPreference.getLastName().toString();
    emailController.text = UserSharedPreference.getEmail().toString();
    proPic = UserSharedPreference.getProPic().toString();
    usernameController.text = UserSharedPreference.getUserName().toString();
    accessToken = UserSharedPreference.getAccessToken().toString();
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
    var url = Uri.parse(USER_PROFILE_UPDATE);
    final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
        body: jsonEncode({
          "first_name": firstnameController.text,
          "last_name": lastnameController.text,
        }));

    if (response.statusCode == 200) {
      await UserSharedPreference.setFirstName(firstnameController.text);
      await UserSharedPreference.setLastName(lastnameController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "User Updated."),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: TextWidget(label: "Something went wrong!"),
          backgroundColor: Colors.red,
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 80,
//                            backgroundColor: Colors.blue,
//                            backgroundImage: AssetImage('assets/ashe_logo.png'),
                          child: ClipOval(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image(
                                // height: 50,
                                image: AssetImage(AppImages.logoTW),
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 130,
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
                            // changeImage(ImageSource.camera);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      right: 240,
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
                            // changeImage(ImageSource.gallery);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15)),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Form(
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                                    borderRadius: BorderRadius.circular(10.0),
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
                        const SizedBox(height: 25),
                        SizedBox(
                          height: 55,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
