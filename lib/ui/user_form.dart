import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/ui/bottom_nav_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserForm extends StatefulWidget {
  UserForm({Key? key}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _phoneEditingController = TextEditingController();
  TextEditingController _dobEditingController = TextEditingController();
  TextEditingController _genderEditingController = TextEditingController();
  TextEditingController _ageEditingController = TextEditingController();
  List<String> gender = ["Male", "Female", "Other"];

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null) {
      setState(() {
        _dobEditingController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  //final FirebaseAuth _auth = FirebaseAuth.instance;

  var currentUser = FirebaseAuth.instance.currentUser;

  Future sendUserDatatoDB() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameEditingController.text,
          "phone": _phoneEditingController.text,
          "dob": _dobEditingController.text,
          "gender": _genderEditingController.text,
          "age": _ageEditingController.text,
        })
        .then((value) =>
            //Fluttertoast.showToast(msg: "User Data Added"))
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => BottomNavController())))
        .catchError((error) =>
            Fluttertoast.showToast(msg: "Something is wrong!. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
          child: Center(
            child: ListView(
              children: [
                Text(
                  "Submit the form to continue.",
                  style: TextStyle(
                    color: AppColor.lightOrange,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("We will not share your information with anyone."),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: _nameEditingController,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                  ),
                ),
                TextField(
                  controller: _phoneEditingController,
                  decoration: InputDecoration(
                    labelText: "Phone number",
                  ),
                ),
                TextField(
                  controller: _dobEditingController,
                  decoration: InputDecoration(
                    labelText: "Date of Birth",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _selectDateFromPicker(context);
                      },
                      icon: Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                TextField(
                  controller: _genderEditingController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: "Choose your Gender",
                      suffixIcon: DropdownButton<String>(
                        items: gender.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                            onTap: () {
                              setState(() {
                                _genderEditingController.text = value;
                              });
                            },
                          );
                        }).toList(),
                        onChanged: (_) {},
                      )),
                ),
                TextField(
                  controller: _ageEditingController,
                  decoration: InputDecoration(
                    labelText: "Age",
                  ),
                ),
                SizedBox(
                  height: 90,
                ),
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColor.lightOrange),
                  ),
                  onPressed: () {
                    sendUserDatatoDB();
                  },
                  icon: Icon(Icons.arrow_forward_ios),
                  label: Text("Submit"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
