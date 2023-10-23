// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'dart:io';

import 'package:auth_app/screens/profile_screen.dart';
import 'package:auth_app/utils/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  File? imageUrl;
  bool? profilePictureExists;
  var initImageUrl = 'exists';

  _imgFromCamera() async {
    try {
      final imageTemp = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      final imageTemporary = File(imageTemp!.path);
      setState(() {
        imageUrl = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  _imgFromGallery() async {
    try {
      final imageTemp = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      final imageTemporary = File(imageTemp!.path);
      setState(() {
        imageUrl = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _showPicker(context, var initialImageUrl) {
    if (initialImageUrl == '' || initImageUrl == '') {
      profilePictureExists = false;
    } else {
      profilePictureExists = true;
    }
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListTile(
                  title: Text(
                    'Edit profile picture',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListTile(
                  title: Text(
                    'Take photo using camera',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                child: ListTile(
                    title: Text(
                      'Use photo using gallery',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text('   ')
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var initialFirstName;
    var initialLastName;
    var initialBio;
    var initialImageUrl;
    var initialAge;
    var firstName;
    var lastName;
    var bio;
    var age;
    return FutureBuilder(
        future: DataBaseService()
            .getUserDetails(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            initialFirstName = (userData as Map)['first_name'];
            initialLastName = userData['last_name'];
            initialBio = (userData)['bio'];
            initialImageUrl = userData['image_url'];
            initialAge = (userData)['age'];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                title: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.17,
                      ),
                      Text(
                        'Edit Profile',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.13,
                      ),
                      InkWell(
                        onTap: () async {
                          bool isValid = _formKey.currentState!.validate();
                          if (isValid) {
                            var user = FirebaseAuth.instance.currentUser;
                            var url = '';
                            final ref = FirebaseStorage.instance
                                .ref()
                                .child('user_images')
                                .child(user!.uid)
                                .child(user.uid + '.jpg');
                            if (imageUrl != null) {
                              if (initImageUrl == '') {
                                await ref.putFile(imageUrl!).whenComplete(() {
                                  print('UPLOADED TO STORAGE');
                                });
                              } else if (initImageUrl == 'exists') {
                                await ref.putFile(imageUrl!).whenComplete(() {
                                  print('UPLOADED TO STORAGE');
                                });
                              } else {
                                await ref.delete();
                                await ref.putFile(imageUrl!).whenComplete(() {
                                  print('UPLOADED TO STORAGE');
                                });
                              }
                              url = await ref.getDownloadURL();
                            } else {
                              if (initImageUrl == '') {
                                await ref.delete();
                                url = '';
                              } else {
                                url = await ref.getDownloadURL();
                              }
                            }
                            Map<String, dynamic> map = {
                              'first_name': firstName ?? initialFirstName,
                              'last_name': lastName ?? initialLastName,
                              'bio': bio ?? initialBio,
                              'image_url': url,
                              'age': age ?? initialAge,
                            };
                            await DataBaseService().updateUserDetails(map);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                  uid: user.uid,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              content: Text(
                                "Form not valid",
                                textAlign: TextAlign.left,
                              ),
                            ));
                          }
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.037,
                          // width: MediaQuery.of(context).size.width * 0.17,
                          height: 30,
                          width: 60,
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontFamily: 'Roboto'),
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black12,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                  child: Center(
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  InkWell(
                    onTap: () {
                      _showPicker(context, initialImageUrl);
                    },
                    child: ClipOval(
                      child: imageUrl == null
                          ? Container(
                              child: initialImageUrl == '' || initImageUrl == ''
                                  ? CircleAvatar(
                                      backgroundColor: Colors.grey,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(initialImageUrl!),
                                    ),
                              color: Colors.grey,
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.height * 0.18,
                            )
                          : Image.file(
                              imageUrl!,
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.height * 0.18,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                  Text(
                    'Tap to edit profile picture',
                    style: TextStyle(
                        color: Color(0xffbacbbbbbb),
                        fontSize: 15,
                        fontFamily: 'Roboto'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a first name';
                              }
                            },
                            onChanged: (value) {
                              firstName = value;
                            },
                            initialValue: initialFirstName,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'First Name',
                              filled: true,
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.045,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a last name';
                              }
                            },
                            onChanged: (value) async {
                              lastName = value;
                            },
                            initialValue: initialLastName,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Last Name',
                              filled: true,
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.045,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter a bio';
                              }
                            },
                            onChanged: (value) async {
                              bio = value;
                            },
                            initialValue: initialBio,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(180),
                            ],
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Bio',
                              filled: true,
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an age';
                              }
                            },
                            onChanged: (value) async {
                              age = value;
                            },
                            initialValue: initialAge,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Age',
                              filled: true,
                              labelStyle:
                                  TextStyle(color: Colors.grey, fontSize: 19),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              )),
            );
          } else {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
