// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, prefer_interpolation_to_compose_strings, deprecated_member_use, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Anonymousmealhistory.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class Addanonymousmeal extends StatefulWidget {
  const Addanonymousmeal({super.key});

  @override
  State<Addanonymousmeal> createState() => _AddanonymousmealState();
}

class _AddanonymousmealState extends State<Addanonymousmeal> {
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Future<void> ordermeal(
      String purpose, String quantity, String formattedDates) async {
    List<DateTime> dates = formattedDates
        .split(',')
        .map((dateStr) => DateTime.parse(dateStr))
        .toList();

    Map data = {
      "Purpose": purpose,
      "Quantity": quantity,
      "Date": formattedDates.toString(),
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "add_anonymous_order.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          title: jsondata['msg'],
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        )..show();
      } else {
        Navigator.pop(context);
        Navigator.pop(context);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.infoReverse,
          animType: AnimType.bottomSlide,
          title: jsondata['msg'],
          btnOkOnPress: () {
            Navigator.pop(context);
          },
        )..show();
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  List<String> holidayist = [];
  String timechange = "00:00:00";
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
      }
      return holidayist;
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

  bool holid(DateTime date) {
    if (holidayist.contains(DateFormat('yyyy-MM-dd').format(date))) {
      return true;
    }
    return false;
  }

  bool isdisabledate(DateTime date) {
    if (date.weekday == DateTime.sunday) {
      return true;
    }
    return false;
  }

  bool isPastDate(DateTime date) {
    DateTime now = DateTime.now();
    return date.isBefore(
      DateTime(
        now.year,
        now.month,
        now.day + 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.secondtheamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "Anonymous Meal",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Anonymousmealhistory(),
                  ),
                );
              },
              icon: const Icon(
                Icons.history_toggle_off,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
            future: adminholidays(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 15,
                    ),
                    height: 470,
                    child: Card(
                      elevation: 20,
                      child: SfDateRangePicker(
                        backgroundColor: Colors.white,
                        view: DateRangePickerView.month,
                        selectionMode: DateRangePickerSelectionMode.single,
                        headerStyle: DateRangePickerHeaderStyle(
                          backgroundColor: Colors.blueAccent,
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        headerHeight: 90,
                        selectionColor: Color.fromARGB(255, 3, 222, 193),
                        showActionButtons: true,
                        showNavigationArrow: true,
                        initialDisplayDate: DateTime.now(),
                        minDate: DateTime.now(),
                        maxDate: DateTime(2099),
                        cellBuilder: (BuildContext context,
                            DateRangePickerCellDetails cellDetails) {
                          DateTime date = cellDetails.date;
                          if (holid(date)) {
                            return Container(
                              margin: EdgeInsets.all(2),
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 20,
                                child: Text(
                                  cellDetails.date.day.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          } else if (isdisabledate(date)) {
                            return Center(
                              child: Text(
                                cellDetails.date.day.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else if (isPastDate(date)) {
                            return Center(
                              child: Text(
                                cellDetails.date.day.toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else {
                            return ClipOval(
                              child: Center(
                                child: Text(
                                  cellDetails.date.day.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        selectableDayPredicate: (DateTime date) {
                          if (date.weekday == DateTime.sunday ||
                              holidayist.contains(
                                  DateFormat('yyyy-MM-dd').format(date))) {
                            return false;
                          }

                          DateTime now = DateTime.now();
                          if (date.day == now.day &&
                              date.month == now.month &&
                              date.year == now.year) {
                            DateTime dateTimeChange = DateTime.parse(
                                "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} $timechange");
                            if (now.isAfter(dateTimeChange)) {
                              return false;
                            }
                          }
                          return true;
                        },
                        onSubmit: (Object? value) {
                          if (value != null) {
                            showModalBottomSheet<void>(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Selected Date :- '.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              '$value',
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Color.fromARGB(255, 58, 58, 58),
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                          ),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              isDismissible: false,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(
                                                  builder:
                                                      (context, internalstate) {
                                                    return SingleChildScrollView(
                                                      child: SizedBox(
                                                        height: 650,
                                                        child: Form(
                                                          key: fromkey,
                                                          child: Column(
                                                            children: [
                                                              IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon: Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top: 25,
                                                                        left:
                                                                            39,
                                                                        right:
                                                                            39),
                                                                child:
                                                                    TextFormField(
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return "Can't be blank";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  controller:
                                                                      t1,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    labelText:
                                                                        'Purpose'
                                                                            .toUpperCase(),
                                                                    hintText:
                                                                        'Enter Purpose'
                                                                            .toUpperCase(),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    fillColor: P
                                                                        .fromfillcolor,
                                                                    filled:
                                                                        true,
                                                                    prefixIcon:
                                                                        const Icon(
                                                                            Icons.message),
                                                                    prefixIconColor:
                                                                        Colors
                                                                            .black,
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                    enabledBorder:
                                                                        const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            127,
                                                                            192),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 25,
                                                                        left:
                                                                            39,
                                                                        right:
                                                                            39),
                                                                child:
                                                                    TextFormField(
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .number,
                                                                  validator:
                                                                      (value) {
                                                                    if (value!
                                                                        .isEmpty) {
                                                                      return "Can't be blank";
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  autovalidateMode:
                                                                      AutovalidateMode
                                                                          .onUserInteraction,
                                                                  controller:
                                                                      t2,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    fillColor: P
                                                                        .fromfillcolor,
                                                                    filled:
                                                                        true,
                                                                    hintText:
                                                                        "Enter Quantity"
                                                                            .toUpperCase(),
                                                                    labelText:
                                                                        "Quantity"
                                                                            .toUpperCase(),
                                                                    labelStyle:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    prefixIcon:
                                                                        const Icon(
                                                                      Icons
                                                                          .numbers,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                    ),
                                                                    focusedBorder:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color: Colors
                                                                            .black,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              15),
                                                                    ),
                                                                    enabledBorder:
                                                                        const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            5,
                                                                            127,
                                                                            192),
                                                                        width:
                                                                            2,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        50),
                                                                height: 50,
                                                                width: 140,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (fromkey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      if (value
                                                                          is DateTime) {
                                                                        List<DateTime>
                                                                            dates =
                                                                            [
                                                                          value
                                                                        ];
                                                                        String formattedDates = dates
                                                                            .map((date) =>
                                                                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}")
                                                                            .join(',');
                                                                        ordermeal(
                                                                          t1.text,
                                                                          t2.text,
                                                                          formattedDates,
                                                                        );
                                                                      }
                                                                      Navigator.pop(
                                                                          context);
                                                                    } else {
                                                                      Fluttertoast
                                                                          .showToast(
                                                                        msg:
                                                                            'Fill All data ',
                                                                      );
                                                                    }
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            57,
                                                                            57,
                                                                            236),
                                                                    shape:
                                                                        BeveledRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    'Order'
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: P
                                                                          .textcolor,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Text(
                                            'Process'.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: P.textcolor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please Select Date\'s First !',
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(
                      P.appbar2,
                    ),
                  ),
                );
              }
            }),
      ),
    );
  }
}
