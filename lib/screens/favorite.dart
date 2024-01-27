import 'package:flutter/material.dart';
import 'package:todoapp/themes/colors.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: tdBGColor,
            elevation: 0,
            title: Text('Inventario')),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.shopping_bag_outlined,
                size: 100,
              ),
              Text('Inventario Screen'),
            ],
          ),
          // ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     // Add your onPressed code here!
          //   },
          //   backgroundColor: Colors.green,
          //   child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
