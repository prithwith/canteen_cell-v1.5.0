// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Adminsettings extends StatefulWidget {
  // const Adminsettings({super.key});
  Admin admin;
  Adminsettings(this.admin);

  @override
  State<Adminsettings> createState() => _AdminsettingsState(admin);
}

class _AdminsettingsState extends State<Adminsettings> {
  Admin admin;
  _AdminsettingsState(this.admin);
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController millcontroller = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  late SharedPreferences prefs;
  double millCharge = 0.0;
  String timechange = "";
  String timestring = "";
  List timesplit = [];
  String time12 = "";

  Future<void> millcharge(String charge) async {
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_mill_charge.php"),
        body: {
          "id": admin.id,
          "mill_charge": charge,
        },
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
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

  Future<void> timecharge(String time) async {
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "update_time.php"),
        body: {
          "time": time,
        },
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        prefs = await SharedPreferences.getInstance();

        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
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

  Future fetchMillCharge() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "mill_charge.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        setState(() {
          millCharge = double.parse(jsondata['data'][0]['mill_charge']);
        });
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

  Future fetchtime() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "time.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        setState(() {
          timechange = jsondata['data'][0]['time'];
          timesplit = timechange.split(":");
          time12 = TimeOfDay(
                  hour: int.parse(timesplit[0]),
                  minute: int.parse(timesplit[1]))
              .format(context);
        });
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
  void initState() {
    super.initState();
    fetchMillCharge().whenComplete(
      () => millcontroller.text = millCharge.toString(),
    );
    fetchtime();
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay time = TimeOfDay(hour: 12, minute: 00);
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "Other's Settings",
            style: TextStyle(
              fontSize: 23,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    10,
                  ),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        "Meal Charge :: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Expanded(
                      child: AutoSizeText(
                        " ₹ " + millCharge.toString(),
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Center(
                            child: Text(
                              ":: Charge ::",
                              style: TextStyle(
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                          content: Container(
                            margin: EdgeInsets.only(left: 50),
                            child: Form(
                              key: fromkey,
                              child: TextFormField(
                                controller: millcontroller,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "field required";
                                  } else {
                                    return null;
                                  }
                                },
                                style: TextStyle(
                                  fontSize: 30,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  prefixIcon: Text(
                                    '₹',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 40,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                millcontroller.text = "";
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (fromkey.currentState!.validate()) {
                                  millcharge(
                                    millcontroller.text,
                                  ).whenComplete(() {
                                    fetchMillCharge().whenComplete(
                                      () => Navigator.pop(context),
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Enter value !",
                                  );
                                }
                              },
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
              ),
              color: Colors.white,
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              child: ListTile(
                leading: AutoSizeText(
                  "Time :: ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                title: AutoSizeText(
                  time12,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  maxLines: 1,
                ),
                trailing: IconButton(
                  onPressed: () async {
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: time,
                    );
                    if (newTime == null) return;

                    time = newTime;
                    print(time.hour);
                    timestring = time.hour.toString() +
                        ":" +
                        time.minute.toString() +
                        ":00";
                    timecharge(timestring).whenComplete(() {
                      fetchtime();
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
