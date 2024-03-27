// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, constant_identifier_names, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/adminpage.dart';
import 'package:canteen_cell/pages/appupdatepage.dart';
import 'package:canteen_cell/pages/userdashboard.dart';
import 'package:canteen_cell/pages/UserSelection.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => SplashState();
}

class SplashState extends State<Splash> {
  static const String KEYLOGIN = 'login';
  static const String ADMINKEYLOGIN = 'loginkey';
  int newversionno = 0, versionno = 8;
  String app_url = "", versioncode = "0.0", changelog = "";
  @override
  void initState() {
    super.initState();
    getVersionCode().whenComplete(() => nextpage());
  }

  Future getVersionCode() async {
    try {
      var response = await http.get(
        Uri.parse("${MyUrl.fullurl}app_update.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == 'true') {
        newversionno = int.parse(jsondata['version_no']);
        versioncode = jsondata['version_code'];
        app_url = jsondata['app_url'];
        changelog = jsondata['change_log'];
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Occurred");
    }
  }

  void nextpage() async {
    var prefs = await SharedPreferences.getInstance();
    bool isloggin = prefs.getBool(KEYLOGIN) ?? false;
    bool adminloggin = prefs.getBool(ADMINKEYLOGIN) ?? false;

    String username = prefs.getString("username") ?? "";
    String batch = prefs.getString("batch") ?? "";
    String email = prefs.getString("email") ?? "";
    String roll = prefs.getString("roll") ?? "";
    String image = prefs.getString("image") ?? "";
    String balance = prefs.getString("balance") ?? "";
    String password = prefs.getString("password") ?? "";

    String aid = prefs.getString("aid") ?? "";
    String aimage = prefs.getString("aimage") ?? "";
    String aname = prefs.getString("aname") ?? "";
    String aemail = prefs.getString("aemail") ?? "";
    String apassword = prefs.getString("apassword") ?? "";
    int usertype = prefs.getInt("usertype") ?? 0;

    Timer(
      Duration(seconds: 2),
      () {
        if (newversionno > versionno) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AppUpdatePage(newversionno, versioncode, app_url, changelog),
            ),
          );
        } else if (adminloggin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => adminpage(
                Admin(aid, aimage, aname, aemail, apassword, usertype),
              ),
            ),
          );
        } else if (isloggin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Myapp(
                User(username, batch, email, roll, image, balance, password),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => logins(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 40,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(
                left: 111,
                right: 111,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "Assets/images/apicon.png",
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                  AutoSizeText(
                    "CCLMS Canteen",
                    style: GoogleFonts.lobster(
                      textStyle: TextStyle(
                        fontSize: 20,
                        color: P.appbar2,
                      ),
                    ),
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 40,
            color: Color.fromARGB(255, 17, 54, 178),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: AutoSizeText(
                "Developed By Prithwith,Modified By CCLMS IT Team",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
