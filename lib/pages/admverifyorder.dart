// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, deprecated_member_use, avoid_single_cascade_in_expression_statements, use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, unnecessary_string_interpolations, must_be_immutable, use_key_in_widget_constructors, unused_local_variable, no_logic_in_create_state, prefer_collection_literals

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/Anonomus.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/pages/Admverifyordersearch.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/shistory.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:intl/intl.dart';

class admverifyorder extends StatefulWidget {
  // const admverifyorder({super.key});
  Admin admin;
  admverifyorder(this.admin);

  @override
  State<admverifyorder> createState() => _admverifyorderState(admin);
}

class _admverifyorderState extends State<admverifyorder> {
  Admin admin;
  _admverifyorderState(this.admin);

  GlobalKey<FormState> fromkey = GlobalKey();
  RxList<Shistory> orderverifylist = <Shistory>[].obs;
  RxList<Anonomas> orderlists = <Anonomas>[].obs;
  RxInt totalOrders = 0.obs;
  RxInt totalQuantities = 0.obs;

  Set<int> selectedItems = Set<int>();
  bool selectAllEnabled = false;
  bool longPressSelectionEnabled = false;

  TextEditingController quantityController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  RxBool isVisible = false.obs;
  String rawquantity = "";
  String newquantity = "";
  String orderorderid = "";
  String redemquantity = "";

  late int usertype;

  @override
  void initState() {
    super.initState();
    selectedDate =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

    print(selectedDate);

    usertype = admin.usertype;
  }

