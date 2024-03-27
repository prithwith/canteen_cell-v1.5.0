// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/pages/adminforgrtpass.dart';
import 'package:canteen_cell/pages/adminpage.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class adminprofile extends StatefulWidget {
  // const adminprofile({super.key});
  Admin admin;
  adminprofile(this.admin);

  @override
  State<adminprofile> createState() => _adminprofileState(admin);
}

class _adminprofileState extends State<adminprofile> {
  bool edittype = false;

  Admin admin;
  _adminprofileState(this.admin);

  @override
  void initState() {
    super.initState();
    idcontroller.text = admin.id;
    namecontroller.text = admin.name;
    emailcontroller.text = admin.email;
    setState(() {});
  }

  GlobalKey<FormState> fromkey = GlobalKey();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController idcontroller = TextEditingController();

  Future updatedata(String id, String name, String email) async {
    Map data = {
      "id": admin.id,
      "name": name,
      "email": email,
    };
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_dataupdate.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata["status"] == true) {
        prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString("aname", jsondata["name"].toString());
          prefs.setString("aemail", jsondata["email"].toString());
          admin.name = namecontroller.text;
          admin.email = emailcontroller.text;
        });
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

  File? pickedImage;
  late SharedPreferences prefs;
  Future pickImage(ImageSource imageType) async {
    try {
      final photo =
          await ImagePicker().pickImage(source: imageType, imageQuality: 50);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future updateimage(File Aphoto, String id) async {
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(MyUrl.fullurl + "admin_image.php"),
      );
      request.files.add(
        http.MultipartFile.fromBytes('image', Aphoto.readAsBytesSync(),
            filename: Aphoto.path.split("/").last),
      );
      request.fields['id'] = id;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var prefs = await SharedPreferences.getInstance();
        admin.image = jsondata['imgtitle'];
        prefs.setString("aimage", jsondata['imgtitle']);

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

  Future<void> showImageOptions() async {
    return showModalBottomSheet<void>(
      backgroundColor: P.secondtheamecolor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.remove_red_eye_rounded,
              ),
              title: const Text(
                'View Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showFullImageDialog();
              },
            ),
            const Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Colors.blue,
                size: 25,
              ),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                pickImage(ImageSource.gallery).whenComplete(
                  () {
                    if (pickedImage != null) {
                      updateimage(pickedImage!, admin.id);
                    }
                  },
                );
              },
            ),
            const Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.black,
                size: 25,
              ),
              title: const Text(
                'Take a Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                pickImage(ImageSource.camera).whenComplete(
                  () {
                    if (pickedImage != null) {
                      updateimage(pickedImage!, admin.id);
                    }
                  },
                );
              },
            ),
            const Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 25,
              ),
              title: const Text(
                'Cancel',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => adminpage(admin),
          ),
        );
        return false;
      },
      child: SafeArea(
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
                "My Profile",
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
                    Center(
                      child: Container(
                        height: 190,
                        width: 190,
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 15,
                        ),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showImageOptions();
                              },
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: Colors.white,
                                child: pickedImage != null
                                    ? ClipOval(
                                        child: Image.file(
                                          pickedImage!,
                                          height: 135,
                                          width: 135,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipOval(
                                        child: CircleAvatar(
                                          radius: 68,
                                          backgroundColor: Colors.grey,
                                          backgroundImage: NetworkImage(
                                            MyUrl.fullurl +
                                                MyUrl.adminimageurl +
                                                admin.image,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 90,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showImageOptions();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        bottom: 50,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: P.secondtheamecolor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  "Personal Details ::".toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      edittype = !edittype;
                                    });
                                  },
                                  icon: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Color.fromARGB(255, 210, 178, 83),
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
                            margin: EdgeInsets.only(
                              top: 15,
                              left: 36,
                              right: 36,
                            ),
                            child: TextFormField(
                              controller: namecontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Can't be blank";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              enabled: edittype,
                              textCapitalization: TextCapitalization.words,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "NAME",
                                enabled: false,
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
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
                              controller: emailcontroller,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Cannot left Blank!';
                                } else if (!RegExp(
                                  r'[^0-9]+[a-zA-Z0-9]+@[a-zA-Z]{2,}[a-zA-Z0-9]+\.[a-zA-Z]{2,3}',
                                ).hasMatch(value)) {
                                  return 'Please enter Valide email id';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                              enabled: edittype,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                labelText: "EMAIL",
                                enabled: false,
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
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 180),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Admforgetpass(
                                admin,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Change Password ?',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(30),
                      height: 50,
                      width: 140,
                      child: Visibility(
                        visible: edittype,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (fromkey.currentState!.validate()) {
                              updatedata(
                                idcontroller.text,
                                namecontroller.text,
                                emailcontroller.text,
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
                          icon: const Icon(
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
                imageUrl: MyUrl.fullurl + MyUrl.adminimageurl + admin.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                imageBuilder: (context, imageProvider) {
                  return Padding(
                    padding: EdgeInsets.all(4),
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
