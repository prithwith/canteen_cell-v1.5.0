// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, must_be_immutable, sort_child_properties_last, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/Balancehistory.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/Sharebalance.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Studentbalance extends StatefulWidget {
  // const Balance({super.key});
  User user;
  Studentbalance(this.user);

  @override
  State<Studentbalance> createState() => _StudentbalanceState(user);
}

class _StudentbalanceState extends State<Studentbalance> {
  User user;
  _StudentbalanceState(this.user);
  int balance = 0;
  List<Balancehistory> balancehistorylist = [];
  bool viweall = false;

  Future checkbalance() async {
    Map data = {
      "Roll": user.Roll,
    };
    try {
      var response = await http.post(
        Uri.parse("${MyUrl.fullurl}student_balance1.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        balance = int.parse(jsondata['data']);
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return balance;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future Balancehis() async {
    Map data = {
      "Roll": user.Roll,
    };
    try {
      var response = await http.post(
        Uri.parse("${MyUrl.fullurl}user_transaction.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        balancehistorylist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Balancehistory newlist = Balancehistory(
            jsondata['data'][i]['id'],
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['date'],
            jsondata['data'][i]['amount'],
            jsondata['data'][i]['Description'],
          );
          balancehistorylist.add(newlist);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return balancehistorylist;
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
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 17,
            ),
          ),
          title: Text(
            "Wallets",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Add Money',
                      ),
                      content: Text(
                        'Contact with Canteen Administrator',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add,
                    size: 17,
                  ),
                  AutoSizeText(
                    "Add Money",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 15,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 19, 62, 216),
                    Color.fromARGB(255, 95, 131, 224),
                  ],
                ),
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    "Available Balance",
                    style: TextStyle(
                      color: P.textcolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: checkbalance(),
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (data.hasData) {
                          return AutoSizeText(
                            "₹ $balance",
                            style: TextStyle(
                              color: P.textcolor,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          );
                        } else {
                          return SizedBox(
                            height: 20,
                            width: 20,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 200),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Sharebalance(user),
                          ),
                        );
                      },
                      label: AutoSizeText(
                        "Share Money",
                        style: TextStyle(
                          fontSize: 13,
                          color: P.textcolor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      icon: Icon(
                        Icons.share,
                        size: 17,
                        color: P.textcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 20.0),
                  child: viweall
                      ? AutoSizeText(
                          "All Transactions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        )
                      : AutoSizeText(
                          "Last 10 Transactions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      viweall = !viweall;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 20.0,
                      bottom: 10.0,
                      top: 10.0,
                    ),
                    child: viweall
                        ? AutoSizeText(
                            "See Less",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          )
                        : AutoSizeText(
                            "View All",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: Balancehis(),
                builder: (BuildContext context, AsyncSnapshot data) {
                  if (data.hasData && balancehistorylist.isNotEmpty) {
                    int itemCount = viweall
                        ? data.data.length
                        : (data.data.length > 10 ? 10 : data.data.length);
                    return ListView.builder(
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int index) {
                        int reversedIndex = data.data.length - 1 - index;
                        return Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(9),
                            ),
                          ),
                          color: Colors.white,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Center(
                                child: Text(
                                  "₹",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              backgroundColor: Color.fromARGB(255, 15, 66, 194),
                            ),
                            title: AutoSizeText(
                              "${DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(
                                    balancehistorylist[reversedIndex].date),
                              )}",
                            ),
                            subtitle: AutoSizeText(
                              "${balancehistorylist[reversedIndex].descript}",
                            ),
                            trailing: int.parse(
                                        balancehistorylist[reversedIndex]
                                            .amount) >
                                    0
                                ? AutoSizeText(
                                    "+ ₹${balancehistorylist[reversedIndex].amount}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold),
                                  )
                                : AutoSizeText(
                                    "- ₹${int.parse(balancehistorylist[reversedIndex].amount) * -1}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(balancehistorylist[
                                                    reversedIndex]
                                                .date),
                                          )}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        int.parse(balancehistorylist[
                                                        reversedIndex]
                                                    .amount) >
                                                0
                                            ? Text(
                                                "+ ₹${balancehistorylist[reversedIndex].amount}",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                "- ₹${int.parse(balancehistorylist[reversedIndex].amount) * -1}",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    content: Text(
                                      "${balancehistorylist[reversedIndex].descript}",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else if (data.hasData && balancehistorylist.isEmpty) {
                    return Center(
                      child: Text(
                        "No History Found",
                        style: TextStyle(
                          color: Colors.grey,
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
            ),
          ],
        ),
      ),
    );
  }
}
