// ignore_for_file: camel_case_types, must_be_immutable, prefer_const_constructors, unused_element, prefer_interpolation_to_compose_strings, unnecessary_brace_in_string_interps, unnecessary_string_interpolations, non_constant_identifier_names, unnecessary_null_comparison, no_logic_in_create_state, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/pages/Tokenredem.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/user.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class token extends StatefulWidget {
  // const token({super.key});
  User user;
  token(this.user);

  @override
  State<token> createState() => _tokenState(user);
}

class _tokenState extends State<token> {
  User user;
  _tokenState(this.user);
  Timer? update;
  Timer? cancelpage;

  RxString order_statues = ''.obs;
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
          order_statues.value = jsondata['data'][i]['Order_status'];
          order_id = jsondata['data'][i]['Order_id'];
          date = jsondata['data'][i]['Date'];

          // if (order_statues.value == 'Redeemed') {
          //   Get.off(
          //     () => Tokenredem(
          //       user,
          //     ),
          //   );
          // }

          if (order_statues.value == 'Redeemed') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Tokenredem(
                  user,
                ),
              ),
            );
          }
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return {
        order_statues.value,
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
  void initState() {
    super.initState();
    cancelpage = Timer(
      Duration(seconds: 15),
      () {
        Navigator.pop(context);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    cancelpage!.cancel();
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
            'Token',
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Note',
                        textAlign: TextAlign.center,
                      ),
                      content: Text(
                        "After 15 Second's Page Will Be Closed,Then You Can Re-open The Page Again.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(
                Icons.info_outline,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getcurrenthistory(),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              if (order_statues.value != '' && order_id != '' && date != '') {
                return Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: FDottedLine(
                      strokeWidth: 1.5,
                      corner: FDottedLineCorner.all(5),
                      child: Card(
                        elevation: 30,
                        child: Container(
                          padding: EdgeInsets.only(left: 15),
                          color: Colors.blue[100],
                          height: 440,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AutoSizeText(
                                    "Order_status:- ",
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    '${order_statues.value}'.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: order_statues.value == 'Confirmed'
                                          ? P.confirm
                                          : order_statues.value == 'Redeemed'
                                              ? P.redeem
                                              : P.unknown,
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                              AutoSizeText(
                                'Name:- ${user.Username}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'User-Id:- ${user.Roll}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Order id:- # ${order_id}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Date:- ${DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(
                                    date,
                                  ),
                                )}',
                                maxLines: 1,
                              ),
                              Center(
                                child: QrImageView(
                                  data: order_id,
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 0.4,
                        child: Image.asset(
                          "Assets/images/tickets.png",
                          height: 50,
                          width: 80,
                        ),
                      ),
                      Text(
                        "No Token Found",
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
