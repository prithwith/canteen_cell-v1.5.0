// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, unrelated_type_equality_checks, avoid_print, unused_element, unused_local_variable, file_names

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/Anonomus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Adminorderhistory extends StatefulWidget {
  const Adminorderhistory({super.key});

  @override
  State<Adminorderhistory> createState() => _AdminorderhistoryState();
}

class _AdminorderhistoryState extends State<Adminorderhistory> {
  List<Shistory> orderverifylist = [];
  RxInt totalnumber = 0.obs;
  RxInt totalQuantities = 0.obs;
  RxBool isVisible = false.obs;

  String selectedDate = DateFormat("yyyy-MM-dd").format(
    DateTime.now(),
  );
  String displaydate = DateFormat("dd-MM-yyyy").format(
    DateTime.now(),
  );

  List<Anonomas> orderlists = [];

  @override
  void initState() {
    print(DateTime.now());
    super.initState();
  }

  Future orderhistory() async {
    Map data = {
      "Date": selectedDate,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "anonymous_order_history.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        orderlists.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Anonomas newlist = Anonomas(
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Purpose'],
            jsondata['data'][i]['Quantity'],
            jsondata['data'][i]['Date'],
            jsondata['data'][i]['redem_quantity'],
          );
          orderlists.add(newlist);
        }
        isVisible.value = true;
      } else {
        orderlists.clear();
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
        isVisible.value = false;
      }
      totalQuantities.value =
          orderlists.fold(0, (sum, item) => sum + int.parse(item.quantites));
      return orderlists;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future getorderallhistory(DateTime date) async {
    Map data = {
      "Date": selectedDate,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_order_history.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        orderverifylist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Shistory historylists = Shistory(
            jsondata['data'][i]['Order_status'],
            jsondata['data'][i]['Username'].toString(),
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Date'],
            jsondata['data'][i]['created_at'],
          );
          orderverifylist.add(historylists);
        }
      } else {
        orderverifylist.clear();
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
      totalnumber.value = orderverifylist.length;
      return orderverifylist;
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
        backgroundColor: P.theamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "Order History",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                iconColor: Colors.black,
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateFormat("yyyy-MM-dd").parse(selectedDate),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2099),
                ).then(
                  (pickedDate) {
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        print(pickedDate);
                        selectedDate = DateFormat("yyyy-MM-dd")
                            .parse(
                              pickedDate.toString(),
                            )
                            .toString();
                        displaydate =
                            DateFormat("dd-MM-yyyy").format(pickedDate);
                      });
                    }
                  },
                );
              },
              icon: Icon(
                Icons.calendar_month_outlined,
                color: Colors.blue,
              ),
              label: Text(
                "Choose date".toUpperCase(),
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            Text(
              displaydate,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: isVisible.value,
                        child: FutureBuilder(
                          future: orderhistory(),
                          builder: (BuildContext context, AsyncSnapshot data) {
                            if (data.hasData) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderlists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                    ),
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: ListTile(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Purpose:- ${orderlists[index].purpous}',
                                            maxLines: 2,
                                          ),
                                          Text(
                                            'Order_id:-# ${orderlists[index].orderid}',
                                            maxLines: 2,
                                          ),
                                          Text(
                                            'Date:- ${DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                orderlists[index].dates,
                                              ),
                                            )}',
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Redeemed: ${orderlists[index].rquantites}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 22,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      trailing: orderlists[index].quantites ==
                                              orderlists[index].rquantites
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: Icon(
                                                Icons.verified_rounded,
                                                color: Colors.green,
                                                size: 40,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundColor: P.appbar2,
                                              radius: 20,
                                              child: AutoSizeText(
                                                '${orderlists[index].quantites}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              );
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
                    ),
                    FutureBuilder(
                      future: getorderallhistory(
                          DateFormat("yyyy-MM-dd").parse(selectedDate)),
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (data.hasData && orderverifylist.isNotEmpty) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderverifylist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 22,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      AutoSizeText(
                                        'Order_status :- ',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        '${orderverifylist[index].order_status}'
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: orderverifylist[index]
                                                      .order_status ==
                                                  'Confirmed'
                                              ? P.confirm
                                              : orderverifylist[index]
                                                          .order_status ==
                                                      'Redeemed'
                                                  ? P.redeem
                                                  : P.unknown,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      AutoSizeText(
                                        'Name :- ${orderverifylist[index].name}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'Date :- ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                            orderverifylist[index].date,
                                          ),
                                        )}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'User-Id :- ${orderverifylist[index].roll}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'Order_id :- # ${orderverifylist[index].order_id}',
                                        maxLines: 1,
                                      ),
                                      // AutoSizeText(
                                      //   'Order Placed :: ${DateFormat('dd-MM-yyyy \t\t hh:mm:ss').format(
                                      //     DateTime.parse(
                                      //       orderverifylist[index].created_at,
                                      //     ),
                                      //   )}',
                                      //   maxLines: 1,
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (data.hasData && orderverifylist.isEmpty) {
                          return Center(
                            child: Text(
                              'No History Found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.transparent,
                              ),
                            ),
                          );
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
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          onPressed: () {},
          child: Obx(
            () => AutoSizeText(
              "${totalnumber.value + totalQuantities.value}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
