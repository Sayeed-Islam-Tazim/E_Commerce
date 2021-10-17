import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/ui/bottom_nav_pages/cart.dart';
import 'package:e_commerce_2/ui/bottom_nav_pages/favourite.dart';
import 'package:e_commerce_2/ui/bottom_nav_pages/home.dart';
import 'package:e_commerce_2/ui/bottom_nav_pages/profile.dart';
import 'package:e_commerce_2/ui/bottom_nav_pages/provider.dart';
import 'package:flutter/material.dart';

class BottomNavController extends StatefulWidget {
  BottomNavController({Key? key}) : super(key: key);

  @override
  _BottomNavControllerState createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  final _pages = [Home(), Cart(), Favourite(), Profile(), FlutterProvider()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey,
          elevation: 5,
          selectedItemColor: AppColor.lightOrange,
          unselectedItemColor: Colors.white,
          showSelectedLabels: true,
          selectedLabelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_shopping_cart),
                label: "Cart",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline),
                label: "Favourite",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
                backgroundColor: Colors.grey),
            BottomNavigationBarItem(
                icon: Icon(Icons.functions_sharp),
                label: "Provider",
                backgroundColor: Colors.grey),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
