// ignore_for_file: prefer_const_constructors, unused_field, prefer_interpolation_to_compose_strings, avoid_print, use_build_context_synchronously, non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/course.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/login.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/colorclass.dart';

class signupu extends StatefulWidget {
  const signupu({super.key});

  @override
  State<signupu> createState() => _signupuState();
}

class _signupuState extends State<signupu> {
  GlobalKey<FormState> fromkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  bool typ = true;
  String _password = '';
  String _confirmPassword = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        getcourse().whenComplete(
          () {
            Navigator.pop(context);
            setState(() {});
            print(courselist);
          },
        );
      },
    );
    super.initState();
  }

  List<String> courselist = [];
  List<String> batchlist = [];
  List<String> courseidlist = [];

  Future getcourse() async {
    showDialog(
        context: context,
        builder: (context) => LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.get(
        Uri.parse(MyUrl.fullurl + "course.php"),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        courselist.clear();
        courseidlist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          Course course = Course(int.parse(jsondata["data"][i]["course_id"]),
              jsondata["data"][i]["course"]);
          courselist.add(course.course_name);
          courseidlist.add(course.course_id.toString());
        }
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

  Future getbatch(int id) async {
    Map data = {'course_id': id.toString()};
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "batch.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      batchlist.clear();
      if (jsondata["status"] == true) {
        for (int i = 0; i < jsondata["data"].length; i++) {
          batchlist.add(jsondata['data'][i]['batch']);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata["msg"],
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future<void> voidlog(
    String username,
    String batch,
    String email,
    String roll_no,
    String password,
    String status,
  ) async {
    Map data = {
      "Username": username,
      "Batch": batch,
      "Email": email,
      "Roll": roll_no,
      "Password": password,
      "Status": status,
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_signup.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
        );
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

  String? coursename;
  String? batchname;

  TextEditingController usercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController useridcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController statuscontroller = TextEditingController();

  InputDecoration inputbox = InputDecoration(
    hintText: "ENTER FULL NAME",
    labelText: "Full Name ",
    labelStyle: const TextStyle(color: Colors.black),
    fillColor: P.fromfillcolor,
    filled: true,
    prefixIcon: const Icon(Icons.person_outline_rounded),
    prefixIconColor: Colors.black,
    contentPadding: const EdgeInsets.only(left: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black,
        width: 2,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 5, 127, 192),
        width: 2,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: P.secondtheamecolor,
          appBar: AppBar(
            backgroundColor: P.appbar2,
            automaticallyImplyLeading: false,
            title: Text(
              "Signup Here !",
              style: TextStyle(
                color: P.textcolor,
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: fromkey,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 160, 151, 148),
                      radius: 80,
                      child: Image(
                        image: AssetImage(
                          "Assets/images/sighnupus.png",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 36, right: 36),
                    child: TextFormField(
                      controller: usercontroller,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field required";
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: inputbox,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        hintText: 'Chose Your Course....',
                        labelText: 'SELECT COURSE',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.school_outlined),
                        fillColor: P.fromfillcolor,
                        filled: true,
                        prefixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                      value: coursename,
                      items: courselist.map(
                        (String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        int index = courselist.indexOf(value!);
                        showDialog(
                            context: context,
                            builder: (context) => LoadingDialog(),
                            barrierDismissible: false);
                        getbatch(int.parse(courseidlist[index]))
                            .whenComplete(() {
                          Navigator.pop(context);
                          setState(() {
                            coursename = value.toString();
                          });
                        });
                        print(courseidlist[index]);
                      },
                      validator: (value) =>
                          value == null ? 'Field required' : null,
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_drop_down_circle_outlined,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Chose Your Batch....',
                        labelText: 'SELECT BATCH',
                        labelStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.school_outlined),
                        fillColor: P.fromfillcolor,
                        filled: true,
                        prefixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                      value: batchlist.contains(batchname) ? batchname : null,
                      items: batchlist.map(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                      onChanged: (value) {
                        setState(() {
                          batchname = value.toString();
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Field required' : null,
                      icon: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(Icons.arrow_drop_down_circle_outlined,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Cannot left Blank!';
                        } else if (!RegExp(r'[^0-9]+[a-zA-Z0-9]+@+gmail+\.+com')
                            .hasMatch(value)) {
                          return 'Please enter Valide email id';
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "ENTER EMAIL ID",
                        labelText: "Email Id ",
                        labelStyle: const TextStyle(color: Colors.black),
                        fillColor: P.fromfillcolor,
                        filled: true,
                        prefixIcon: const Icon(Icons.mail_outline_rounded),
                        prefixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      controller: useridcontroller,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "field required";
                        } else {
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: "Enter User Id/Roll No",
                        labelText: "User Id/Roll No.",
                        labelStyle: const TextStyle(color: Colors.black),
                        fillColor: P.fromfillcolor,
                        filled: true,
                        prefixIcon: const Icon(Icons.app_registration_outlined),
                        prefixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      controller: passwordcontroller,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: type,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'field required';
                        }
                        if (value.trim().length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onChanged: (value) => _password = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        fillColor: P.fromfillcolor,
                        filled: true,
                        hintText: "CREATE PASSWORD",
                        labelText: "Create Password ",
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                        suffixIcon: TextButton(
                          child: type
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            setState(
                              () {
                                type = !type;
                              },
                            );
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: typ,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'field required';
                        }
                        if (value != _password) {
                          return 'Confimation password does not match';
                        }
                        return null;
                      },
                      onChanged: (value) => _confirmPassword = value,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        fillColor: P.fromfillcolor,
                        filled: true,
                        hintText: "CONFIRM PASSWORD",
                        labelText: "Confirm Password ",
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outlined,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                        suffixIcon: TextButton(
                          child: typ
                              ? const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black,
                                )
                              : const Icon(
                                  Icons.visibility,
                                  color: Colors.black,
                                ),
                          onPressed: () {
                            setState(
                              () {
                                typ = !typ;
                              },
                            );
                          },
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    height: 50,
                    width: 160,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: P.appbar2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (fromkey.currentState!.validate()) {
                          voidlog(
                            usercontroller.text,
                            batchname.toString(),
                            emailcontroller.text,
                            useridcontroller.text,
                            passwordcontroller.text,
                            "0" + statuscontroller.text,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please Enter all",
                          );
                        }
                      },
                      label: AutoSizeText(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          color: P.textcolor,
                        ),
                        maxLines: 1,
                      ),
                      icon: Icon(
                        Icons.check_circle_outlined,
                        size: 20,
                        color: P.textcolor,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Return To',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'login',
                          style: TextStyle(
                            fontSize: 18,
                            color: P.textcolor2,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
