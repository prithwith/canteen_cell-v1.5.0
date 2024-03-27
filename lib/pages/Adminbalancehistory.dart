// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks, avoid_print, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, file_names

import 'dart:convert';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:flutter/material.dart';
import 'package:canteen_cell/models/Usertrunsition.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/utils/url1.dart';
import 'package:intl/intl.dart';

class Adminbalancehistory extends StatefulWidget {
  const Adminbalancehistory({super.key});

  @override
  State<Adminbalancehistory> createState() => _AdminbalancehistoryState();
}

class _AdminbalancehistoryState extends State<Adminbalancehistory> {
  String selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String displaydate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  List<Usertrunsition> balancehistorylist = [];

  @override
  void initState() {
    //getorderallhistory(selectedDate);
    print(DateTime.now());
    super.initState();
  }

  Future getorderallhistory(String selectDate) async {
    Map data = {
      "Date": selectedDate,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_user_transaction.php"),
        body: data,
      );
      balancehistorylist.clear();
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        for (int i = 0; i < jsondata['data'].length; i++) {
          Usertrunsition newlist = Usertrunsition(
            jsondata['data'][i]['Username'],
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Batch'],
            jsondata['data'][i]['id'],
            jsondata['data'][i]['date'],
            jsondata['data'][i]['amount'],
            jsondata['data'][i]['Balance'],
            jsondata['data'][i]['Description'],
          );
          balancehistorylist.add(newlist);
        }
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
        backgroundColor: P.theamecolor,
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
                  initialDate: DateFormat("yyyy-MM-dd").parse(selectedDate),
                  firstDate: DateTime(2023),
                  lastDate: DateTime(2099),
                ).then(
                  (pickedDate) {
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        print(pickedDate);
                        //getorderallhistory(pickedDate);
                        selectedDate =
                            DateFormat("yyyy-MM-dd").format(pickedDate);
                        displaydate =
                            DateFormat("dd-MM-yyyy").format(pickedDate);
                      });
                    }
                  },
                );
              },
              icon: Icon(Icons.calendar_month),
              label: Text(
                "Choose date".toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              displaydate,
            ),
            FutureBuilder(
              future: getorderallhistory(selectedDate),
              builder: (BuildContext context, AsyncSnapshot data) {
                if (data.hasData && balancehistorylist.isNotEmpty) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: balancehistorylist.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                            //  balancehistorylist[index].desc ==
                            //         "Balance Updated By Admin"
                            //     ?
                            Card(
                          elevation: 10,
                          margin: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title:
                                    Text('${balancehistorylist[index].name}'),
                                subtitle: Text(
                                    'ID: ${balancehistorylist[index].userid}'),
                                trailing: Text(
                                  '₹${balancehistorylist[index].ammount}',
                                  style: TextStyle(
                                      color: int.parse(balancehistorylist[index]
                                                  .ammount) >
                                              0
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "Available Balance: ₹${balancehistorylist[index].balance}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 122, 80, 4)),
                                ),
                              ),
                            ],
                          ),
                        )
                            // : Container()
                            ;
                      },
                    ),
                  );
                } else if (data.hasData && balancehistorylist.isEmpty) {
                  return Expanded(
                    child: Center(
                        child: Text(
                      'No History Found',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    )),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          Colors.redAccent,
                        ),
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
