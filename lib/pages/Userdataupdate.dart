// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class Userdataupdate extends StatefulWidget {
  // const Userdataupdate(
  //     String namepass, String batchpass, String emailpass, String rollpass,
  //     {super.key});
  String imagepass, namepass, batchpass, emailpass, rollpass;
  Userdataupdate(this.imagepass, this.namepass, this.batchpass, this.emailpass,
      this.rollpass);

  @override
  State<Userdataupdate> createState() =>
      _UserdataupdateState(imagepass, namepass, batchpass, emailpass, rollpass);
}

class _UserdataupdateState extends State<Userdataupdate> {
  String imagepass, namepass, batchpass, emailpass, rollpass;
  _UserdataupdateState(this.imagepass, this.namepass, this.batchpass,
      this.emailpass, this.rollpass);
  GlobalKey<FormState> fromkey = GlobalKey();
  bool edittype = false;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    unamecontroller.text = namepass.toUpperCase();
    batchcontroller.text = batchpass.toUpperCase();
    emailcontroller.text = emailpass;
    rolcontroller.text = rollpass;
    setState(() {});
  }

  TextEditingController passcontroller = TextEditingController();
  TextEditingController unamecontroller = TextEditingController();
  TextEditingController batchcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController rolcontroller = TextEditingController();

  Future updatedata(
      String name, String email, String batch, String roll) async {
    Map data = {
      "name": name,
      "email": email,
      "batch": batch,
      "roll": roll,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "user_profile_update.php"),
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
          backgroundColor: P.secondtheamecolor,
          appBar: AppBar(
            backgroundColor: P.appbar2,
            iconTheme: IconThemeData(
              color: P.textcolor,
            ),
            title: Text(
              "User Profile",
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
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showFullImageDialog();
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: MyUrl.fullurl + MyUrl.imageurl + imagepass,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        imageBuilder: (context, imageProvider) {
                          return Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Form(
                  key: fromkey,
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, bottom: 30),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                "Personal Details ::".toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    edittype = !edittype;
                                  });
                                },
                                icon: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      Color.fromARGB(255, 207, 196, 162),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 36, right: 36),
                          child: TextFormField(
                            enabled: edittype,
                            controller: unamecontroller,
                            style: TextStyle(
                              color: P.textcolor2,
                            ),
                            decoration: InputDecoration(
                              fillColor: P.fromfillcolor,
                              filled: true,
                              labelText: "Name",
                              enabled: false,
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Color.fromARGB(255, 2, 2, 2),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 36, right: 36),
                          child: TextFormField(
                            enabled: edittype,
                            controller: batchcontroller,
                            style: TextStyle(
                              color: P.textcolor2,
                            ),
                            decoration: InputDecoration(
                              fillColor: P.fromfillcolor,
                              filled: true,
                              label: const Text(
                                "Batch",
                              ),
                              enabled: false,
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(
                                Icons.school,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 15, left: 36, right: 36),
                          child: TextFormField(
                            enabled: edittype,
                            controller: emailcontroller,
                            style: TextStyle(
                              color: P.textcolor2,
                            ),
                            decoration: InputDecoration(
                              fillColor: P.fromfillcolor,
                              filled: true,
                              label: const Text(
                                "Email",
                              ),
                              enabled: false,
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
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
                          margin: const EdgeInsets.only(
                              top: 15, left: 36, right: 36),
                          child: TextFormField(
                            controller: rolcontroller,
                            style: TextStyle(
                              color: P.textcolor2,
                            ),
                            decoration: InputDecoration(
                              fillColor: P.fromfillcolor,
                              filled: true,
                              label: const Text(
                                " User-Id ",
                              ),
                              enabled: false,
                              labelStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              prefixIcon: const Icon(
                                Icons.app_registration,
                                color: Color.fromARGB(255, 2, 2, 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 140,
                  child: Visibility(
                    visible: edittype,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (fromkey.currentState!.validate()) {
                          updatedata(
                            unamecontroller.text,
                            emailcontroller.text,
                            batchcontroller.text,
                            rolcontroller.text,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Field All data ',
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(
                        Icons.save_as_outlined,
                        size: 30,
                      ),
                      label: AutoSizeText(
                        'Update'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
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

  void showFullImageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 150),
              width: 400,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: CachedNetworkImage(
                imageUrl: MyUrl.fullurl + MyUrl.imageurl + imagepass,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) {
                  return Padding(
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
