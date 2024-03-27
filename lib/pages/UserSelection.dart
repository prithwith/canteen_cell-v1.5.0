// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Teacherlogin.dart';
import 'package:canteen_cell/pages/adminlog.dart';
import 'package:canteen_cell/pages/login.dart';
import 'package:flutter/material.dart';

class logins extends StatefulWidget {
  const logins({super.key});

  @override
  State<logins> createState() => _logins();
}

class _logins extends State<logins> {
  List<bool> userchoices = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "Assets/images/apicon.png",
                  height: 100,
                  width: 100,
                ),
                Text(
                  "Select User Type",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: P.appbar2,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          userchoices[0] = !userchoices[0];
                          userchoices[1] = false;
                          userchoices[2] = false;
                          userchoices[3] = false;
                        });
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: userchoices[0]
                              ? Border.all(
                                  color: Colors.green,
                                  width: 3,
                                )
                              : Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(
                                -5.0,
                                -5.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Visibility(
                                visible: userchoices[0],
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.people,
                            ),
                            AutoSizeText(
                              "Admin",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: P.appbar2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userchoices[0] = false;
                          userchoices[1] = !userchoices[1];
                          userchoices[2] = false;
                          userchoices[3] = false;
                        });
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: userchoices[1]
                              ? Border.all(
                                  color: Colors.green,
                                  width: 3,
                                )
                              : Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(
                                -5.0,
                                -5.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Visibility(
                                visible: userchoices[1],
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.people,
                            ),
                            AutoSizeText(
                              "Super User",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: P.appbar2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          userchoices[0] = false;
                          userchoices[1] = false;
                          userchoices[2] = !userchoices[2];
                          userchoices[3] = false;
                        });
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: userchoices[2]
                              ? Border.all(
                                  color: Colors.green,
                                  width: 3,
                                )
                              : Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(
                                -5.0,
                                -5.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Visibility(
                                visible: userchoices[2],
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.people,
                            ),
                            AutoSizeText(
                              "Staff",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: P.appbar2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          userchoices[0] = false;
                          userchoices[1] = false;
                          userchoices[2] = false;
                          userchoices[3] = !userchoices[3];
                        });
                      },
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: EdgeInsets.all(
                          10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          color: Colors.white,
                          border: userchoices[3]
                              ? Border.all(
                                  color: Colors.green,
                                  width: 3,
                                )
                              : Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: const Offset(
                                -5.0,
                                -5.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Visibility(
                                visible: userchoices[3],
                                maintainSize: true,
                                maintainAnimation: true,
                                maintainState: true,
                                child: Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.people,
                            ),
                            AutoSizeText(
                              "Student",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: P.appbar2,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      backgroundColor: P.appbar2,
                    ),
                    onPressed: (userchoices[0] == false &&
                            userchoices[1] == false &&
                            userchoices[2] == false &&
                            userchoices[3] == false)
                        ? null
                        : () {
                            if (userchoices[0] || userchoices[1]) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Admlog(),
                                ),
                              );
                            } else if (userchoices[2]) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Teacherlogin(),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            }
                          },
                    child: Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 17,
                        color: P.textcolor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
