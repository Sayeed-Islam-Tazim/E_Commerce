import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:e_commerce_2/const/AppColors.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var inputsearch = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                onChanged: (val) {
                  setState(() {
                    inputsearch = val;
                    print(inputsearch);
                    //Fluttertoast.showToast(msg: inputsearch);
                  });
                },
              ),
              Expanded(
                child: Container(
                  //color: AppColor.lightOrange,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("product-name", isEqualTo: inputsearch)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text("Something went wrong!"),
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Text("Loading"),
                        );
                      }

                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(data['product-name']),
                              leading: Image.network(data['product-img'][0]),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
