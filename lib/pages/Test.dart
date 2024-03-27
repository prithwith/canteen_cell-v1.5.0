// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "oppose! No internet connection found",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
