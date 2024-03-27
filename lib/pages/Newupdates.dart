// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Newupdates extends StatefulWidget {
  const Newupdates({super.key});

  @override
  State<Newupdates> createState() => _NewupdatesState();
}

class _NewupdatesState extends State<Newupdates> {
  int newversionno = 0, versionno = 8;
  String app_url = "", versioncode = "0.0", changelog = "";

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
      Fluttertoast.showToast(
        msg: "Error Occurred",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "What's New",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Padding(
                //   padding: EdgeInsets.only(
                //     top: 15,
                //     left: 8.0,
                //     right: 8.0,
                //     bottom: 8.0,
                //   ),
                //   child: Text(
                //     "New Vesion: $versioncode found",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blue,
                //     ),
                //   ),
                // ),
                // Text("Please Update your App to Continue"),
                // SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   margin: EdgeInsets.only(
                //     top: 5,
                //     left: 25.0,
                //     right: 8.0,
                //   ),
                //   alignment: Alignment.center,
                //   child: Text(
                //     "Update the App by Clicking this Button",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(
                //     top: 5,
                //     left: 25.0,
                //     right: 8.0,
                //   ),
                //   alignment: Alignment.center,
                //   child: ElevatedButton(
                //     onPressed: () => launchUrl(
                //       Uri.parse(app_url),
                //       mode: LaunchMode.externalApplication,
                //     ),
                //     onLongPress: () {
                //       Clipboard.setData(
                //         ClipboardData(
                //           text: app_url,
                //         ),
                //       );
                //       Fluttertoast.showToast(
                //         msg: "Link Copied",
                //       );
                //     },
                //     child: Text("Update"),
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   margin: EdgeInsets.only(
                //     top: 15,
                //     left: 30,
                //     right: 8.0,
                //   ),
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     "Change Logs:",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Container(
                //   margin: EdgeInsets.only(
                //     top: 5,
                //     left: 35.0,
                //     right: 8.0,
                //   ),
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     changelog,
                //     style: TextStyle(
                //       fontSize: 15,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
