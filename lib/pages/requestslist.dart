// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, deprecated_member_use, avoid_single_cascade_in_expression_statements, unused_local_variable, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, prefer_collection_literals

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/colorclass.dart';

class Requestslist extends StatefulWidget {
  const Requestslist({super.key});

  @override
  State<Requestslist> createState() => _RequestslistState();
}

class _RequestslistState extends State<Requestslist> {
  List<Signupgetdata> signuplist = [];
  Set<int> selectedItems = Set<int>();
  bool selectAllEnabled = false;
  bool longPressSelectionEnabled = false;

  Future<void> permission(String roll, int status) async {
    Map data = {
      'Roll': roll,
      'Status': status.toString(),
    };
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_varify.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
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

  Future getsignup() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "signup_getdata.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      signuplist.clear();
      if (jsondata["status"] == "true") {
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
      }
      // else {
      //   Fluttertoast.showToast(
      //     msg: jsondata['msg'],
      //   );
      // }
      return signuplist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  List<Widget> buildAppBarActions() {
    List<Widget> actions = [];

    if (selectedItems.isNotEmpty) {
      actions.add(
        IconButton(
          icon: Icon(
            Icons.check,
            color: P.textcolor,
          ),
          onPressed: () {
            if (selectedItems.isNotEmpty) {
              Set<int> selectedItemsCopy = Set<int>.from(selectedItems);
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.bottomSlide,
                title: 'Verify Account'.toUpperCase(),
                desc: 'Are you Sure?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  setState(
                    () {
                      for (int index in selectedItems.toList()) {
                        permission(signuplist[index].roll, 1).whenComplete(() {
                          selectedItems.remove(index);
                        });
                      }
                    },
                  );
                },
              )..show();
            }
          },
        ),
      );
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
                dialogType: DialogType.warning,
                animType: AnimType.bottomSlide,
                title: 'Account Delete'.toUpperCase(),
                desc: 'Are you Sure?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  setState(
                    () {
                      for (int index in selectedItems.toList()) {
                        permission(signuplist[index].roll, 2);
                        selectedItems.remove(index);
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
                      List.generate(signuplist.length, (index) => index));
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
                  "Request's List",
                  style: TextStyle(
                    fontSize: 18,
                    color: P.textcolor,
                  ),
                ),
                centerTitle: true,
                actions: buildAppBarActions(),
              )
            : AppBar(
                backgroundColor: Colors.grey.shade600,
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
                title: Text(
                  " ${selectedItems.length} SELECTED ".toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: P.textcolor,
                  ),
                ),
                actions: buildAppBarActions(),
              ),
        body: Scrollbar(
          thickness: 10,
          trackVisibility: true,
          radius: Radius.circular(
            10,
          ),
          child: FutureBuilder(
            future: getsignup(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                if (signuplist.isNotEmpty) {
                  return ListView.builder(
                    itemCount: signuplist.length,
                    itemBuilder: (BuildContext context, int index) {
                      bool isSelected = selectedItems.contains(index);
                      return Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              10,
                            ),
                          ),
                        ),
                        color: isSelected ? Colors.grey.shade600 : Colors.white,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AutoSizeText(
                                'Name:- ${signuplist[index].username}'
                                    .toUpperCase(),
                                maxLines: 2,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AutoSizeText(
                                'Batch:- ${signuplist[index].batch}',
                                maxLines: 1,
                              ),
                              AutoSizeText(
                                'Email:- ${signuplist[index].email}',
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                'User-Id:- ${signuplist[index].roll}',
                                maxLines: 1,
                              ),
                              // AutoSizeText(
                              //   'Password:- ${signuplist[index].password}',
                              //   maxLines: 1,
                              // ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    animType: AnimType.bottomSlide,
                                    title: 'Account Delete'.toUpperCase(),
                                    desc: 'Are you Sure?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      permission(signuplist[index].roll, 2)
                                          .whenComplete(() {
                                        setState(() {
                                          selectedItems.remove(index);
                                        });
                                      });
                                    },
                                    btnCancelColor: Colors.green,
                                    btnOkColor: Colors.red,
                                  )..show();
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  size: 22,
                                  color: P.textcolor,
                                ),
                                label: Text(
                                  'Reject'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: P.textcolor,
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: StadiumBorder(),
                                ),
                                onPressed: () {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.info,
                                    animType: AnimType.bottomSlide,
                                    title: 'Verify Account'.toUpperCase(),
                                    desc: 'Are you Sure?',
                                    btnCancelOnPress: () {},
                                    btnOkOnPress: () {
                                      permission(signuplist[index].roll, 1)
                                          .whenComplete(() {
                                        setState(() {
                                          selectedItems.remove(index);
                                        });
                                      });
                                    },
                                  )..show();
                                },
                                icon: Icon(
                                  Icons.check_circle,
                                  size: 22,
                                  color: P.textcolor,
                                ),
                                label: Text(
                                  'Accept'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: P.textcolor,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Image.asset(
                            "Assets/images/empty_folder.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No User Found",
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
      ),
    );
  }
}
