import 'package:flutter/material.dart';
import 'package:todoapp/themes/colors.dart';
// import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: tdBGColor, elevation: 0, title: Text('Home')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.home_outlined,
                size: 100,
              ),
              Text('Home Screen'),
            ],
          ),
        ),
      ),
    );
  }
}
