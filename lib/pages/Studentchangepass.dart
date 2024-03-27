// ignore_for_file: must_be_immutable, unused_field, prefer_const_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/login.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

class Studentconfirmpass extends StatefulWidget {
  // const Studentconfirmpass(String userid, {super.key});
  String userid;
  Studentconfirmpass(this.userid);

  @override
  State<Studentconfirmpass> createState() => _StudentconfirmpassState(userid);
}

class _StudentconfirmpassState extends State<Studentconfirmpass> {
  String userid;
  _StudentconfirmpassState(this.userid);
  GlobalKey<FormState> fromkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  bool typ = true;
  String _password = '';
  String _confirmPassword = '';

  TextEditingController t2 = TextEditingController();

  Future updatepassword(String password) async {
    Map data = {
      "Roll": userid,
      "Password": password,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_change_password.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
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
            title: AutoSizeText(
              'Confirm Password',
              style: TextStyle(
                fontSize: 20,
                color: P.textcolor,
              ),
              maxLines: 1,
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Form(
              key: fromkey,
              child: Column(
                children: [
                  LottieBuilder.asset(
                    'Assets/lotti/admchangepassword.json',
                    height: 300,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      controller: t2,
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
                        hintText: "PASSWORD",
                        labelText: "Change Password".toUpperCase(),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
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
                        hintText: "PASSWORD",
                        labelText: "Re-entred ".toUpperCase(),
                        labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
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
                    margin: const EdgeInsets.symmetric(
                      vertical: 40,
                    ),
                    height: 53,
                    width: 220,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (fromkey.currentState!.validate()) {
                          updatepassword(
                            t2.text,
                          );
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                            msg: "Please Enter Password",
                          );
                        }
                      },
                      child: AutoSizeText(
                        'change password'.toUpperCase(),
                        style: TextStyle(fontSize: 19),
                        maxLines: 1,
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
