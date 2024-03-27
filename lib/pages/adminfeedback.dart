// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, unused_local_variable, camel_case_types, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:canteen_cell/models/feedbackgetdata.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/colorclass.dart';
import 'package:fluttertoast/fluttertoast.dart';

class adminfeedback extends StatefulWidget {
  const adminfeedback({super.key});

  @override
  State<adminfeedback> createState() => _adminfeedbackState();
}

class _adminfeedbackState extends State<adminfeedback> {
  List<Feedbackgetdata> feedbacklist = [];
  List<Signupgetdata> signuplist = [];
  String user = "";
  List<String> usernameList = [];

  Future getsignup() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "varify_studentlist.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        for (int i = 0; i < jsondata['data'].length; i++) {
          String username = jsondata['data'][i]['Username'];
          usernameList.add(username);
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future getfeedback() async {
    try {
      await getsignup();
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "feedback_getdata.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        feedbacklist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          // Feedbackgetdata feedbackgetdata = Feedbackgetdata(
          String roll = jsondata['data'][i]['Roll'];
          String ratting = jsondata['data'][i]['Ratting'];
          String feedback = jsondata['data'][i]['Feedback'];
          // );
          // feedbacklist.add(feedbackgetdata);
          String username = (i < usernameList.length) ? usernameList[i] : "";

          Feedbackgetdata feedbackgetdata = Feedbackgetdata(
            roll,
            ratting,
            feedback,
            username,
          );
          feedbacklist.add(feedbackgetdata);
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
      return feedbacklist;
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
            "User Feedbacks",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: getfeedback().whenComplete(() {
            getsignup();
          }),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              if (feedbacklist.isNotEmpty) {
                return ListView.builder(
                  itemCount: feedbacklist.length,
                  itemBuilder: (BuildContext context, int index) {
                    double rating = double.parse(feedbacklist[index].ratting);
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
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${feedbacklist[index].username} '
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.verified,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              ' ${feedbacklist[index].feedback} ',
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                        subtitle: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${feedbacklist[index].ratting}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            for (int i = 0; i < rating.toInt(); i++)
                              Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                              ),
                            if (rating.toDouble() % 1 != 0)
                              Icon(
                                Icons.star_half,
                                color: Colors.deepOrange,
                              ),
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
                        opacity: 0.6,
                        child: Image.asset(
                          "Assets/images/400.png",
                          height: 60,
                          width: 70,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "No Feedback Found",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
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
