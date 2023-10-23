// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auth_app/screens/edit_profile.dart';
import 'package:auth_app/utils/database.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DataBaseService().getUserDetails(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data;
            var userName =
                (userData as Map)['first_name'] + ' ' + userData['last_name'];
            var bio = userData['bio'];
            var imageUrl = userData['image_url'];
            var age = userData['age'];
            var gender = userData['gender'];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.black,
                  ),
                ),
                backgroundColor: Colors.white,
                title: Text(
                  userName,
                  // textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              body: Container(
                padding: EdgeInsets.only(top: 10, right: 20, left: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        imageUrl == null || imageUrl == ''
                            ? CircleAvatar(
                                backgroundColor: Colors.grey,
                                maxRadius:
                                    MediaQuery.of(context).size.width * 0.12,
                              )
                            : CircleAvatar(
                                maxRadius:
                                    MediaQuery.of(context).size.width * 0.12,
                                backgroundImage: NetworkImage(
                                  imageUrl,
                                ),
                              ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.55,
                              child: Text(
                                bio,
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Age: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  age,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Gender: ",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(gender),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfile(),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.purpleAccent, width: 0.5),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
