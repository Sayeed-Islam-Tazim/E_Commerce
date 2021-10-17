import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  Cart({Key? key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "E Commerce Cart Items",
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
              .collection("users-cart-item")
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
                DocumentSnapshot _documentSnapshot = snapshot.data!.docs[index];
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
                        child: Icon(Icons.delete),
                        backgroundColor: AppColor.lightOrange,
                        foregroundColor: Colors.white,
                      ),
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection("users-cart-item")
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
    );
  }
}
