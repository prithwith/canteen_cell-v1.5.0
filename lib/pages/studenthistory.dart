// ignore_for_file: camel_case_types, must_be_immutable, prefer_const_constructors, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, no_logic_in_create_state, unused_element, use_key_in_widget_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class studenthistory extends StatefulWidget {
  // const studenthistory({super.key});
  User user;
  studenthistory(this.user);

  @override
  State<studenthistory> createState() => _studenthistoryState(user);
}

class _studenthistoryState extends State<studenthistory> {
  User user;
  _studenthistoryState(this.user);
  List<Shistory> historylist = [];

  Future gethistory() async {
    Map data = {
      "Roll": user.Roll,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_order_history.php"),
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

  Future<void> _refreshData() async {
    await gethistory();
    setState(
      () {
        FocusScope.of(context).unfocus();
      },
    );
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
            'History',
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Scrollbar(
          thickness: 10,
          trackVisibility: true,
          radius: Radius.circular(
            10,
          ),
          child: FutureBuilder(
            future: gethistory(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                if (historylist.isNotEmpty) {
                  return ListView.builder(
                    itemCount: historylist.length,
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
                                'Order status :: ',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                '${historylist[index].order_status}'
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: historylist[index].order_status ==
                                          'Confirmed'
                                      ? P.confirm
                                      : historylist[index].order_status ==
                                              'Canceled'
                                          ? P.cancel
                                          : historylist[index].order_status ==
                                                  'Redeemed'
                                              ? P.redeem
                                              : P.unknown,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Date :: ${DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(
                                    historylist[index].date,
                                  ),
                                )}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'User-Id :: ${historylist[index].roll}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Order Id :: # ${historylist[index].order_id}',
                                maxLines: 1,
                              ),
                              // AutoSizeText(
                              //   'Order Placed :: ${DateFormat('dd-MM-yyyy \t\t hh:mm:ss').format(
                              //     DateTime.parse(
                              //       historylist[index].created_at,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "Assets/images/clock.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "History Not Found",
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
      ),
    );
  }
}
