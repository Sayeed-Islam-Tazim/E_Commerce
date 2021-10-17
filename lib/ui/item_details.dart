import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/widgets/customButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class ItemDetails extends StatefulWidget {
  var _product;
  ItemDetails(this._product);

  @override
  _ItemDetailsState createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int _dotsPosition = 0;
  //double half = MediaQuery.of(context).size.width / 2;

  Future addDataToCart() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-cart-item");
    return collectionRef.doc(currentUser!.email).collection("items").doc().set({
      'name': widget._product['product-name'],
      'images': widget._product['product-img'],
      'price': widget._product['product-price'],
    }).then((value) =>
        Fluttertoast.showToast(msg: "Item Added to cart Successfully"));
  }

  Future addDataToFavourite() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection("users-favourite-item");
    return collectionRef.doc(currentUser!.email).collection("items").doc().set({
      'name': widget._product['product-name'],
      'images': widget._product['product-img'],
      'price': widget._product['product-price'],
    }).then((value) => Fluttertoast.showToast(msg: "Item Added to Favourite"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: AppColor.lightOrange,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.white,
              ),
            ),
          ),
          actions: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-favourite-item")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .where('name', isEqualTo: widget._product['product-name'])
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Text("Nothing to show");
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: AppColor.lightOrange,
                    child: IconButton(
                      onPressed: () {
                        // Navigator.push(context,
                        //     CupertinoPageRoute(builder: (_) => Favourite()));
                        snapshot.data.docs.length == 0
                            ? addDataToFavourite()
                            : Fluttertoast.showToast(msg: "Already Added");
                      },
                      icon: snapshot.data.docs.length == 0
                          ? Icon(Icons.favorite_outline)
                          : Icon(Icons.favorite),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                  items: widget._product['product-img']
                      .map<Widget>(
                        (item) => Padding(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(item),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      onPageChanged: (val, carouselPageChangedReason) {
                        setState(() {
                          _dotsPosition = val;
                        });
                      }),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: DotsIndicator(
                  dotsCount: widget._product['product-img'].length == 0
                      ? 1
                      : widget._product['product-img'].length,
                  position: _dotsPosition.toDouble(),
                  decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: AppColor.lightOrange,
                      spacing: EdgeInsets.all(2),
                      size: Size(6, 6),
                      activeSize: Size(8, 8)),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  widget._product['product-name'],
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(widget._product['product-desc']),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text(
                      '\$ ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.lightOrange),
                    ),
                    Text(
                      widget._product['product-price'].toString(),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.lightOrange),
                    ),
                  ],
                ),
              ),
              Center(
                child: customButton("Add to Cart", () {
                  addDataToCart();
                }, Icons.shopping_cart),
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
