import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:todoapp/screens/search.dart';
import './screens/favorite.dart';
import './screens/setting.dart';
import './screens/home.dart';
import 'package:todoapp/themes/colors.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({
    super.key,
  });

  @override
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    const FavoriteScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor, //  Colors.white, //Atento a editar
      body: SafeArea(
        child: screens[selectedIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.5),
        child: GNav(
          color: tdBlack,
          activeColor: tdBlack,
          tabBackgroundColor: Colors.black12,
          tabBorderRadius: 20,
          padding: const EdgeInsets.all(10.5),
          gap: 8.0,
          tabs: const [
            GButton(icon: Icons.home_outlined, text: 'Home'),
            GButton(icon: Icons.search_outlined, text: 'Precios'),
            GButton(icon: Icons.favorite, text: 'Favorito'),
            GButton(icon: Icons.settings_outlined, text: 'Config'),
          ],
          onTabChange: (i) {
            setState(() {
              selectedIndex = i;
            });
          },
          selectedIndex: selectedIndex,
        ),
      ),
    );
  }
}
