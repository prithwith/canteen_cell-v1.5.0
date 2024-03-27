// ignore_for_file: prefer_const_constructors

import 'package:canteen_cell/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "CCLMS Canteen",
      home: Splash(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
