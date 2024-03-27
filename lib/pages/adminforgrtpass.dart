// ignore_for_file: deprecated_member_use, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Admchangepass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class Admforgetpass extends StatefulWidget {
  // const Admforgetpass({super.key});
  Admin admin;
  Admforgetpass(this.admin);

  @override
  State<Admforgetpass> createState() => _AdmforgetpassState(admin);
}

class _AdmforgetpassState extends State<Admforgetpass> {
  Admin admin;
  _AdmforgetpassState(this.admin);

  EmailOTP myauth = EmailOTP();
  bool isVisible = false;
  bool otpSent = false;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();
  TextEditingController t4 = TextEditingController();
  TextEditingController t5 = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  int otp = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailcontroller.text = admin.email;
  }

  void VisibleTextField() {
    setState(
      () {
        isVisible = !isVisible;
        otpSent = true;
      },
    );
  }

  Future Otpsend() async {
    Map data = {
      "email": admin.email,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_otp.php"),
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
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Email-Id Verification",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
                LottieBuilder.asset(
                  'Assets/lotti/admsentotp.json',
                  height: 200,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 15, left: 36, right: 36),
                  child: TextFormField(
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
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      fillColor: P.fromfillcolor,
                      filled: true,
                      labelText: "EMAIL",
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
                            VisibleTextField();
                            Otpsend();
                          },
                    icon: const Icon(
                      Icons.send,
                      size: 30,
                    ),
                    // ignore: prefer_const_constructors
                    label: AutoSizeText(
                      'Send OTP',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 3,
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
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
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 3, color: Colors.black),
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                              ),
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
                        // ignore: prefer_const_constructors
                        child: Text(
                          'Verify',
                          style: const TextStyle(fontSize: 20),
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
                                builder: (context) => Admchangepass(
                                  admin,
                                ),
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
    );
  }
}
