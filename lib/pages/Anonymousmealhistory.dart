// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/Anonomus.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Anonymousmealhistory extends StatefulWidget {
  const Anonymousmealhistory({super.key});

  @override
  State<Anonymousmealhistory> createState() => _AnonymousmealhistoryState();
}

class _AnonymousmealhistoryState extends State<Anonymousmealhistory> {
  DateTime selectedDate = DateTime.now();
  List<Anonomas> orderlists = [];
  List<Anonomas> orderlistswithdate = [];
  bool isdateSelected = false;
  Future orderhistory() async {
    // Map data = {
    //   "Date": date.toString(),
    // };
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "anonymous_order_history_specific.php"),
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
      }
      return orderlists;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  void orderHistoryWithDate(String datetime) {
    orderlistswithdate.clear();
    for (int i = 0; i < orderlists.length; i++) {
      if (orderlists[i].dates == datetime) {
        orderlistswithdate.add(orderlists[i]);
      }
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
            "Anonymous History",
            style: TextStyle(
              fontSize: 18,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
              style: TextButton.styleFrom(
                iconColor: Colors.black,
                backgroundColor: Colors.transparent,
              ),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2099),
                ).then(
                  (pickedDate) {
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        isdateSelected = true;
                        selectedDate = pickedDate;
                        orderHistoryWithDate(
                            DateFormat('yyyy-MM-dd').format(pickedDate));
                      });
                    }
                  },
                );
              },
              icon: Icon(
                Icons.calendar_month,
                color: Colors.blue,
              ),
              label: Text(
                "Chose Date",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            Visibility(
              visible: isdateSelected,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy').format(selectedDate),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isdateSelected = false;
                      });
                    },
                    child: Text(
                      "Clear Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: orderhistory(),
              builder: (BuildContext context, AsyncSnapshot data) {
                if ((data.hasData && orderlists.isEmpty) ||
                    (isdateSelected == true && orderlistswithdate.isEmpty)) {
                  return Expanded(
                    child: Center(
                      child: Text(
                        'No History Found',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                } else if ((data.hasData && orderlists.isNotEmpty) ||
                    (isdateSelected == true && orderlistswithdate.isNotEmpty)) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: isdateSelected
                          ? orderlistswithdate.length
                          : orderlists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 10,
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListTile(
                            title: isdateSelected
                                ? Text(
                                    orderlistswithdate[index].purpous,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    orderlists[index].purpous,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID:# ${orderlists[index].orderid}',
                                ),
                                isdateSelected
                                    ? Text(
                                        'Date: ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                            orderlistswithdate[index].dates,
                                          ),
                                        )}',
                                      )
                                    : Text(
                                        'Date: ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                              orderlists[index].dates),
                                        )}',
                                      ),
                                Text(
                                  'Redemeed: ${orderlists[index].rquantites}',
                                ),
                              ],
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: P.appbar2,
                              radius: 20,
                              child: isdateSelected
                                  ? AutoSizeText(
                                      '${orderlistswithdate[index].quantites}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                    )
                                  : AutoSizeText(
                                      '${orderlists[index].quantites}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                    ),
                            ),
                          ),
                        );
                      },
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
    );
  }
}
