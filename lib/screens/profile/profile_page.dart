import 'package:banana_digital/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/PopupMenu.dart';
import '../../utils/app_images.dart';
import '../zoom_drawer_menu/menu_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  //update user details
  Future _updateProfile() async {
    // var data = {
    //   "username": usernameController.text,
    //   "email": emailController.text,
    // };
    // databaseReference.child('Users').child(userId).update(data);
    // print(data);
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
                    // key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'User Name',
                            suffixIcon: Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          // controller: usernameController,
                        ),
                        const Padding(padding: EdgeInsets.all(5.0)),
                        TextFormField(
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
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            suffixIcon: Icon(
                              Icons.edit,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          // controller: emailController,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                    child: const Text('Update Details'),
                    onPressed: () {
                      // if (_formKey.currentState!.validate()) {
                      //   setState(() {
                      //     _isLoading = true;
                      //   });
                      //   _updateProfile();
                      // }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
