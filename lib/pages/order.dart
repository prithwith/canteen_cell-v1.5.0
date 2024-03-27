// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, camel_case_types, no_logic_in_create_state, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/Multipleorder.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class order extends StatefulWidget {
  // const order({super.key});
  User user;
  String timechange;
  order(this.user, this.timechange);

  @override
  State<order> createState() => _orderState(user, timechange);
}

class _orderState extends State<order> {
  User user;
  String timechange;
  _orderState(this.user, this.timechange);
  List<String> orderdatelist = [];
  List<String> holidayist = [];

  DateTime _currentDateTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (mounted) {
          setState(() {
            _currentDateTime = DateTime.now();
          });
        }
      },
    );
  }

  Future orderdates(String roll) async {
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
        orderdatelist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          orderdatelist.add(
            jsondata['data'][i]['Date'],
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future adminholidays() async {
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
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(_currentDateTime);
    String formattedTime = DateFormat('hh:mm a').format(_currentDateTime);
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          backgroundColor: P.appbar2,
          title: Text(
            'Order Meal',
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
                padding: EdgeInsets.all(
                  25,
                ),
                child: Lottie.asset(
                  "Assets/lotti/food_anime.json",
                  height: 222,
                ),
              ),
              FDottedLine(
                strokeWidth: 2.0,
                dottedLength: 8.0,
                space: 3.0,
                corner: FDottedLineCorner.all(5),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 35,
                  ),
                  color: P.secondtheamecolor,
                  width: 350,
                  alignment: Alignment.topLeft,
                  child: Center(
                    child: Column(
                      children: [
                        AutoSizeText(
                          "-: Current Date & Time :-".toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          maxLines: 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: AutoSizeText(
                            "$formattedDate ---- $formattedTime",
                            style: TextStyle(
                              fontSize: 21,
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
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return LoadingDialog();
                            });
                        orderdates(user.Roll).whenComplete(
                          () {
                            adminholidays().whenComplete(
                              () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Multipleorder(
                                      user,
                                      orderdatelist,
                                      holidayist,
                                      timechange,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          Padding(
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
                              fontSize: 16,
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
