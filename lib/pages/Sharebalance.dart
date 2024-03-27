// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_final_fields, must_be_immutable, use_key_in_widget_constructors, file_names, no_logic_in_create_state, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Sharebalance extends StatefulWidget {
  // const Sharebalance({super.key});

  // String amount;
  User user;
  Sharebalance(this.user);

  @override
  State<Sharebalance> createState() => _SharebalanceState(user);
}

class _SharebalanceState extends State<Sharebalance> {
  // String amount;
  User user;
  _SharebalanceState(this.user);

  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController moneycontroller = TextEditingController();
  List<Signupgetdata> signuplist = [];
  TextEditingController searchController = TextEditingController();
  List<Signupgetdata> filteredList = [];
  FocusNode _focusNode = FocusNode();
  bool showNoMatchFound = false;

  String uroll = "";
  String uname = "";

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

  Future<void> sharebalance(String roll, String userroll, String balanceText,
      String desc, String userdesc) async {
    showDialog(
      context: context,
      builder: (context) => LoadingDialog(),
      barrierDismissible: false,
    );
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
        Uri.parse(MyUrl.fullurl + "share_balance.php"),
        body: {
          'Roll': roll,
          'UserRoll': userroll,
          'Balance': balance.toString(),
          'Description': desc,
          'Userdescription': userdesc,
        },
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
        Navigator.pop(context);
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
              "Share Balance",
              style: TextStyle(
                fontSize: 20,
                color: P.textcolor,
              ),
            ),
          ),
          body: Column(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                    uroll = filteredList.isNotEmpty
                                        ? filteredList[index].roll
                                        : signuplist[index].roll;
                                    uname = filteredList.isNotEmpty
                                        ? filteredList[index].username
                                        : signuplist[index].username;

                                    uroll == user.Roll
                                        ? Fluttertoast.showToast(
                                            msg: "Can't Send Money To Yourself",
                                          )
                                        : showDialog(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  content: Container(
                                                    margin: EdgeInsets.only(
                                                        left: 50),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return "Can't be blank";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      controller:
                                                          moneycontroller,
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
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
                                                        moneycontroller.text =
                                                            "";
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
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              LoadingDialog(),
                                                          barrierDismissible:
                                                              false,
                                                        );

                                                        if (fromkey
                                                            .currentState!
                                                            .validate()) {
                                                          if (int.parse(moneycontroller
                                                                      .text
                                                                      .toString()) <=
                                                                  int.parse(user
                                                                      .Balance) &&
                                                              int.parse(moneycontroller
                                                                      .text
                                                                      .toString()) >
                                                                  0) {
                                                            sharebalance(
                                                              uroll,
                                                              user.Roll,
                                                              moneycontroller
                                                                  .text,
                                                              "Money Added by ( ${user.Username} ) ",
                                                              "Money Send to ( $uname ) ",
                                                            );
                                                          } else {
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Enter valid amount",
                                                            );
                                                          }
                                                        }
                                                        searchController.text =
                                                            "";
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
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
        ),
      ),
    );
  }
}
