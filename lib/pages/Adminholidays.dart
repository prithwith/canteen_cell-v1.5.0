// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_single_cascade_in_expression_statements, deprecated_member_use, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, unused_local_variable

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;

class Adminholidays extends StatefulWidget {
  // const Adminholidays(List<String> adholidaylist, {Key? key}) : super(key: key);

  List<String> adholidaylist;
  Adminholidays(this.adholidaylist);

  @override
  State<Adminholidays> createState() => _AdminholidaysState(adholidaylist);
}

class _AdminholidaysState extends State<Adminholidays> {
  List<String> adholidaylist;
  _AdminholidaysState(this.adholidaylist);
  List<DateTime> selectedDates = [];

  Future<void> holidays(List<DateTime> dates, String Desc) async {
    List<String> formattedDates = dates
        .map((date) =>
            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}")
        .toList();

    Map data = {
      "Dates": formattedDates.toString(),
      "Description": Desc,
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
        Uri.parse(MyUrl.fullurl + "admin_holiday.php"),
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

  bool holid(DateTime date) {
    if (adholidaylist.contains(DateFormat('yyyy-MM-dd').format(date))) {
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

  Future adminholidaysdelete(String date) async {
    Map data = {
      "Dates": date,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_holiday_delete.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "true") {
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
            "Holidays",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: 500,
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  30,
                ),
              ),
              child: SfDateRangePicker(
                backgroundColor: Colors.white,
                selectionColor: Color.fromARGB(255, 3, 222, 193),
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.multiple,
                headerHeight: 90,
                headerStyle: DateRangePickerHeaderStyle(
                  backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                showActionButtons: true,
                showNavigationArrow: true,
                selectionTextStyle: TextStyle(fontSize: 21),
                initialDisplayDate: DateTime.now(),
                minDate: DateTime.now(),
                maxDate: DateTime(2099),
                selectableDayPredicate: (DateTime date) {
                  if (date.weekday == DateTime.sunday ||
                      adholidaylist
                          .contains(DateFormat('yyyy-MM-dd').format(date))) {
                    return false;
                  }
                  DateTime now = DateTime.now();
                  if (date.day == now.day &&
                      date.month == now.month &&
                      date.year == now.year) {
                    if (date.hour < 8) {
                      return false;
                    }
                  }
                  return true;
                },
                cellBuilder: (BuildContext context,
                    DateRangePickerCellDetails cellDetails) {
                  DateTime date = cellDetails.date;

                  if (holid(date)) {
                    return Container(
                      margin: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundColor: Colors.redAccent,
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
                        shape: RoundedRectangleBorder(
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

                          String formattedDateText = formattedDates.join(' , ');

                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected Dates :- '.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        ' $formattedDateText',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 1,
                                  color: Color.fromARGB(255, 58, 58, 58),
                                ),
                                Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 73, 70, 70),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            title: Text(
                                              'Confirmation :- '.toUpperCase(),
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 23,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              " Are You Sure ? ",
                                            ),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      Colors.redAccent,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'Cancel'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 17),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  holidays(
                                                    selectedDates,
                                                    "Meal Canceled By Admin, Due To  Holiday ",
                                                  );
                                                },
                                                child: Text(
                                                  'Confirm'.toUpperCase(),
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
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Please Select Date\'s First !',
                    );
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: P.secondtheamecolor,
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Holiday Date's",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: adholidaylist.length,
                              itemBuilder: (BuildContext context, int index) {
                                DateTime currentDate = DateTime.now();
                                DateTime adHolidayDate =
                                    DateTime.parse(adholidaylist[index]);
                                bool isPastDate =
                                    adHolidayDate.isBefore(currentDate);
                                return isPastDate
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 3,
                                        ),
                                        height: 70,
                                        child: Card(
                                          child: ListTile(
                                            title: Row(
                                              children: [
                                                Text("Date:- "),
                                                Text(
                                                    "${DateFormat('dd-MM-yyyy').format(
                                                  DateTime.parse(
                                                    adholidaylist[index],
                                                  ),
                                                )}"),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              onPressed: () {
                                                String dat =
                                                    adholidaylist[index];
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: Text(
                                                      "Delete Date",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    content: Text(
                                                      "Are You Sure Want To Delete ? \n Date:- ${DateFormat('dd-MM-yyyy').format(
                                                        DateTime.parse(
                                                          adholidaylist[index],
                                                        ),
                                                      )}",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "Cancel",
                                                          style: TextStyle(
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          // print(dat);
                                                          adminholidaysdelete(
                                                                  dat)
                                                              .whenComplete(
                                                            () => AwesomeDialog(
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .success,
                                                              animType: AnimType
                                                                  .bottomSlide,
                                                              title:
                                                                  "Delete Date",
                                                              btnOkOnPress: () {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                            )..show(),
                                                          );
                                                        },
                                                        child: Text(
                                                          "Ok",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Text(
                "Remove Holiday's",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
