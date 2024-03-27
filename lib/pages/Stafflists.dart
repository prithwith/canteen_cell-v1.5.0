// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, prefer_collection_literals, use_build_context_synchronously, unnecessary_string_interpolations, deprecated_member_use, avoid_single_cascade_in_expression_statements

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/pages/Stafflistssearch.dart';
import 'package:canteen_cell/pages/Userdataupdate.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:canteen_cell/utils/url1.dart';

class Userlists extends StatefulWidget {
  const Userlists({super.key});

  @override
  State<Userlists> createState() => _UserlistsState();
}

class _UserlistsState extends State<Userlists> {
  List<Signupgetdata> signuplist = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  Set<int> selectedItems = Set<int>();
  bool selectAllEnabled = false;
  TextEditingController searchcontroller = TextEditingController();
  RxInt totalnumber = 0.obs;
  bool longPressSelectionEnabled = false;

  String imagepass = "";
  String namepass = "";
  String batchpass = "";
  String emailpass = "";
  String rollpass = "";

  Future getsignup() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "verify_stafflist.php"),
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
      totalnumber.value = signuplist.length;
      return signuplist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future permission(String roll, int status) async {
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

  Future<void> _refreshData() async {
    await getsignup();
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
                title: 'Disable Account '.toUpperCase(),
                desc: 'Are you Sure?',
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  setState(
                    () {
                      for (int index in selectedItems.toList()) {
                        permission(signuplist[index].roll, 0);
                        selectedItems.remove(index);
                        _refreshData();
                      }
                    },
                  );
                },
                btnOkColor: Colors.red,
                btnCancelColor: Colors.green,
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
                  "Staff's List",
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
                          builder: (context) => Stafflistsearch(),
                        ),
                      ).whenComplete(
                        () => _refreshData(),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                    ),
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
        body: FutureBuilder(
          future: getsignup(),
          builder: (BuildContext context, AsyncSnapshot data) {
            if (data.hasData) {
              return ListView.builder(
                itemCount: signuplist.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isSelected = selectedItems.contains(index);
                  return Card(
                    elevation: 22,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    color: isSelected ? Colors.grey.shade600 : Colors.white,
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: MyUrl.fullurl +
                                MyUrl.imageurl +
                                signuplist[index].image,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.red),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: imageProvider,
                                  ),
                                ),
                              );
                            },
                          ),
                          title: AutoSizeText(
                            '${signuplist[index].username}',
                            maxLines: 2,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                '${signuplist[index].email}',
                                maxLines: 2,
                              ),
                              AutoSizeText(
                                'Id: ${signuplist[index].roll}',
                                maxLines: 1,
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
                            setState(() {
                              if (longPressSelectionEnabled) {
                                if (isSelected) {
                                  selectedItems.remove(index);
                                } else {
                                  selectedItems.add(index);
                                }
                              }
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                              ),
                              onPressed: () {
                                imagepass = signuplist[index].image;
                                namepass = signuplist[index].username;
                                batchpass = signuplist[index].batch;
                                emailpass = signuplist[index].email;
                                rollpass = signuplist[index].roll;

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Userdataupdate(
                                      imagepass,
                                      namepass,
                                      batchpass,
                                      emailpass,
                                      rollpass,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.edit,
                                color: P.textcolor,
                              ),
                              label: Text(
                                "Edit".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: P.textcolor,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.info,
                                  animType: AnimType.bottomSlide,
                                  title: 'Disable Account '.toUpperCase(),
                                  desc: 'Are you Sure?',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    setState(
                                      () {
                                        permission(signuplist[index].roll, 0);
                                        selectedItems.remove(index);
                                        _refreshData();
                                      },
                                    );
                                  },
                                  btnOkColor: Colors.red,
                                  btnCancelColor: Colors.green,
                                )..show();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: P.textcolor,
                              ),
                              label: Text(
                                "Disable".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: P.textcolor,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
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
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          onPressed: () {},
          child: Obx(
            () => AutoSizeText(
              "${totalnumber.value}",
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
