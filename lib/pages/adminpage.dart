// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, use_build_context_synchronously, prefer_interpolation_to_compose_strings, camel_case_types, use_key_in_widget_constructors, must_be_immutable, no_logic_in_create_state

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/models/admin.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Addsuperuser.dart';
import 'package:canteen_cell/pages/Addteacher.dart';
import 'package:canteen_cell/pages/Adminacourse.dart';
import 'package:canteen_cell/pages/Adminaddmeal.dart';
import 'package:canteen_cell/pages/Adminholidays.dart';
import 'package:canteen_cell/pages/Adminorder.dart';
import 'package:canteen_cell/pages/Adminsettings.dart';
import 'package:canteen_cell/pages/Userstaffbalance.dart';
import 'package:canteen_cell/pages/Userstafflist.dart';
import 'package:canteen_cell/pages/adminfeedback.dart';
import 'package:canteen_cell/pages/adminlog.dart';
import 'package:canteen_cell/pages/adminprofile.dart';
import 'package:canteen_cell/pages/adminscanqr.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/requestslist.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class adminpage extends StatefulWidget {
  // const adminpage({super.key});
  Admin admin;
  adminpage(this.admin);

  @override
  State<adminpage> createState() => _adminpageState(admin);
}

class _adminpageState extends State<adminpage> {
  Admin admin;
  _adminpageState(this.admin);

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  List<String> adholidaylist = [];

  List imageList = [
    {"id": 1, "image_path": 'Assets/images/admimage1.png'},
    {"id": 2, "image_path": 'Assets/images/im3.jpeg'},
    {"id": 3, "image_path": 'Assets/images/admimage3.jpg'},
    {"id": 4, "image_path": 'Assets/images/img4.png'},
    {"id": 5, "image_path": 'Assets/images/img5.png'},
  ];

  Future adminholidays() async {
    try {
      var response = await http.post(
        Uri.parse(
          MyUrl.fullurl + "student_holidays.php",
        ),
      );
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "true") {
        adholidaylist.clear();
        for (int i = 0; i < jsondata["data"].length; i++) {
          adholidaylist.add(
            jsondata['data'][i]['Dates'],
          );
        }
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

  late StreamSubscription<ConnectivityResult> subscription;
  String connectionStatus = 'Unknown';

  startMonitoringConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        if (result == ConnectivityResult.none) {
          connectionStatus = 'No Internet Connection';
          Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.wifi) {
          connectionStatus = 'Connected to Wi-Fi';
          Fluttertoast.showToast(msg: connectionStatus);
        } else if (result == ConnectivityResult.mobile) {
          connectionStatus = 'Connected to Mobile Data';
          Fluttertoast.showToast(msg: connectionStatus);
        }
      });
    });
    return connectionStatus;
  }

  void stopMonitoringConnectivity() {
    subscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      startMonitoringConnectivity();
    });
    usertype = admin.usertype;
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  late int usertype;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Row(
            children: [
              AutoSizeText(
                'Hello, ',
                style: TextStyle(
                  fontSize: 20,
                  color: P.textcolor,
                ),
                maxLines: 1,
              ),
              AutoSizeText(
                admin.name,
                style: TextStyle(
                  fontSize: 18,
                  color: P.textcolor,
                ),
                maxLines: 1,
              ),
            ],
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              Visibility(
                visible: usertype == 2 ? true : false,
                child: const Text(
                  "SUPER-USER",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Visibility(
                visible: usertype == 1 ? true : false,
                child: const Text(
                  "ADMIN",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Visibility(
                visible: usertype == 3 ? true : false,
                child: const Text(
                  "SCAN USER",
                  textScaleFactor: 1.5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: 240,
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: P.appbar2,
                  ),
                  accountName: Text(
                    admin.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  accountEmail: AutoSizeText(
                    admin.email,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    maxLines: 1,
                  ),
                  currentAccountPictureSize: Size(
                    120,
                    120,
                  ),
                  currentAccountPicture: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      showFullImageDialog();
                    },
                    child: CircleAvatar(
                      radius: 62,
                      backgroundColor: P.fromfillcolor,
                      child: CachedNetworkImage(
                        imageUrl:
                            MyUrl.fullurl + MyUrl.adminimageurl + admin.image,
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
              ),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 23,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminprofile(admin),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 23,
                ),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => adminpage(admin),
                    ),
                  );
                },
              ),
              Visibility(
                visible: usertype == 1 ? true : false,
                child: ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 23,
                  ),
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Adminsettings(admin),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: usertype == 1 ? true : false,
                child: ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 23,
                  ),
                  title: Text(
                    "Edit Course",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Adminacourse(),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: usertype == 1 ? true : false,
                child: ListTile(
                  leading: const Icon(
                    Icons.person_add,
                    color: Colors.black,
                    size: 23,
                  ),
                  title: const Text(
                    "Add Staff",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Addteacher(),
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: usertype == 1 ? true : false,
                child: ListTile(
                  leading: Icon(
                    Icons.person_add_alt_1,
                    color: Colors.black,
                    size: 23,
                  ),
                  title: Text(
                    "Add Super-User",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Addsuperuser(),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.black,
                  size: 23,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        title: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(
                                Icons.logout,
                                size: 30,
                                color: Colors.redAccent,
                              ),
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        content: Text(
                          'Are You Sure Want to Logout?',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              var prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Admlog(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: Text(
                              'Ok',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "Assets/images/admimage1.png",
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: usertype == 3
                  ? GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / .7,
                      ),
                      children: [
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 10,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Adminscanqr(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admscanqr.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Scan QR",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Adminorder(
                                    admin,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admorder.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Orders",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1 / .7,
                      ),
                      children: [
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 10,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Requestslist(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admrequests.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "User Requests",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Adminscanqr(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admscanqr.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Scan QR",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 10,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Adminaddmeal(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/Add.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Add Meal",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Adminorder(admin),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admorder.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Orders",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 10,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Userstafflist(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admstudentslist.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "All Users",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Userstaffbalance(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admbalance.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Add Balance",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 30,
                            right: 10,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adminfeedback(),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                LottieBuilder.asset(
                                  'Assets/lotti/admfeedback.json',
                                  height: 65,
                                  repeat: false,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Feedbacks",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                        Card(
                          shadowColor: Color.fromARGB(255, 49, 78, 194),
                          margin: EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 10,
                          ),
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) {
                                    return LoadingDialog();
                                  });
                              adminholidays().whenComplete(
                                () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Adminholidays(
                                        adholidaylist,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  size: 60,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                AutoSizeText(
                                  "Add Holiday",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
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
