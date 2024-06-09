import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:storedge/pages/add_new.dart';
import 'package:storedge/pages/docs_gen_screen.dart';
import 'package:storedge/pages/main_screen.dart';


class Lobby_Screen extends StatefulWidget {
  const Lobby_Screen({super.key});

  @override
  State<Lobby_Screen> createState() => _Lobby_ScreenState();
}

class _Lobby_ScreenState extends State<Lobby_Screen> {
    void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      body: Center(child: _page.elementAt(_selectedIndex)),
      bottomNavigationBar: Container(
        color: const Color(0xFFB8B6D7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            tabBackgroundColor: const Color(0xFFC5C9E8),
            gap: 4,
            padding: const EdgeInsets.all(15),
            tabs: const [
              GButton(
                icon: Icons.list,
                text: "Главная",
                iconSize: 30,
              ),
              GButton(
                icon: Icons.star,
                text: "Добавить",
                iconSize: 30,
              ),
              GButton(
                icon: Icons.map,
                text: "Список",
                iconSize: 30,
              ),
              GButton(
                icon: Icons.supervised_user_circle,
                text: "Профиль",
                iconSize: 30,
              )
            ],
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
          ),
        ),
      ),
    ));
  }
  static final List<Widget> _page = <Widget>[
    ProductCarousel(),
    Add_Screen(),
    DocsGenScreen(),
  ];
}