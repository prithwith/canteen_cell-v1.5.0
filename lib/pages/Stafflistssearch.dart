// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, prefer_final_fields, prefer_interpolation_to_compose_strings, avoid_single_cascade_in_expression_statements, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/pages/Userdataupdate.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/sighupgetdata.dart';
import 'package:canteen_cell/utils/url1.dart';

class Stafflistsearch extends StatefulWidget {
  const Stafflistsearch({super.key});

  @override
  State<Stafflistsearch> createState() => _StafflistsearchState();
}

class _StafflistsearchState extends State<Stafflistsearch> {
  List<Signupgetdata> signuplist = [];
  List<Signupgetdata> filteredList = [];
  FocusNode _focusNode = FocusNode();
  bool showNoMatchFound = false;
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController searchController = TextEditingController();

  String namepass = "";
  String batchpass = "";
  String emailpass = "";
  String rollpass = "";
  String imagepass = "";

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
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: P.theamecolor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
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
                  future: getsignup(),
                  builder: (BuildContext context, AsyncSnapshot data) {
                    if (data.hasData) {
                      if (showNoMatchFound) {
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
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: filteredList.isNotEmpty
                                ? filteredList.length
                                : signuplist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                elevation: 22,
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
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: CachedNetworkImage(
                                        imageUrl: MyUrl.fullurl +
                                            MyUrl.imageurl +
                                            (filteredList.isNotEmpty
                                                ? filteredList[index].image
                                                : signuplist[index].image),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: Colors.red),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: imageProvider,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            '${filteredList.isNotEmpty ? filteredList[index].username : signuplist[index].username}',
                                            maxLines: 2,
                                          ),
                                          AutoSizeText(
                                              '${filteredList.isNotEmpty ? filteredList[index].batch : signuplist[index].batch}'),
                                        ],
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AutoSizeText(
                                            '${filteredList.isNotEmpty ? filteredList[index].email : signuplist[index].email}',
                                            maxLines: 2,
                                          ),
                                          AutoSizeText(
                                            'Id: ${filteredList.isNotEmpty ? filteredList[index].roll : signuplist[index].roll}',
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.lightBlue,
                                          ),
                                          onPressed: () {
                                            imagepass = filteredList.isNotEmpty
                                                ? filteredList[index].image
                                                : signuplist[index].image;
                                            namepass = filteredList.isNotEmpty
                                                ? filteredList[index].username
                                                : signuplist[index].username;
                                            batchpass = filteredList.isNotEmpty
                                                ? filteredList[index].batch
                                                : signuplist[index].batch;
                                            emailpass = filteredList.isNotEmpty
                                                ? filteredList[index].email
                                                : signuplist[index].email;
                                            rollpass = filteredList.isNotEmpty
                                                ? filteredList[index].roll
                                                : signuplist[index].roll;

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Userdataupdate(
                                                  imagepass,
                                                  namepass,
                                                  batchpass,
                                                  emailpass,
                                                  rollpass,
                                                ),
                                              ),
                                            ).whenComplete(
                                              () => filteredList.clear(),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: P.textcolor,
                                          ),
                                          label: Text(
                                            "Edit",
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
                                              title: 'Disable Account '
                                                  .toUpperCase(),
                                              desc: 'Are you Sure?',
                                              btnCancelOnPress: () {},
                                              btnOkOnPress: () {
                                                setState(
                                                  () {
                                                    permission(
                                                        filteredList.isNotEmpty
                                                            ? filteredList[
                                                                    index]
                                                                .roll
                                                            : signuplist[index]
                                                                .roll,
                                                        0);
                                                    _refreshData();
                                                    filteredList.clear();
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
                                            "Disable",
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
