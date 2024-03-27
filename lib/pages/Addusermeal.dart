// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/pages/Addmealorder.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';

class Addusermeal extends StatefulWidget {
  const Addusermeal({super.key});

  @override
  State<Addusermeal> createState() => _AddusermealState();
}

class _AddusermealState extends State<Addusermeal> {
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController t1 = TextEditingController();
  List<Signupgetdata> signuplist = [];
  TextEditingController searchController = TextEditingController();
  List<Signupgetdata> filteredList = [];
  // bool showList = false;
  FocusNode _focusNode = FocusNode();
  bool showNoMatchFound = false;

  late Signupgetdata passroll;

  Future getsignup() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "all_user.php"),
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
          // showList = false;
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
              'Add User Meal',
              style: TextStyle(
                fontSize: 18,
                color: P.textcolor,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Container(
                height: 75,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                child: TextField(
                  focusNode: _focusNode,
                  controller: searchController,
                  onChanged: (query) {
                    _filterItems(query.trim());
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    fillColor: P.fromfillcolor,
                    filled: true,
                    labelText: "Search by UserId/Name",
                    hintText: "UserId/Name",
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
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
                            "No Match Found",
                            style: TextStyle(
                              color: Colors.grey,
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
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'User-Id: ${filteredList.isNotEmpty ? filteredList[index].roll : signuplist[index].roll}',
                                    ),
                                    Text(
                                      'Batch: ${filteredList.isNotEmpty ? filteredList[index].batch : signuplist[index].batch}',
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Balance: ',
                                        ),
                                        Text(
                                          '₹ ${filteredList.isNotEmpty ? filteredList[index].balance : signuplist[index].balance}',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.purpleAccent,
                                          ),
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
                                    passroll = filteredList.isNotEmpty
                                        ? filteredList[index]
                                        : signuplist[index];

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Addmealorder(
                                          passroll,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: P.textcolor,
                                  ),
                                  label: AutoSizeText(
                                    'Add',
                                    style: TextStyle(
                                      color: P.textcolor,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
            ],
          ),
        ),
      ),
    );
  }
}
