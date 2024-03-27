// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, non_constant_identifier_names, prefer_const_constructors

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/course.dart';
import 'package:canteen_cell/pages/Adminbatch.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Adminacourse extends StatefulWidget {
  const Adminacourse({super.key});

  @override
  State<Adminacourse> createState() => _AdminacourseState();
}

class _AdminacourseState extends State<Adminacourse> {
  List<Course> courselist = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController coursecontroller = TextEditingController();

  Future getcourse() async {
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "course.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        courselist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          Course course = Course(
            int.parse(jsondata["data"][i]["course_id"]),
            jsondata["data"][i]["course"],
          );
          courselist.add(course);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return courselist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future Addcourse(String cours) async {
    Map data = {
      "course": cours,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "add_course.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
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

  Future Deletecourse(String course_id) async {
    Map data = {
      "course_id": course_id,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "delete_course.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
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

  Future<void> _refreshData() async {
    await getcourse();
    setState(
      () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            "Course's",
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: P.theamecolor,
        body: RefreshIndicator(
          onRefresh: _refreshData,
          color: Colors.red,
          child: FutureBuilder(
            future: getcourse(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                return ListView.builder(
                  itemCount: courselist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        title: AutoSizeText(
                          ' ${courselist[index].course_name}'.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          maxLines: 1,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Adminbatch(
                                courselist[index].course_id.toString(),
                              ),
                            ),
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                        "Delete Course",
                                      ),
                                      content: Text(
                                        "Are You Sure ?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Deletecourse(
                                              courselist[index]
                                                  .course_id
                                                  .toString(),
                                            )
                                                .whenComplete(
                                                  () => _refreshData(),
                                                )
                                                .whenComplete(
                                                  () => Navigator.pop(context),
                                                );
                                          },
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                            ),
                          ],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  title: Center(
                    child: Text(
                      ":: Add Course ::".toUpperCase(),
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                  content: Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Form(
                      key: fromkey,
                      child: TextFormField(
                        controller: coursecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Cannot left Blank!';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 40,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        coursecontroller.text = "";
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (fromkey.currentState!.validate()) {
                          Addcourse(coursecontroller.text).whenComplete(() {
                            Navigator.pop(context);
                            _refreshData();
                          });
                          coursecontroller.text = "";
                        } else {
                          Fluttertoast.showToast(
                            msg: "Enter value !",
                          );
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }
}
