// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unused_element, unnecessary_string_interpolations, file_names, unused_local_variable, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/Anonomus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:intl/intl.dart';

class Adminorderredeem extends StatefulWidget {
  const Adminorderredeem({super.key});

  @override
  State<Adminorderredeem> createState() => _AdminorderredeemState();
}

class _AdminorderredeemState extends State<Adminorderredeem> {
  DateTime selectedDate = DateTime.now();
  RxBool isVisible = false.obs;
  RxList<Shistory> orderverifylist = <Shistory>[].obs;
  RxList<Anonomas> orderlists = <Anonomas>[].obs;
  RxInt totalOrders = 0.obs;
  RxInt totalrQuantities = 0.obs;

  Future orderhistory() async {
    Map data = {
      "Date": selectedDate.toString(),
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
        // if (jsondata['data']['redem_quantity'] != 0){
        isVisible.value = true;
        // }
      } else {
        // orderlists.clear();
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
        isVisible.value = false;
      }
      totalrQuantities.value =
          orderlists.fold(0, (sum, item) => sum + int.parse(item.rquantites));
      return orderlists;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future getorderverify() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "student_order_redeem.php"),
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
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }

      totalOrders.value = orderverifylist.length;
      return orderverifylist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    selectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    print(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "Redeemed",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                                      title: Text(
                                        '${orderlists[index].purpous}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
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
                                      trailing: CircleAvatar(
                                        backgroundColor: Colors.green,
                                        child: AutoSizeText(
                                          '${orderlists[index].rquantites}',
                                          textAlign: TextAlign.center,
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
                      future: getorderverify(),
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (data.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderverifylist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
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
              "${totalOrders.value + totalrQuantities.value}",
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
