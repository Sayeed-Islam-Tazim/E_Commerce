import 'dart:ui';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/ui/item_details.dart';
import 'package:e_commerce_2/ui/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _carouselImages = [];
  List _products = [];
  var _dotsPosition = 0;
  TextEditingController _searchController = TextEditingController();
  var _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img"],
        );
        // print(
        //   qn.docs[i]["img"],
        // );
      }
    });
    return qn.docs;
  }

  fetchProducts() async {
    QuerySnapshot qn = await _firestoreInstance.collection("products").get();

    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _products.add({
          "product-desc": qn.docs[i]["product-desc"],
          "product-img": qn.docs[i]["product-img"],
          "product-name": qn.docs[i]["product-name"],
          "product-price": qn.docs[i]["product-price"],
        });
      }
    });
  }

  @override
  void initState() {
    fetchProducts();
    fetchCarouselImages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "E Commerce",
                style: TextStyle(
                    color: AppColor.lightOrange,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 60,
                        child: TextField(
                          readOnly: true,
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Search here",
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: AppColor.lightOrange),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: AppColor.lightOrange),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => SearchScreen()));
                          },
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   child: Container(
                    //     height: 60,
                    //     width: 60,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: AppColor.lightOrange),
                    //     child: Center(
                    //       child: Icon(
                    //         Icons.search,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     //Navigator.push(context,MaterialPageRoute(builder: (_) => Favourite()));
                    //   },
                    // )
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 3.5,
                child: CarouselSlider(
                  items: _carouselImages
                      .map(
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
              DotsIndicator(
                dotsCount:
                    _carouselImages.length == 0 ? 1 : _carouselImages.length,
                position: _dotsPosition.toDouble(),
                decorator: DotsDecorator(
                    color: Colors.grey,
                    activeColor: AppColor.lightOrange,
                    spacing: EdgeInsets.all(2),
                    size: Size(6, 6),
                    activeSize: Size(8, 8)),
              ),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        //print(_products[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ItemDetails(_products[index])));
                      },
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            AspectRatio(
                              aspectRatio: 2,
                              child: Image.network(
                                  _products[index]["product-img"][1]),
                            ),
                            SizedBox(height: 10),
                            Text(
                              _products[index]["product-name"],
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 10),
                            Text(_products[index]["product-price"].toString(),
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
