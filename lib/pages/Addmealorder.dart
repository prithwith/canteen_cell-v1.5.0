// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:canteen_cell/pages/Addmealorderdates.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Addmealorder extends StatefulWidget {
  // const Addmealorder({super.key});
  Signupgetdata passroll;
  Addmealorder(this.passroll);

  @override
  State<Addmealorder> createState() => _AddmealorderState(passroll);
}

class _AddmealorderState extends State<Addmealorder> {
  Signupgetdata passroll;
  _AddmealorderState(this.passroll);
  List<String> orderdatelist = [];
  List<String> holidayist = [];
  String timechange = "00:00:00";

  Future orderdates(String roll) async {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(),
      barrierDismissible: false,
    );
    Map data = {"Roll": roll};
    try {
      var response = await http.post(
        Uri.parse(
          MyUrl.fullurl + "student_alreadyordered.php",
        ),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "true") {
        Navigator.pop(context);
        orderdatelist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          orderdatelist.add(
            jsondata['data'][i]['Date'],
          );
        }
      } else {
        Navigator.pop(context);
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future adminholidays() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse(
          MyUrl.fullurl + "student_holidays.php",
        ),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "true") {
        holidayist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          holidayist.add(
            jsondata['data'][i]['Dates'],
          );
        }
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future fetchtime() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "time.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        setState(() {
          timechange = jsondata['data'][0]['time'];
        });
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    String formattedTime = DateFormat('hh:mm a').format(
      DateTime.now(),
    );
    return SafeArea(
      child: Scaffold(
        // backgroundColor: P.secondtheamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            'Add Meal',
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Image.asset(
                  "Assets/images/apicon.png",
                  height: 120,
                  width: 120,
                ),
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(
                  15,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      P.appbar2,
                      Colors.grey,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: MyUrl.fullurl + MyUrl.imageurl + passroll.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 100,
                          width: 110,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.red),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: imageProvider,
                            ),
                          ),
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AutoSizeText(
                          passroll.username.toUpperCase(),
                          style: TextStyle(
                            color: P.textcolor,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          passroll.batch,
                          style: TextStyle(
                            color: P.textcolor,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          passroll.email,
                          style: TextStyle(
                            color: P.textcolor,
                          ),
                          maxLines: 1,
                        ),
                        AutoSizeText(
                          passroll.roll,
                          style: TextStyle(
                            color: P.textcolor,
                          ),
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            AutoSizeText(
                              "Avaliable Balance:-",
                              style: TextStyle(
                                color: P.textcolor,
                              ),
                              maxLines: 2,
                            ),
                            AutoSizeText(
                              "₹" + passroll.balance,
                              style: TextStyle(
                                color: P.textcolor,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FDottedLine(
                strokeWidth: 2.0,
                dottedLength: 8.0,
                space: 3.0,
                corner: FDottedLineCorner.all(5),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  color: Colors.white,
                  width: 350,
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Current Date & Time".toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: AutoSizeText(
                            "$formattedDate ---- $formattedTime",
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                heightFactor: 2,
                child: SizedBox.fromSize(
                  size: Size(130, 130),
                  child: Card(
                    shadowColor: Color.fromARGB(255, 49, 78, 194),
                    elevation: 10,
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        orderdates(passroll.roll).whenComplete(
                          () {
                            adminholidays().whenComplete(
                              () {
                                fetchtime().whenComplete(
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Addmealorderdates(
                                          passroll.roll,
                                          timechange,
                                          orderdatelist,
                                          holidayist,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 60,
                              color: Colors.blueGrey,
                            ),
                          ),
                          AutoSizeText(
                            "Order Now",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
