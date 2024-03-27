// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_print, use_build_context_synchronously, prefer_interpolation_to_compose_strings, non_constant_identifier_names, no_logic_in_create_state, camel_case_types, use_key_in_widget_constructors
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:canteen_cell/pages/Studentprofilepass.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/userdashboard.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canteen_cell/models/colorclass.dart';

class profile extends StatefulWidget {
  // const profile({super.key});
  User user;
  profile(this.user);

  @override
  State<profile> createState() => _profileState(user);
}

class _profileState extends State<profile> {
  GlobalKey<FormState> fromkey = GlobalKey();
  bool edittype = false;
  User user;
  _profileState(this.user);

  TextEditingController passcontroller = TextEditingController();
  TextEditingController unamecontroller = TextEditingController();
  TextEditingController batchcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController rolcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    unamecontroller.text = user.Username;
    batchcontroller.text = user.Batch;
    emailcontroller.text = user.Email;
    rolcontroller.text = user.Roll;
    setState(() {});
  }

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
        prefs = await SharedPreferences.getInstance();
        setState(() {
          prefs.setString("username", jsondata['data']["Username"].toString());
          // prefs.setString("batch", jsondata['data']["Batch"].toString());
          prefs.setString("email", jsondata['data']["Email"].toString());
          prefs.setString("roll", jsondata["data"]["Roll"].toString());
          user.Username = unamecontroller.text;
          user.Batch = batchcontroller.text;
          user.Email = emailcontroller.text;
          user.Roll = rolcontroller.text;
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

  Future createprofile(File Uphoto, String roll) async {
    showDialog(
        context: context,
        builder: (context) => const LoadingDialog(),
        barrierDismissible: false);
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(MyUrl.fullurl + "image_update.php"),
      );
      request.files.add(
        http.MultipartFile.fromBytes('Image', Uphoto.readAsBytesSync(),
            filename: Uphoto.path.split("/").last),
      );
      request.fields['Roll'] = roll;
      var response = await request.send();
      var responded = await http.Response.fromStream(response);
      var jsondata = jsonDecode(responded.body);
      if (jsondata['status'] == 'true') {
        var prefs = await SharedPreferences.getInstance();
        user.Image = jsondata['imgtitle'];
        prefs.setString("image", user.Image);
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

  Future<bool> _onWillPop() async {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Myapp(user),
      ),
    );
    return false;
  }

  Future<void> showImageOptions() async {
    return showModalBottomSheet<void>(
      backgroundColor: P.secondtheamecolor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.remove_red_eye_rounded,
              ),
              title: Text(
                'View Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.of(context).pop();
                showFullImageDialog();
              },
            ),
            Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: Colors.blue,
                size: 25,
              ),
              title: Text(
                'Choose from Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                pickImage(ImageSource.gallery).whenComplete(
                  () {
                    if (pickedImage != null) {
                      print(user.Roll);
                      createprofile(pickedImage!, user.Roll);
                    }
                  },
                );
              },
            ),
            Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.black,
                size: 25,
              ),
              title: Text(
                'Take a Photo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pop(context);
                pickImage(ImageSource.camera).whenComplete(
                  () {
                    if (pickedImage != null) {
                      createprofile(pickedImage!, user.Roll);
                    }
                  },
                );
              },
            ),
            Divider(height: 1, color: Color.fromARGB(255, 58, 58, 58)),
            ListTile(
              leading: const Icon(
                Icons.remove_circle,
                color: Colors.red,
                size: 25,
              ),
              title: Text(
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
      onWillPop: () {
        return _onWillPop();
      },
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            backgroundColor: P.theamecolor,
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: P.textcolor,
              ),
              backgroundColor: P.appbar2,
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
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: 190,
                      width: 190,
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
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
                                      child: CachedNetworkImage(
                                        imageUrl: MyUrl.fullurl +
                                            MyUrl.imageurl +
                                            user.Image,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
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
                          ),
                          Positioned(
                            bottom: 10,
                            left: 90,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(
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
                  Form(
                    key: fromkey,
                    child: Container(
                      padding: EdgeInsets.only(top: 20, bottom: 30),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: P.secondtheamecolor,
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
                                padding: EdgeInsets.only(left: 30),
                                child: Text(
                                  "Personal Details".toUpperCase(),
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
                            margin:
                                EdgeInsets.only(top: 15, left: 36, right: 36),
                            child: TextFormField(
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              enabled: edittype,
                              controller: unamecontroller,
                              decoration: InputDecoration(
                                fillColor: P.fromfillcolor,
                                filled: true,
                                labelText: "Name",
                                enabled: false,
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
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
                            margin:
                                EdgeInsets.only(top: 15, left: 36, right: 36),
                            child: TextFormField(
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              controller: batchcontroller,
                              decoration: InputDecoration(
                                fillColor: P.fromfillcolor,
                                filled: true,
                                label: Text(
                                  "Batch",
                                ),
                                enabled: false,
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.school,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, left: 36, right: 36),
                            child: TextFormField(
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              enabled: edittype,
                              controller: emailcontroller,
                              decoration: InputDecoration(
                                fillColor: P.fromfillcolor,
                                filled: true,
                                label: Text(
                                  "Email",
                                ),
                                enabled: false,
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color.fromARGB(255, 2, 2, 2),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 15, left: 36, right: 36),
                            child: TextFormField(
                              controller: rolcontroller,
                              style: TextStyle(
                                color: P.textcolor2,
                              ),
                              decoration: InputDecoration(
                                fillColor: P.fromfillcolor,
                                filled: true,
                                label: Text(
                                  " User-Id ",
                                ),
                                enabled: false,
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                prefixIcon: Icon(
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
                    height: 10,
                  ),
                  Visibility(
                    visible: edittype,
                    child: SizedBox(
                      height: 50,
                      width: 140,
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
                              msg: 'Fill All data',
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: P.appbar2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          Icons.save_as_outlined,
                          size: 30,
                          color: P.textcolor,
                        ),
                        label: AutoSizeText(
                          'Update',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: P.textcolor,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 177, 19, 8),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Studentprofilepass(user),
                        ),
                      );
                    },
                    child: Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                imageUrl: MyUrl.fullurl + MyUrl.imageurl + user.Image,
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
