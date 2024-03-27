// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, no_logic_in_create_state, use_key_in_widget_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Addmealorderdates extends StatefulWidget {
  // const Addmealorderdates({super.key});
  String passroll, timechange;
  List<String> orderdatelist, holidayist;
  Addmealorderdates(
      this.passroll, this.timechange, this.orderdatelist, this.holidayist);

  @override
  State<Addmealorderdates> createState() =>
      _AddmealorderdatesState(passroll, timechange, orderdatelist, holidayist);
}

class _AddmealorderdatesState extends State<Addmealorderdates> {
  String passroll, timechange;
  List<String> orderdatelist, holidayist;
  _AddmealorderdatesState(
      this.passroll, this.timechange, this.orderdatelist, this.holidayist);

  DateRangePickerController datepicker = DateRangePickerController();
  List<DateTime> selectedDates = [];
  double millCharge = 0.0;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchMillCharge();
    checkbalance();
  }

  Future checkbalance() async {
    Map data = {
      "Roll": passroll,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_balance.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        setState(() {
          totalAmount = double.parse(jsondata['data'][0]['Balance']);
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

  Future<void> ordermultiplemill(int order_status, List<DateTime> dates,
      String totalbalance, String desc) async {
    List<String> formattedDates = dates
        .map((date) =>
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}")
        .toList();

    Map data = {
      "Order_status": order_status.toString(),
      "Roll": passroll,
      "Date": formattedDates.toString(),
      'TotalBalance': totalbalance,
      'Description': desc,
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
        Uri.parse(MyUrl.fullurl + "student_multi_order.php"),
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

  bool isorder(DateTime date) {
    if (orderdatelist.contains(DateFormat('yyyy-MM-dd').format(date))) {
      return true;
    }
    return false;
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
            "Multiple order",
            style: TextStyle(
              fontSize: 23,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                height: 470,
                child: Card(
                  elevation: 20,
                  child: SfDateRangePicker(
                    backgroundColor: Colors.white,
                    view: DateRangePickerView.month,
                    headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: Colors.blueAccent,
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    selectionMode: DateRangePickerSelectionMode.multiple,
                    headerHeight: 90,
                    showActionButtons: true,
                    showNavigationArrow: true,
                    selectionColor: Color.fromARGB(255, 3, 222, 193),
                    initialDisplayDate: DateTime.now(),
                    minDate: DateTime.now(),
                    maxDate: DateTime(2099),
                    selectableDayPredicate: (DateTime date) {
                      if (date.weekday == DateTime.sunday ||
                          orderdatelist.contains(
                              DateFormat('yyyy-MM-dd').format(date)) ||
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
                    cellBuilder: (BuildContext context,
                        DateRangePickerCellDetails cellDetails) {
                      DateTime date = cellDetails.date;

                      if (isorder(date)) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                            radius: 20,
                            child: Text(
                              cellDetails.date.day.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      } else if (holid(date)) {
                        return Container(
                          margin: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 20,
                            child: Text(
                              cellDetails.date.day.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
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
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      } else if (isPastDate(date)) {
                        return Center(
                          child: Text(
                            cellDetails.date.day.toString(),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      } else {
                        return ClipOval(
                          child: Center(
                            child: Text(
                              cellDetails.date.day.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    onSubmit: (Object? value) {
                      if (value != null && value is List<DateTime>) {
                        setState(() {
                          selectedDates = value;
                        });
                        if (selectedDates.isNotEmpty) {
                          showModalBottomSheet<void>(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              List<String> formattedDates = selectedDates
                                  .map((date) =>
                                      DateFormat('dd-MM-yyyy').format(date))
                                  .toList();

                              String formattedDateText =
                                  formattedDates.join(' , ');

                              int Showtotalbalance =
                                  (millCharge.toInt() * formattedDates.length);

                              return SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Selected Dates :- '.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '$formattedDateText',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),

                                      // Divider(
                                      //   height: 1,
                                      //   color: Color.fromARGB(255, 58, 58, 58),
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       'Total Meal :- '.toUpperCase(),
                                      //       style: TextStyle(
                                      //         fontSize: 18,
                                      //         fontWeight: FontWeight.w600,
                                      //       ),
                                      //     ),
                                      //     Text(
                                      //       (int.parse(Showtotalbalance
                                      //                   .toString()) /
                                      //               millCharge.toInt())
                                      //           .toString(),
                                      //       style: TextStyle(
                                      //         fontSize: 19,
                                      //         fontWeight: FontWeight.w400,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                      // SizedBox(
                                      //   height: 10,
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            'Total Ammount :- '.toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            Showtotalbalance.toString(),
                                            style: TextStyle(
                                              fontSize: 19,
                                              fontWeight: FontWeight.w400,
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
                                            if ((millCharge *
                                                    formattedDates.length) <=
                                                totalAmount) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      'Confirmation :- '
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 23,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      " Are You Sure Want To Confirm Order's ? ",
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.redAccent,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontSize: 17),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          ordermultiplemill(
                                                            1,
                                                            selectedDates,
                                                            "-" +
                                                                Showtotalbalance
                                                                    .toString(),
                                                            "Meal Ordered By ADMIN For $formattedDates Dates",
                                                          );
                                                        },
                                                        child: Text(
                                                          'Confirm'
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 17,
                                                            color: P.textcolor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: ' Insufficent balance ',
                                              );
                                            }
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
                                ),
                              );
                            },
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Please Select Date\'s First !',
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Please Select Date\'s First !',
                        );
                      }
                    },
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: AutoSizeText(
                            " Orders ".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            "Holiday's".toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
