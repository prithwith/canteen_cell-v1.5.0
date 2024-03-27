// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Stafflists.dart';
import 'package:canteen_cell/pages/studentslist.dart';
import 'package:flutter/material.dart';

class Userstafflist extends StatefulWidget {
  const Userstafflist({super.key});

  @override
  State<Userstafflist> createState() => _UserstafflistState();
}

class _UserstafflistState extends State<Userstafflist> {
  int currentindex = 0;

  final Screens = [
    studentslist(),
    Userlists(),
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
              label: "Student's",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
              ),
              label: "Staff's",
            ),
          ],
        ),
      ),
    );
  }
}
