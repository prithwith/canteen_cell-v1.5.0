// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/userdashboard.dart';
import 'package:canteen_cell/pages/UserSelection.dart';
import 'package:canteen_cell/pages/splash.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Teacherlogin extends StatefulWidget {
  const Teacherlogin({super.key});

  @override
  State<Teacherlogin> createState() => _TeacherloginState();
}

class _TeacherloginState extends State<Teacherlogin> {
  GlobalKey<FormState> fromkey = GlobalKey();
  bool isvisible = false;
  bool type = true;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  InputDecoration style = InputDecoration(
    labelText: 'User ID',
    hintText: 'Enter User ID',
    labelStyle: const TextStyle(
      color: Color.fromARGB(255, 8, 44, 161),
    ),
    prefixIcon: const Icon(
      Icons.person_rounded,
      color: Color.fromARGB(255, 8, 44, 161),
    ),
    prefixIconColor: P.appbar2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 8, 44, 161),
        width: 2,
      ),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 8, 44, 161),
        width: 1,
      ),
    ),
  );

  Future<void> voidlog(String roll_no, String password) async {
    Map data = {"Roll": roll_no, "Password": password};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse("${MyUrl.fullurl}student_login.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        Navigator.pop(context);
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool(SplashState.KEYLOGIN, true);
        prefs.setBool(SplashState.ADMINKEYLOGIN, false);
        prefs.setString("username", jsondata["Username"].toString());
        prefs.setString("batch", jsondata["Batch"].toString());
        prefs.setString("email", jsondata["Email"].toString());
        prefs.setString("roll", jsondata["Roll"].toString());
        prefs.setString("image", jsondata["Image"].toString());
        prefs.setString("balance", jsondata["Balance"].toString());
        prefs.setString("password", jsondata["Password"].toString());

        User user = User(
          jsondata["Username"].toString(),
          jsondata["Batch"].toString(),
          jsondata["Email"].toString(),
          jsondata["Roll"].toString(),
          jsondata["Image"].toString(),
          jsondata["Balance"].toString(),
          jsondata["Password"].toString(),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Myapp(user),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 9, 10, 79),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: fromkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 20,
                        left: 10,
                        right: 20,
                      ),
                      height: 50,
                      child: Row(
                        children: [
                          AutoSizeText(
                            "Staff Login",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const logins(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.home,
                              size: 35,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Image.asset(
                      "Assets/images/apicon.png",
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      "CCLMS Canteen",
                      style: GoogleFonts.lobster(
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Can't left blank";
                              } else {
                                return null;
                              }
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: style,
                            controller: t1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: type,
                            obscuringCharacter: '\u2022',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Can\'t left blank';
                              }
                              if (value.trim().length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: t2,
                            decoration: InputDecoration(
                              hintText: "Password",
                              labelText: "Enter Password ",
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 8, 44, 161),
                              ),
                              prefixIcon: const Icon(
                                Icons.key,
                                color: Color.fromARGB(255, 8, 44, 161),
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 8, 44, 161),
                                  width: 2,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 8, 44, 161),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 130,
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: P.appbar2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              onPressed: () async {
                                if (fromkey.currentState!.validate()) {
                                  voidlog(
                                    "T" + t1.text,
                                    t2.text,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Enter Valid Email id and Password",
                                  );
                                }
                              },
                              label: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 19,
                                  color: P.textcolor,
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: P.textcolor,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
