//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_2/const/AppColors.dart';
//import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/widgets/fetchProducts.dart';
//import 'package:firebase_auth/firebase_auth.dart';
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
      body: SafeArea(child: fetchData("users-cart-item", Icon(Icons.delete))),
    );
  }
}
