// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:auth_app/screens/home_screen.dart';
import 'package:auth_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:multi_dropdown/enum/app_enums.dart';
import 'package:multi_dropdown/models/chip_config.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  File? image;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _firstNameTextController = TextEditingController();
  TextEditingController _lastNameTextController = TextEditingController();
  TextEditingController _locationNameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _bioTextController = TextEditingController();
  MultiSelectController _interestcontroller = MultiSelectController();
  MultiSelectController _programController = MultiSelectController();

  _imgFromCamera() async {
    try {
      final imageTemp = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      final imageTemporary = File(imageTemp!.path);
      setState(() {
        image = imageTemporary;
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
        image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  void _showPicker(context) {
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

  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    List<String> genderOptions = ['Male', 'Female', 'Other'];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.3),
                    child: image != null
                        ? Image.file(
                            image!,
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.height * 0.18,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey,
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.height * 0.18,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter First Name", Icons.person_outline,
                    false, _firstNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Last Name", Icons.person_outline,
                    false, _lastNameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField(
                    "Enter Location",
                    Icons.location_city_outlined,
                    false,
                    _locationNameTextController),
                const SizedBox(
                  height: 20,
                ),
                ageTextField("Enter Age", Icons.person_outline, false,
                    _ageTextController),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Text(
                      'Select Gender',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton<String>(
                      dropdownColor: Colors.purple,
                      onChanged: (newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                      value: selectedGender,
                      items: genderOptions.map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(
                            gender,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                reusableTextField("Enter Bio", Icons.person_outline, false,
                    _bioTextController),
                const SizedBox(
                  height: 20,
                ),
                MultiSelectDropDown(
                  showClearIcon: true,
                  controller: _programController,
                  onOptionSelected: (options) {
                    debugPrint(options.toString());
                  },
                  options: const <ValueItem>[
                    ValueItem(label: 'Python', value: '1'),
                    ValueItem(label: 'JavaScript', value: '2'),
                    ValueItem(label: 'Java', value: '3'),
                    ValueItem(label: 'C++', value: '4'),
                    ValueItem(label: 'Ruby', value: '5'),
                    ValueItem(label: 'Swift', value: '6'),
                    ValueItem(label: 'PHP', value: '7'),
                    ValueItem(label: 'C#', value: '8'),
                    ValueItem(label: 'Go', value: '9'),
                    ValueItem(label: 'Rust', value: '10'),
                  ],
                  maxItems: 5,
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
                const SizedBox(
                  height: 20,
                ),
                MultiSelectDropDown(
                  showClearIcon: true,
                  controller: _interestcontroller,
                  onOptionSelected: (options) {
                    debugPrint(options.toString());
                  },
                  options: const <ValueItem>[
                    ValueItem(label: 'Reading', value: '1'),
                    ValueItem(label: 'Cooking and Baking', value: '2'),
                    ValueItem(label: 'Sports', value: '3'),
                    ValueItem(label: 'Gardening', value: '4'),
                    ValueItem(label: 'Painting and Drawing', value: '5'),
                    ValueItem(
                        label: 'Hiking and Outdoor Activities', value: '6'),
                    ValueItem(label: 'Music', value: '7'),
                    ValueItem(label: 'Photography', value: '8'),
                    ValueItem(label: 'Board Games and Puzzles', value: '9'),
                    ValueItem(label: 'Collecting', value: '10'),
                  ],
                  maxItems: 5,
                  selectionType: SelectionType.multi,
                  chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                  dropdownHeight: 300,
                  optionTextStyle: const TextStyle(fontSize: 16),
                  selectedOptionIcon: const Icon(Icons.check_circle),
                ),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Email", Icons.email_outlined, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outlined, true,
                    _passwordTextController),
                const SizedBox(
                  height: 20,
                ),
                firebaseUIButton(context, "Sign Up", () async {
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                    print("Created New Account");
                  }).onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                  var user = FirebaseAuth.instance.currentUser;
                  final ref = FirebaseStorage.instance
                      .ref()
                      .child('user_images')
                      .child(user!.uid)
                      .child(user.uid + '.jpg');
                  await ref.putFile(image!).whenComplete(() {
                    print('UPLOADED TO STORAGE');
                  });
                  final url = await ref.getDownloadURL();
                  final interestsList = [];
                  _interestcontroller.selectedOptions.forEach((element) {
                    // print(element.label);
                    interestsList.add(element.label);
                  });
                  final programList = [];
                  _programController.selectedOptions.forEach((element) {
                    // print(element.label);
                    programList.add(element.label);
                  });
                  Map<String, dynamic> map = {
                    'first_name': _firstNameTextController.text,
                    'last_name': _lastNameTextController.text,
                    'email': _emailTextController.text,
                    'uid': FirebaseAuth.instance.currentUser!.uid,
                    'image_url': url,
                    'location': _locationNameTextController.text,
                    'age': _ageTextController.text,
                    'gender': selectedGender,
                    'programming_languages_known': programList,
                    'bio': _bioTextController.text,
                    'interests': interestsList,
                  };
                  print(map);
                  await database
                      .child('Users')
                      .child(FirebaseAuth.instance.currentUser!.uid)
                      .set(map)
                      .then(
                    (value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  );
                })
              ],
            ),
          ))),
    );
  }
}