  Future anonomasorderredem(ordid, redemquantit) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog();
      },
    );
    Map data = {
      "Orderid": ordid,
      "redem_quantity": redemquantit,
    };
    try {
      var response = await http.post(
        Uri.parse(
          MyUrl.fullurl + "anonymous_order_redeemed.php",
        ),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      print(ordid);
      print(redemquantit);
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

  Future orderhistory() async {
    Map data = {
      "Date": selectedDate.toString(),
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "anonymous_order_history.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        orderlists.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          Anonomas newlist = Anonomas(
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Purpose'],
            (int.parse(jsondata['data'][i]['Quantity']) -
                    int.parse(jsondata['data'][i]['redem_quantity']))
                .toString(),
            jsondata['data'][i]['Date'],
            jsondata['data'][i]['redem_quantity'],
          );
          orderlists.add(newlist);
        }
        isVisible.value = true;
      } else {
        // orderlists.clear();
        // Fluttertoast.showToast(
        //   msg: jsondata['msg'],
        // );
        isVisible.value = false;
      }
      totalQuantities.value =
          orderlists.fold(0, (sum, item) => sum + int.parse(item.quantites));
      return orderlists;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
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
      totalOrders.value = orderverifylist.length;
      return orderverifylist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future cancelmill(
      String roll, int order_status, String order_id, String desc) async {
    Map data = {
      "Roll": roll,
      "Order_status": order_status.toString(),
      "Order_id": order_id,
      "Description": desc,
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
        Navigator.pop(context);
        Fluttertoast.cancel();
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

  Future<void> _refreshData() async {
    await getorderverify();
    setState(
      () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  List<Widget> buildAppBarActions() {
    List<Widget> actions = [];

    if (selectedItems.isNotEmpty) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.delete,
            color: P.textcolor,
          ),
          onPressed: () {
            if (selectedItems.isNotEmpty) {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.bottomSlide,
                title: 'Cancel Order'.toUpperCase(),
                desc: 'Are you Sure?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  setState(
                    () {
                      for (int index in selectedItems.toList()) {
                        cancelmill(
                          orderverifylist[index].roll,
                          0,
                          orderverifylist[index].order_id,
                          "Meal Canceled By Admin",
                        );
                        selectedItems.remove(index);
                        _refreshData();
                      }
                    },
                  );
                },
                btnCancelColor: Colors.green,
                btnOkColor: Colors.red,
              )..show();
            }
          },
        ),
      );
      actions.add(
        IconButton(
          icon: Icon(
            selectAllEnabled ? Icons.check_box : Icons.check_box_outline_blank,
            color: P.textcolor,
          ),
          onPressed: () {
            setState(
              () {
                if (selectAllEnabled) {
                  selectedItems.clear();
                } else {
                  selectedItems.addAll(
                      List.generate(orderverifylist.length, (index) => index));
                }
                selectAllEnabled = !selectAllEnabled;
              },
            );
          },
        ),
      );
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(
      DateTime.now(),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.theamecolor,
        appBar: selectedItems.isEmpty
            ? AppBar(
                backgroundColor: P.appbar2,
                iconTheme: IconThemeData(
                  color: P.textcolor,
                ),
                title: Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 20,
                    color: P.textcolor,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Admverifyordersearch(
                            admin,
                          ),
                        ),
                      ).whenComplete(
                        () => _refreshData(),
                      );
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              )
            : AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: P.textcolor,
                  ),
                  onPressed: () {
                    setState(() {
                      selectedItems.clear();
                    });
                  },
                ),
                backgroundColor: Colors.grey.shade600,
                title: Text(
                  " ${selectedItems.length} SELECTED ".toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: P.textcolor,
                  ),
                ),
                actions: buildAppBarActions(),
              ),
        floatingActionButton: SizedBox(
          width: 160,
          child: FloatingActionButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Total Meal:",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                Obx(
                  () => AutoSizeText(
                    "${totalOrders.value + totalQuantities.value}",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                formattedDate,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Obx(
                      () => Visibility(
                        visible: isVisible.value,
                        child: FutureBuilder(
                          future: orderhistory(),
                          builder: (BuildContext context, AsyncSnapshot data) {
                            if (data.hasData) {
                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: orderlists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    elevation: 15,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(9),
                                      ),
                                    ),
                                    color: Colors.white,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: P.appbar2,
                                        child: AutoSizeText(
                                          '${orderlists[index].quantites}'
                                              .toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ),
                                      title: Text(
                                        '${orderlists[index].purpous}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'Order_id:-# ${orderlists[index].orderid}',
                                            maxLines: 2,
                                          ),
                                          Text(
                                            'Date:- ${DateFormat('dd-MM-yyyy').format(
                                              DateTime.parse(
                                                orderlists[index].dates,
                                              ),
                                            )}',
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                      trailing: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        onPressed: () {
                                          rawquantity =
                                              orderlists[index].quantites;
                                          redemquantity =
                                              orderlists[index].rquantites;
                                          orderorderid =
                                              orderlists[index].orderid;
                                          quantityController.text = rawquantity;

                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder:
                                                    (context, internalstate) {
                                                  return Form(
                                                    key: fromkey,
                                                    child: AlertDialog(
                                                      title: Text(
                                                        'Enter Quantity',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 50),
                                                        child: TextFormField(
                                                          controller:
                                                              quantityController,
                                                          validator: (value) {
                                                            if (value!
                                                                .isEmpty) {
                                                              return "Can't left blank";
                                                            } else {
                                                              return null;
                                                            }
                                                          },
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets
                                                                    .symmetric(
                                                              vertical: 6,
                                                            ),
                                                            prefixIcon: Icon(
                                                              Icons.person,
                                                              size: 30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            quantityController
                                                                .text = "";
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            if (fromkey
                                                                .currentState!
                                                                .validate()) {
                                                              if (int.parse(
                                                                          rawquantity) >=
                                                                      int.parse(
                                                                          quantityController
                                                                              .text) &&
                                                                  int.parse(quantityController
                                                                          .text) >=
                                                                      0) {
                                                                anonomasorderredem(
                                                                  orderorderid,
                                                                  quantityController
                                                                      .text,
                                                                ).whenComplete(
                                                                  () => Navigator
                                                                      .pop(
                                                                          context),
                                                                );
                                                              } else {
                                                                Fluttertoast
                                                                    .showToast(
                                                                  msg:
                                                                      'Enter valid quantity',
                                                                );
                                                              }
                                                            }
                                                            quantityController
                                                                .text = "";
                                                          },
                                                          child: Text(
                                                            'OK',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors.red,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: AutoSizeText(
                                          'Redeemed',
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
                    FutureBuilder(
                      future: getorderverify(),
                      builder: (BuildContext context, AsyncSnapshot data) {
                        if (data.hasData) {
                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderverifylist.length,
                            itemBuilder: (BuildContext context, int index) {
                              bool isSelected = selectedItems.contains(index);
                              return Card(
                                elevation: 22,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                color: isSelected
                                    ? Colors.grey.shade600
                                    : Colors.white,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          AutoSizeText(
                                            'Order_status :- ',
                                            maxLines: 1,
                                          ),
                                          AutoSizeText(
                                            '${orderverifylist[index].order_status}'
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
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      AutoSizeText(
                                        'Name :- ${orderverifylist[index].name}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'Date :- ${DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                            orderverifylist[index].date,
                                          ),
                                        )}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'User-Id :- ${orderverifylist[index].roll}',
                                        maxLines: 1,
                                      ),
                                      AutoSizeText(
                                        'Order_id :- # ${orderverifylist[index].order_id}',
                                        maxLines: 1,
                                      ),
                                      // AutoSizeText(
                                      //   'Order Placed :: ${DateFormat('dd-MM-yyyy \t\t hh:mm:ss').format(
                                      //     DateTime.parse(
                                      //       orderverifylist[index].created_at,
                                      //     ),
                                      //   )}',
                                      //   maxLines: 1,
                                      // ),
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
                                              title:
                                                  'Cancel Order'.toUpperCase(),
                                              desc: 'Are you Sure ?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                cancelmill(
                                                  orderverifylist[index].roll,
                                                  0,
                                                  orderverifylist[index]
                                                      .order_id,
                                                  "Meal Canceled By ADMIN",
                                                ).whenComplete(
                                                  () => _refreshData(),
                                                );
                                              },
                                              btnCancelColor: Colors.green,
                                              btnOkColor: Colors.red,
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
                                  onLongPress: () {
                                    setState(() {
                                      longPressSelectionEnabled = true;
                                      if (isSelected) {
                                        selectedItems.remove(index);
                                      } else {
                                        selectedItems.add(index);
                                      }
                                    });
                                  },
                                  onTap: () {
                                    if (longPressSelectionEnabled) {
                                      setState(() {
                                        if (isSelected) {
                                          selectedItems.remove(index);
                                        } else {
                                          selectedItems.add(index);
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            },
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
