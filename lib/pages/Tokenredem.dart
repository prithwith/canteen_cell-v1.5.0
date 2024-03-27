// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, file_names

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/user.dart';
import 'package:intl/intl.dart';
import '../models/colorclass.dart';

class Tokenredem extends StatefulWidget {
  // const Tokenredem({super.key});
  User user;
  Tokenredem(this.user);

  @override
  State<Tokenredem> createState() => _TokenredemState(user);
}

class _TokenredemState extends State<Tokenredem> {
  User user;
  _TokenredemState(this.user);

  String order_status = '';
  String order_id = '';
  String date = '';

  Future getcurrenthistory() async {
    Map data = {
      "Roll": user.Roll,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "current_date_token.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        for (int i = 0; i < jsondata['data'].length; i++) {
          order_status = jsondata['data'][i]['Order_status'];
          order_id = jsondata['data'][i]['Order_id'];
          date = jsondata['data'][i]['Date'];
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return {
        order_status,
        order_id,
        date,
      };
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
            'Token Redeem',
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getcurrenthistory(),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              return Center(
                child: Container(
                  height: 190,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 100,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                AutoSizeText(
                                  "Order Status:-",
                                  style: TextStyle(
                                    color: P.textcolor2,
                                  ),
                                  maxLines: 1,
                                ),
                                AutoSizeText(
                                  ' $order_status'.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: order_status == 'Redeemed'
                                        ? P.redeem
                                        : P.unknown,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            AutoSizeText(
                              user.Username,
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              user.Roll,
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              "Order-id : - # $order_id",
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                AutoSizeText(
                                  "Date :-",
                                  style: TextStyle(
                                    color: P.textcolor2,
                                  ),
                                  maxLines: 2,
                                ),
                                AutoSizeText(
                                  DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(date),
                                  ),
                                  style: TextStyle(
                                    color: P.textcolor2,
                                  ),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
              //     Container(
              //   margin: EdgeInsets.symmetric(
              //     horizontal: 50,
              //     vertical: 200,
              //   ),
              //   child: FDottedLine(
              //     dottedLength: 1000,
              //     child: Container(
              //       padding: EdgeInsets.only(left: 15),
              //       color: Colors.blue[100],
              //       width: MediaQuery.of(context).size.width,
              //       height: 200,
              //       alignment: Alignment.topLeft,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             children: [
              //               AutoSizeText(
              //                 'Order_status : -',
              //                 maxLines: 1,
              //               ),
              //               Expanded(
              //                 child: Row(
              //                   children: [
              //                     AutoSizeText(
              //                       ' ${historylist[index].order_status}',
              //                       style: TextStyle(
              //                         fontWeight: FontWeight.bold,
              //                         color:
              //                             historylist[index].order_status ==
              //                                     'Redeemed'
              //                                 ? P.redeem
              //                                 : P.unknown,
              //                       ),
              //                       maxLines: 2,
              //                     ),
              //                     Icon(
              //                       Icons.verified,
              //                       color: Colors.green,
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //           AutoSizeText(
              //             'Name : - ${user.Username}',
              //             maxLines: 1,
              //           ),
              //           AutoSizeText(
              //             'Roll : - ${historylist[index].roll}',
              //             maxLines: 1,
              //           ),
              //           AutoSizeText(
              //             'Order-id : - # ${historylist[index].order_id}',
              //             maxLines: 1,
              //           ),
              //           AutoSizeText(
              //             'Date :- ${DateFormat('dd-MM-yyyy').format(DateTime.parse(historylist[index].date))}',
              //             maxLines: 1,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // );
              //   },
              // );
            } else {
              return const Center(
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
