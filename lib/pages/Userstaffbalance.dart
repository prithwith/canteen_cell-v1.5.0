// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Staffbalanceadd.dart';
import 'package:canteen_cell/pages/adminbalance.dart';
import 'package:flutter/material.dart';

class Userstaffbalance extends StatefulWidget {
  const Userstaffbalance({super.key});

  @override
  State<Userstaffbalance> createState() => _UserstaffbalanceState();
}

class _UserstaffbalanceState extends State<Userstaffbalance> {
  int currentindex = 0;

  final Screens = [
    adminbalance(),
    Staffbalanceadd(),
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
                Icons.school,
              ),
              label: 'Students',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: 'Staffs',
            ),
          ],
        ),
      ),
    );
  }
}
