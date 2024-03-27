// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Studentchangepass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class Studentforgetpass extends StatefulWidget {
  const Studentforgetpass({super.key});

  @override
  State<Studentforgetpass> createState() => _StudentforgetpassState();
}

class _StudentforgetpassState extends State<Studentforgetpass> {
  GlobalKey<FormState> fromkey = GlobalKey();
  bool isVisible = false;
  bool otpSent = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  void VisibleTextField() {
    setState(
      () {
        isVisible = !isVisible;
        otpSent = true;
      },
    );
  }

  int otp = 0;

  Future Otpsend(String roll) async {
    Map data = {
      "roll": roll,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "forgot_password_otp.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == "true") {
        otp = jsondata['otp'];
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
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  late String userid;

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
              'Forget password',
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
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: LottieBuilder.asset(
                      'Assets/lotti/admsentotp.json',
                      height: 200,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                      left: 36,
                      right: 36,
                    ),
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Cannot left Blank!';
                        } else {
                          return null;
                        }
                      },
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: P.fromfillcolor,
                        filled: true,
                        hintText: 'Enter UserId'.toUpperCase(),
                        labelText: "Enter UserId",
                        labelStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(30),
                    height: 55,
                    width: 170,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),
                      onPressed: otpSent
                          ? null
                          : () {
                              userid = emailcontroller.text;
                              if (fromkey.currentState!.validate()) {
                                VisibleTextField();
                                Otpsend(emailcontroller.text);
                                // Navigator.pop(context);
                              } else {
                                Fluttertoast.showToast(
                                  msg: "Cannot left Blank!",
                                );
                              }
                            },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                      label: Text(
                        'Send'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: TextFormField(
                                controller: t1,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headline6,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: TextFormField(
                                controller: t2,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headline6,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: TextFormField(
                                controller: t3,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headline6,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: TextFormField(
                                controller: t4,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    FocusScope.of(context).nextFocus();
                                  } else if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 45,
                              width: 45,
                              child: TextFormField(
                                controller: t5,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    FocusScope.of(context).previousFocus();
                                  }
                                },
                                style: Theme.of(context).textTheme.headline6,
                                textAlign: TextAlign.center,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(1),
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 100),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const AutoSizeText(
                                "Don't Recived The Code?",
                                maxLines: 1,
                              ),
                              TextButton(
                                onPressed: () {
                                  Otpsend(emailcontroller.text);
                                },
                                child: const Text(
                                  'Resend',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: Text(
                            'verify'.toUpperCase(),
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            if (otp ==
                                int.parse(t1.text +
                                    t2.text +
                                    t3.text +
                                    t4.text +
                                    t5.text)) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Studentconfirmpass(
                                    userid,
                                  ),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("OTP is verified"),
                                ),
                              );
                              t1.text = " ";
                              t2.text = " ";
                              t3.text = " ";
                              t4.text = " ";
                              t5.text = " ";
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Invalid OTP"),
                                ),
                              );
                            }
                          },
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
    );
  }
}
