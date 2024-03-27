// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/pages/Studentprofilechangepass.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dialog/loading.dart';

class Studentprofilepass extends StatefulWidget {
  // const Studentprofilepass({super.key});
  User user;
  Studentprofilepass(this.user);

  @override
  State<Studentprofilepass> createState() => _StudentprofilepassState(user);
}

class _StudentprofilepassState extends State<Studentprofilepass> {
  User user;
  _StudentprofilepassState(this.user);

  GlobalKey<FormState> fromkey = GlobalKey();
  bool isVisible = false;
  bool otpSent = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailcontroller.text = user.Roll;
  }

  void VisibleTextField() {
    setState(
      () {
        isVisible = !isVisible;
        otpSent = true;
      },
    );
  }

  int otp = 0;

  Future Otpsend() async {
    Map data = {
      "roll": user.Roll,
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
              'Change Password',
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
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "User-ID Verification".toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: LottieBuilder.asset(
                      'Assets/lotti/studentprofilepass.json',
                      height: 100,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Cannot left Blank!';
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: P.fromfillcolor,
                        filled: true,
                        hintText: 'Enter User-id'.toUpperCase(),
                        labelText: "Enter User-id",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        contentPadding: const EdgeInsets.only(left: 10),
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
                    margin: EdgeInsets.only(right: 200, top: 5),
                    child: const Text(
                      'Default User-id',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(25),
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
                              VisibleTextField();
                              Otpsend();
                            },
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                      label: AutoSizeText(
                        'Send otp'.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                    ),
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
                                  Otpsend();
                                },
                                child: const Text(
                                  'Resend',
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          child: AutoSizeText(
                            'verify'.toUpperCase(),
                            style: const TextStyle(fontSize: 20),
                            maxLines: 1,
                          ),
                          onPressed: () async {
                            if (otp ==
                                int.parse(t1.text +
                                    t2.text +
                                    t3.text +
                                    t4.text +
                                    t5.text)) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Studentprofilecgahgepass(user),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
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
                                const SnackBar(
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
