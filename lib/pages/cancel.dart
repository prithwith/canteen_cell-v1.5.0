// ignore_for_file: camel_case_types, must_be_immutable, prefer_const_constructors, unused_element, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_single_cascade_in_expression_statements, deprecated_member_use, non_constant_identifier_names, prefer_collection_literals, no_logic_in_create_state, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class cancel extends StatefulWidget {
  // const cancel({super.key});
  User user;
  String timechange;
  cancel(this.user, this.timechange);

  @override
  State<cancel> createState() => _cancelState(user, timechange);
}

class _cancelState extends State<cancel> {
  User user;
  String timechange;
  _cancelState(this.user, this.timechange);
  List<Shistory> historylist = [];
  Set<int> selectedItems = Set<int>();
  bool selectAllEnabled = false;
  String timestring = "";
  String datetimestring = "";
  bool longPressSelectionEnabled = false;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeLocalNotifications();
  }

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/apicon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'Your Channel Name',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<dynamic> getcurrenthistory() async {
    Map data = {
      "Roll": user.Roll,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "current_date_order.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        historylist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Shistory historylists = Shistory(
            jsondata['data'][i]['Order_status'],
            jsondata['data'][i]['Username'].toString(),
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Date'],
            jsondata['data'][i]['created_at'],
          );
          historylist.add(historylists);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return historylist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future ordermill(
      String roll, int order_status, String order_id, String desc) async {
    Map data = {
      "Roll": roll,
      "Order_status": order_status.toString(),
      "Order_id": order_id,
      "Description": desc,
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
        Uri.parse(MyUrl.fullurl + "student_order.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
        Fluttertoast.cancel();
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

  Future<void> _refreshData() async {
    await getcurrenthistory();
    setState(
      () {
        historylist.clear();
        getcurrenthistory();
        FocusScope.of(context).unfocus();
      },
    );
  }

  List<Widget> buildAppBarActions() {
    List<Widget> actions = [];

    if (selectedItems.isNotEmpty) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: P.textcolor,
          ),
          onPressed: () {
            if (selectedItems.isNotEmpty) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: 'Cancel Selected Order'.toUpperCase(),
                desc: 'Are you Sure to delete?',
                btnCancelColor: Colors.green,
                btnOkColor: Colors.red,
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  for (int index in selectedItems.toList()) {
                    setState(
                      () {
                        ordermill(
                          user.Roll,
                          0,
                          historylist[index].order_id,
                          "Meal Canceled By You",
                        ).whenComplete(
                          () => _refreshData(),
                        );
                        selectedItems.remove(index);
                        _showLocalNotification(
                          "Meal Cancled & Balance Added",
                          '',
                        );
                      },
                    );
                  }
                },
              )..show();
            }
          },
        ),
      );
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: selectedItems.isEmpty
            ? AppBar(
                backgroundColor: P.appbar2,
                iconTheme: IconThemeData(
                  color: P.textcolor,
                ),
                title: Text(
                  'Cancel Order',
                  style: TextStyle(
                    fontSize: 20,
                    color: P.textcolor,
                  ),
                ),
                centerTitle: true,
              )
            : AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: P.textcolor,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                  },
                ),
                backgroundColor: Colors.grey.shade600,
                title: Text(
                  " ${selectedItems.length} SELECTED ".toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: P.textcolor,
                  ),
                ),
                actions: buildAppBarActions(),
              ),
        body: FutureBuilder(
          future: getcurrenthistory(),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              if (historylist.isNotEmpty) {
                return ListView.builder(
                  itemCount: historylist.length,
                  itemBuilder: (BuildContext context, int index) {
                    bool isSelected = selectedItems.contains(index);
                    bool isAfter8AM = DateTime.now().isAfter(
                      DateTime.parse(
                        "${historylist[index].date} $timechange",
                      ),
                    );
                    return !isAfter8AM
                        ? Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            color: isSelected
                                ? Colors.grey.shade600
                                : Colors.white,
                            margin: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            child: ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoSizeText(
                                    'Order_status : -',
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    ' ${historylist[index].order_status}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: historylist[index].order_status ==
                                              'Confirmed'
                                          ? P.confirm
                                          : P.unknown,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              subtitle: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'Date:- ${DateFormat('dd-MM-yyyy').format(
                                      DateTime.parse(
                                        historylist[index].date,
                                      ),
                                    )}',
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    "Name:- ${user.Username}",
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    'User-Id:- ${historylist[index].roll}',
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    'Order id:- #${historylist[index].order_id}',
                                    maxLines: 1,
                                  ),
                                  // AutoSizeText(
                                  //   'Order Placed :- ${DateFormat('dd-MM-yyyy \t\t hh:mm:ss').format(
                                  //     DateTime.parse(
                                  //       historylist[index].created_at,
                                  //     ),
                                  //   )}',
                                  //   maxLines: 1,
                                  // ),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.bottomSlide,
                                    title: 'Cancel Order\n'
                                            'Date :- ${DateFormat('dd-MM-yyyy').format(DateTime.parse(historylist[index].date))}'
                                        .toUpperCase(),
                                    desc: 'Are you Sure?',
                                    btnCancelOnPress: () {},
                                    btnCancelColor: Colors.green,
                                    btnOkColor: Colors.red,
                                    btnOkOnPress: () {
                                      setState(
                                        () {
                                          ordermill(
                                            user.Roll,
                                            0,
                                            historylist[index].order_id,
                                            "Meal Canceled By User",
                                          )
                                              .whenComplete(
                                                () => _showLocalNotification(
                                                  "Meal Cancled & Balance Added",
                                                  'Date :: ${DateFormat('dd-MM-yyyy').format(
                                                    DateTime.parse(
                                                      historylist[index].date,
                                                    ),
                                                  )}',
                                                ),
                                              )
                                              .whenComplete(
                                                () => _refreshData(),
                                              );
                                        },
                                      );
                                    },
                                  )..show();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              onLongPress: () {
                                setState(() {
                                  longPressSelectionEnabled = true;
                                  if (isSelected) {
                                    selectedItems.remove(index);
                                  } else {
                                    selectedItems.add(index);
                                  }
                                });
                              },
                              onTap: () {
                                if (longPressSelectionEnabled) {
                                  setState(() {
                                    if (isSelected) {
                                      selectedItems.remove(index);
                                    } else {
                                      selectedItems.add(index);
                                    }
                                  });
                                }
                              },
                            ),
                          )
                        : Container();
                  },
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          "Assets/images/order-food.png",
                          height: 40,
                          width: 50,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "No Order Found",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(
                    Colors.redAccent,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
