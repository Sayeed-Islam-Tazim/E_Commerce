import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Favourite extends StatefulWidget {
  Favourite({Key? key}) : super(key: key);

  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "E Commerce Favourite Items",
            style: TextStyle(
                color: AppColor.lightOrange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users-favourite-item")
                .doc(FirebaseAuth.instance.currentUser!.email)
                .collection("items")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text("Something went wrong"));
              }

              if (snapshot.data == null) {
                return Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                      snapshot.data!.docs[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: Text(_documentSnapshot['name']),
                      title: Text(
                        "\$ ${_documentSnapshot['price']}",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.lightOrange),
                      ),
                      trailing: GestureDetector(
                        child: CircleAvatar(
                          child: Icon(Icons.remove_circle),
                          backgroundColor: AppColor.lightOrange,
                          foregroundColor: Colors.white,
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection("users-favourite-item")
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .doc(_documentSnapshot.id)
                              .delete();
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
