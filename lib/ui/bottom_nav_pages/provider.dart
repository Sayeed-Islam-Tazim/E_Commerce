import 'package:e_commerce_2/business-logic/counter.dart';
import 'package:e_commerce_2/const/AppColors.dart';
import 'package:e_commerce_2/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlutterProvider extends StatelessWidget {
  const FlutterProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<Counter>(context, listen: true);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _counter.value.toString(),
                style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: AppColor.lightOrange),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customButton("Increment", () {
                    _counter.increment();
                  }, Icons.add),
                  SizedBox(width: 40),
                  customButton("Decrement", () {
                    _counter.decrement();
                  }, Icons.remove),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
