// ignore_for_file: prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names

import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Adminorderhistory.dart';
import 'package:canteen_cell/pages/Adminorderredeem.dart';
import 'package:canteen_cell/pages/admverifyorder.dart';
import 'package:flutter/material.dart';

class Adminorder extends StatefulWidget {
  // const Adminorder({super.key});
  Admin admin;
  Adminorder(this.admin);

  @override
  State<Adminorder> createState() => _AdminorderState(admin);
}

class _AdminorderState extends State<Adminorder> {
  Admin admin;
  _AdminorderState(this.admin);
  int currentindex = 0;

  late List<StatefulWidget> Screens = [
    admverifyorder(admin),
    Adminorderredeem(),
    Adminorderhistory(),
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
                Icons.delivery_dining_rounded,
              ),
              label: 'NOt Redeemed'.toUpperCase(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.redeem,
              ),
              label: 'Redeemed'.toUpperCase(),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'history'.toUpperCase(),
            ),
          ],
        ),
      ),
    );
  }
}
