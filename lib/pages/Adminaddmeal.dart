// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Addanonymousmeal.dart';
import 'package:canteen_cell/pages/Addusermeal.dart';
import 'package:flutter/material.dart';

class Adminaddmeal extends StatefulWidget {
  const Adminaddmeal({super.key});

  @override
  State<Adminaddmeal> createState() => _AdminaddmealState();
}

class _AdminaddmealState extends State<Adminaddmeal> {
  int currentindex = 0;

  final Screens = [
    Addusermeal(),
    Addanonymousmeal(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Screens[currentindex],
        bottomNavigationBar: BottomNavigationBar(
          selectedIconTheme: IconThemeData(
            color: P.appbar2,
          ),
          selectedItemColor: P.appbar2,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          currentIndex: currentindex,
          onTap: (index) => setState(() => currentindex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people_outline_sharp,
              ),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Anonymous',
            ),
          ],
        ),
      ),
    );
  }
}
