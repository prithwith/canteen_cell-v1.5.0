// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_constructors, deprecated_member_use

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Addsuperuser extends StatefulWidget {
  const Addsuperuser({super.key});

  @override
  State<Addsuperuser> createState() => _AddsuperuserState();
}

class _AddsuperuserState extends State<Addsuperuser> {
  GlobalKey<FormState> fromkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  bool typ = true;
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';

  TextEditingController Namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

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

  Future<void> voidlog(
    String name,
    String email,
    String password,
  ) async {
    Map data = {
      "name": name,
      "email": email,
      "password": password,
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
        Uri.parse(MyUrl.fullurl + "add_superuser.php"),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: P.theamecolor,
          appBar: AppBar(
            backgroundColor: P.appbar2,
            iconTheme: IconThemeData(
              color: P.textcolor,
            ),
            title: Text(
              "Add Superuser",
              style: TextStyle(
                fontSize: 20,
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
                    margin: const EdgeInsets.only(top: 50, left: 36, right: 36),
                    child: TextFormField(
                      controller: Namecontroller,
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
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 5, 127, 192),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 50,
                    width: 150,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: P.appbar,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        if (fromkey.currentState!.validate()) {
                          voidlog(
                            Namecontroller.text,
                            emailcontroller.text,
                            passwordcontroller.text,
                          ).whenComplete(
                            () => Navigator.pop(context),
                          );
                          Namecontroller.text = "";
                          emailcontroller.text = "";
                          passwordcontroller.text = "";
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
