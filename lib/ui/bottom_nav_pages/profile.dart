import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController? _nameEditingController;
  TextEditingController? _ageEditingController;
  TextEditingController? _phoneEditingController;
  TextEditingController? _genderEditingController;
  TextEditingController? _dobEditingController;

  setDataOfUser(data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "Profile",
            style: TextStyle(
                color: AppColor.lightOrange,
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 15),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
                // "https://st2.depositphotos.com/1006318/5909/v/950/depositphotos_59095529-stock-illustration-profile-icon-male-avatar.jpg"
                "https://firebasestorage.googleapis.com/v0/b/e-commerce-2-6c9f0.appspot.com/o/1615395476072.png?alt=media&token=87d89b68-57a2-4fd9-b2a6-209700693596"),
          ),
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: _nameEditingController =
              TextEditingController(text: data['name']),
        ),
        TextFormField(
          controller: _ageEditingController =
              TextEditingController(text: data['age']),
        ),
        TextFormField(
          controller: _phoneEditingController =
              TextEditingController(text: data['phone']),
        ),
        TextFormField(
          controller: _genderEditingController =
              TextEditingController(text: data['gender']),
        ),
        TextFormField(
          controller: _dobEditingController =
              TextEditingController(text: data['dob']),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColor.lightOrange)),
          onPressed: () {
            updateData();
          },
          icon: Icon(Icons.update),
          label: Text("Update"),
        ),
      ],
    );
  }

  updateData() {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return collectionRef.doc(FirebaseAuth.instance.currentUser!.email).update({
      'name': _nameEditingController!.text,
      'phone': _phoneEditingController!.text,
      'age': _ageEditingController!.text,
      'gender': _genderEditingController!.text,
      'dob': _dobEditingController!.text,
    }).then((value) => Fluttertoast.showToast(msg: "Updated Successfully"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-form-data")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              var data = snapshot.data;
              if (data == null) {
                return Center(child: CircularProgressIndicator());
              }
              return setDataOfUser(data);
            },
          ),
        ),
      ),
    );
  }
}
