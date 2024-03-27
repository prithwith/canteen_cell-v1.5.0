// ignore_for_file: prefer_const_constructors, avoid_single_cascade_in_expression_statements, prefer_interpolation_to_compose_strings, non_constant_identifier_names, use_build_context_synchronously, must_be_immutable, use_key_in_widget_constructors, no_logic_in_create_state, prefer_final_fields, avoid_print

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/Anonomus.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:intl/intl.dart';

class Admverifyordersearch extends StatefulWidget {
  // const Admverifyordersearch({super.key});
  Admin admin;
  Admverifyordersearch(this.admin);

  @override
  State<Admverifyordersearch> createState() =>
      _AdmverifyordersearchState(admin);
}

class _AdmverifyordersearchState extends State<Admverifyordersearch> {
  Admin admin;
  _AdmverifyordersearchState(this.admin);
  List<Shistory> orderverifylist = [];

  TextEditingController searchController = TextEditingController();
  List<Shistory> filteredList = [];
  FocusNode _focusNode = FocusNode();
  bool showNoMatchFound = false;
  DateTime selectedDate = DateTime.now();
  List<Anonomas> orderlists = [];
  bool isVisible = true;

  late int usertype;

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    print(selectedDate);

    usertype = admin.usertype;
  }

  Future getorderverify() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "student_order_verify.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        orderverifylist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Shistory historylists = Shistory(
            jsondata['data'][i]['Order_status'],
            jsondata['data'][i]['Username'],
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Date'],
            jsondata['data'][i]['created_at'],
          );
          orderverifylist.add(historylists);
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
      return orderverifylist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future cancelmill(String roll, int order_status, String order_id) async {
    Map data = {
      "Roll": roll,
      "Order_status": order_status.toString(),
      "Order_id": order_id,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_order.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        setState(() {});
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      } else {
        // Navigator.pop(context);
        // Fluttertoast.cancel();
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<void> _refreshData() async {
    await getorderverify();
    setState(
      () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  void _filterItems(String query) {
    filteredList.clear();
    query = query.toLowerCase();
    setState(
      () {
        if (query.isEmpty) {
          filteredList.clear();
        } else {
          filteredList = orderverifylist
              .where((item) =>
                  item.name.toLowerCase().contains(query) ||
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
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: P.secondtheamecolor,
          body: Column(
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: TextFormField(
                  focusNode: _focusNode,
                  onTap: () {
                    setState(() {});
                  },
                  controller: searchController,
                  onChanged: (query) {
                    _filterItems(query.trim());
                  },
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    fillColor: P.fromfillcolor,
                    filled: true,
                    labelText: "Search UserId/Name",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    hintText: "UserId / Name",
                    hintStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        searchController.clear();
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                      ),
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: P.textcolor2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: getorderverify(),
                  builder: (BuildContext context, AsyncSnapshot data) {
                    if (data.hasData) {
                      if (showNoMatchFound) {
                        return Center(
                          child: Text(
                            "No Order Found",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredList.isNotEmpty
                                ? filteredList.length
                                : orderverifylist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 22,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(13),
                                  ),
                                ),
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            AutoSizeText(
                                              'Order_status : - ',
                                            ),
                                            AutoSizeText(
                                              ' ${orderverifylist[index].order_status}'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: orderverifylist[index]
                                                            .order_status ==
                                                        'Confirmed'
                                                    ? P.confirm
                                                    : orderverifylist[index]
                                                                .order_status ==
                                                            'Redeemed'
                                                        ? P.redeem
                                                        : P.unknown,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AutoSizeText(
                                          'Name : - ${filteredList.isNotEmpty ? filteredList[index].name : orderverifylist[index].name}',
                                        ),
                                        AutoSizeText(
                                          'Date :- ${DateFormat('dd-MM-yyyy').format(
                                            DateTime.parse(
                                              filteredList.isNotEmpty
                                                  ? filteredList[index].date
                                                  : orderverifylist[index].date,
                                            ),
                                          )}',
                                        ),
                                        AutoSizeText(
                                          'User-Id : - ${filteredList.isNotEmpty ? filteredList[index].roll : orderverifylist[index].roll}',
                                        ),
                                        AutoSizeText(
                                          'Order_id : - # ${filteredList.isNotEmpty ? filteredList[index].order_id : orderverifylist[index].order_id}',
                                        ),
                                      ],
                                    ),
                                    subtitle: usertype == 1
                                        ? ElevatedButton.icon(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            onPressed: () {
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.info,
                                                animType: AnimType.bottomSlide,
                                                title: 'Cancel Order'
                                                    .toUpperCase(),
                                                desc: 'Are you Sure ?',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {
                                                  cancelmill(
                                                    orderverifylist[index].roll,
                                                    0,
                                                    orderverifylist[index]
                                                        .order_id,
                                                  ).whenComplete(
                                                    () => _refreshData()
                                                        .whenComplete(
                                                      () =>
                                                          filteredList.clear(),
                                                    ),
                                                  );
                                                },
                                              )..show();
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: P.textcolor,
                                            ),
                                            label: Text(
                                              "Cancel".toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: P.textcolor,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              );
                            },
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
            ],
          ),
        ),
      ),
    );
  }
}
