// ignore_for_file: use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, non_constant_identifier_names, no_logic_in_create_state, prefer_const_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/batch.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Adminbatch extends StatefulWidget {
  // const Adminbatch(String bat, {super.key});
  String bat;
  Adminbatch(this.bat);

  @override
  State<Adminbatch> createState() => _AdminbatchState(bat);
}

class _AdminbatchState extends State<Adminbatch> {
  String bat;
  _AdminbatchState(this.bat);

  List<Batch> batchlist = [];
  GlobalKey<FormState> fromkey = GlobalKey();
  TextEditingController batchcontroller = TextEditingController();

  Future getbatch() async {
    Map data = {
      'course_id': bat,
    };
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "batch.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        batchlist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          Batch batch = Batch(
            int.parse(jsondata["data"][i]["batch_id"]),
            int.parse(jsondata["data"][i]["course_id"]),
            jsondata["data"][i]["batch"],
          );
          batchlist.add(batch);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return batchlist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future Addbatch(String batch) async {
    Map data = {
      "course_id": bat,
      "batch": batch,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "add_batch.php"),
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

  Future Deletebatch(String batch_id) async {
    Map data = {
      "batch_id": batch_id,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "delete_batch.php"),
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
    await getbatch();
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
            "Batches",
            style: TextStyle(
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
            future: getbatch(),
            builder: (BuildContext context, AsyncSnapshot data) {
              if (data.hasData) {
                return ListView.builder(
                  itemCount: batchlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: ListTile(
                        title: AutoSizeText(
                          ' ${batchlist[index].batch_name}'.toUpperCase(),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          maxLines: 2,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Delete Batch",
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
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Deletebatch(
                                          batchlist[index].batch_id.toString(),
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
                      ":: Add Batch ::".toUpperCase(),
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
                        controller: batchcontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Cannot left Blank!';
                          } else {
                            return null;
                          }
                        },
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        batchcontroller.text = "";
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
                          Addbatch(
                            batchcontroller.text,
                          ).whenComplete(
                            () {
                              Navigator.pop(context);
                              _refreshData();
                            },
                          );
                          batchcontroller.text = "";
                        } else {
                          Fluttertoast.showToast(
                            msg: "Enter value !",
                          );
                        }
                      },
                      child: Text(
                        'Add',
                        style: TextStyle(fontSize: 17),
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
