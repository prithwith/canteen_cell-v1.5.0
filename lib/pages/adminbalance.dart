// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously, camel_case_types, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_final_fields

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/pages/Adminbalancehistory.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class adminbalance extends StatefulWidget {
  const adminbalance({super.key});

  @override
  State<adminbalance> createState() => _adminbalanceState();
}

class _adminbalanceState extends State<adminbalance>
    with TickerProviderStateMixin {
  String? sendEmail;
  String? sendname;
  String? uroll;
  String? amount;
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  TextEditingController millcontroller = TextEditingController();
  List<Signupgetdata> signuplist = [];
  late SharedPreferences prefs;
  TextEditingController searchController = TextEditingController();
  List<Signupgetdata> filteredList = [];
  FocusNode _focusNode = FocusNode();
  bool showNoMatchFound = false;
  late TabController tabController;

  Future getsignup() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "varify_studentlist.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        signuplist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Signupgetdata courselist = Signupgetdata(
            jsondata['data'][i]['Image'],
            jsondata['data'][i]['Username'],
            jsondata['data'][i]['Batch'],
            jsondata['data'][i]['Email'],
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Password'],
            jsondata['data'][i]['Balance'],
          );

          signuplist.add(courselist);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return signuplist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<void> addbalance(String roll, String balanceText, String desc) async {
    int? balance;
    try {
      balance = int.parse(balanceText);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Please enter a valid amount",
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "add_balance.php"),
        body: {
          'Roll': roll,
          'Balance': balance.toString(),
          'Description': desc,
        },
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        Sendmailuser(sendEmail!, amount!, sendname!, uroll!);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        setState(() {
          signuplist.clear();
          filteredList.clear();
          getsignup();
        });
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

  Future Sendmailuser(
      String email, String amount, String name, String roll) async {
    Map data = {"Email": email, "Amount": amount, "Name": name, "Roll": roll};
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "email_send.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        Navigator.pop(context);
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

  void _filterItems(String query) {
    filteredList.clear();
    query = query.toLowerCase();
    setState(
      () {
        if (query.isEmpty) {
          filteredList.clear();
        } else {
          filteredList = signuplist
              .where((item) =>
                  item.username.toLowerCase().contains(query) ||
                  item.roll.toLowerCase().contains(query))
              .toList();
          showNoMatchFound = filteredList.isEmpty;
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          filteredList = [];
          setState(() {});
        },
        child: Scaffold(
          backgroundColor: P.theamecolor,
          appBar: AppBar(
            backgroundColor: P.appbar2,
            iconTheme: IconThemeData(
              color: P.textcolor,
            ),
            title: Text(
              'Balance for Student',
              style: TextStyle(
                fontSize: 20,
                color: P.textcolor,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: P.textcolor,
              labelColor: P.textcolor,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(
                  child: Text(
                    "Add Balance",
                  ),
                ),
                Tab(
                  child: Text(
                    "Balance History",
                  ),
                ),
              ],
              controller: tabController,
            ),
          ),
          body: TabBarView(
            controller: tabController,
            children: [
              Column(
                children: [
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: searchController,
                      onChanged: (query) {
                        _filterItems(query.trim());
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fillColor: P.fromfillcolor,
                        filled: true,
                        labelText: "Search by UserId/Name",
                        hintText: "UserId/Name",
                        suffixIcon: Icon(
                          Icons.search,
                          color: Color.fromARGB(255, 0, 0, 0),
                          size: 30,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getsignup(),
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (data.hasData) {
                          if (showNoMatchFound) {
                            return Center(
                              child: Text(
                                "No match found",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: filteredList.isNotEmpty
                                  ? filteredList.length
                                  : signuplist.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: Colors.white,
                                  elevation: 15,
                                  child: ListTile(
                                    title: AutoSizeText(
                                      'Name:- ${filteredList.isNotEmpty ? filteredList[index].username : signuplist[index].username}'
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        AutoSizeText(
                                          'User-Id :- ${filteredList.isNotEmpty ? filteredList[index].roll : signuplist[index].roll}',
                                          maxLines: 1,
                                        ),
                                        AutoSizeText(
                                          'Batch :- ${filteredList.isNotEmpty ? filteredList[index].batch : signuplist[index].batch}',
                                          maxLines: 1,
                                        ),
                                        Row(
                                          children: [
                                            AutoSizeText(
                                              'Balance:- ',
                                              maxLines: 1,
                                            ),
                                            AutoSizeText(
                                              '₹ ${filteredList.isNotEmpty ? filteredList[index].balance : signuplist[index].balance}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.purpleAccent,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        sendname = filteredList.isNotEmpty
                                            ? filteredList[index].username
                                            : signuplist[index].username;
                                        sendEmail = filteredList.isNotEmpty
                                            ? filteredList[index].email
                                            : signuplist[index].email;
                                        uroll = filteredList.isNotEmpty
                                            ? filteredList[index].roll
                                            : signuplist[index].roll;
                                        setState(() {});
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Form(
                                              key: fromkey,
                                              child: AlertDialog(
                                                title: Text(
                                                  'Amount',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                content: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 50),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return "Can't be blank";
                                                      } else {
                                                        return null;
                                                      }
                                                    },
                                                    controller: t1,
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Icon(
                                                        Icons.currency_rupee,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      t1.text = "";
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      amount = t1.text;
                                                      setState(
                                                        () {
                                                          if (fromkey
                                                              .currentState!
                                                              .validate()) {
                                                            addbalance(
                                                              filteredList
                                                                      .isNotEmpty
                                                                  ? filteredList[
                                                                          index]
                                                                      .roll
                                                                  : signuplist[
                                                                          index]
                                                                      .roll,
                                                              t1.text,
                                                              "Balance Updated By Admin",
                                                            );
                                                            t1.text = "";
                                                            searchController
                                                                .text = "";
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'Add',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.account_balance_outlined,
                                        color: P.textcolor,
                                      ),
                                      label: AutoSizeText(
                                        'Add',
                                        style: TextStyle(
                                          color: P.textcolor,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                ],
              ),
              Adminbalancehistory(),
            ],
          ),
        ),
      ),
    );
  }
}
