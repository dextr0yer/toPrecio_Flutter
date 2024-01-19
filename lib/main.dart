import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:todoapp/screens/home.dart';
import 'package:todoapp/navigation_Bar.dart';
import 'package:todoapp/themes/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      title: 'Material App',
      home: const NavigationBarWidget(),
    );
  }
}
