import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:todoapp/screens/home.dart';
import 'package:todoapp/navigation_Bar.dart';
import 'package:todoapp/themes/colors.dart';
// import 'package:todoapp/themes/colors.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        snackBarTheme: SnackBarThemeData(
          backgroundColor:
              Colors.green[700]?.withOpacity(0.8), // Color verde transparente
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
      title: 'Material App',
      home: const NavigationBarWidget(),
    );
  }
}
