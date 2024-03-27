// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:canteen_cell/models/user.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:canteen_cell/pages/Newupdates.dart';
import 'package:canteen_cell/pages/balance.dart';
import 'package:canteen_cell/pages/cancel.dart';
import 'package:canteen_cell/pages/UserSelection.dart';
import 'package:canteen_cell/pages/studenthistory.dart';
import 'package:canteen_cell/pages/token.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:canteen_cell/pages/dialog/loading.dart';
import 'package:canteen_cell/pages/order.dart';
import 'package:canteen_cell/pages/profile.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Myapp extends StatefulWidget {
  // const Myapp(User user, {super.key});
  User user;
  Myapp(this.user);

  @override
  State<Myapp> createState() => _MyappState(user);
}

class _MyappState extends State<Myapp> {
  User user;
  _MyappState(this.user);
  double _rating = 0;
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  TextEditingController t1 = TextEditingController();
  GlobalKey<FormState> fromkey = GlobalKey();
  String timechange = "00:00:00";

  String getEmojiFromRating(double rating) {
    if (rating >= 4.5) {
      return '😍';
    } else if (rating >= 3.5) {
      return '😃';
    } else if (rating >= 2.5) {
      return '🙂';
    } else if (rating >= 1.5) {
      return '😐';
    } else {
      return '🙁';
    }
  }

  // List imageList = [
  //   {"id": 1, "image_path": 'Assets/images/img1.jpg'},
  //   {"id": 2, "image_path": 'Assets/images/img2.jpg'},
  //   {"id": 3, "image_path": 'Assets/images/img3.jpg'},
  //   {"id": 4, "image_path": 'Assets/images/img4.png'},
  //   {"id": 5, "image_path": 'Assets/images/img5.png'}
  // ];

  Future<void> voidfeedback(String feedback, String rating) async {
    Map data = {"Roll": user.Roll, "Feedback": feedback, "Ratting": rating};
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog();
      },
    );
    try {
      var response = await http.post(
        Uri.parse("${MyUrl.fullurl}student_feedback.php"),
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

  Future fetchtime() async {
    try {
      var response = await http.get(
        Uri.parse("${MyUrl.fullurl}time.php"),
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        setState(() {
          timechange = jsondata['data'][0]['time'];
        });
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
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: P.textcolor,
            ),
            backgroundColor: P.appbar2,
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
                Flexible(
                  child: AutoSizeText(
                    user.Username,
                    style: TextStyle(
                      fontSize: 18,
                      color: P.textcolor,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                SizedBox(
                  height: 200,
                  child: UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: P.appbar2,
                    ),
                    accountName: AutoSizeText(
                      user.Username,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    accountEmail: Text(
                      user.Email,
                      style: const TextStyle(fontSize: 15),
                    ),
                    currentAccountPictureSize: const Size(130, 130),
                    currentAccountPicture: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                showFullImageDialog();
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: P.fromfillcolor,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 25,
                  ),
                  title: Text(
                    "Profile",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profile(user),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.purple,
                    size: 25,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Myapp(user),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(
                //     Icons.download_for_offline_rounded,
                //     color: Colors.redAccent,
                //     size: 25,
                //   ),
                //   title: Text(
                //     'Update',
                //     style: TextStyle(
                //       fontSize: 17,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Newupdates(),
                //       ),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(
                    Icons.feedback,
                    color: Colors.green,
                    size: 25,
                  ),
                  title: AutoSizeText(
                    "Feedback & Rate Us",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                  ),
                  onTap: () {
                    showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, internalstate) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              content: SingleChildScrollView(
                                child: Form(
                                  key: fromkey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          "Rating  $_rating",
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      RatingBar.builder(
                                        initialRating: _rating,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          size: 3,
                                          color: Colors.amber,
                                        ),
                                        updateOnDrag: true,
                                        onRatingUpdate: (rating) {
                                          internalstate(
                                            () {
                                              _rating = rating;
                                            },
                                          );
                                        },
                                      ),
                                      SizedBox(height: 17),
                                      Text(
                                        getEmojiFromRating(_rating),
                                        style: const TextStyle(fontSize: 40),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 30, left: 25, right: 25),
                                        child: TextFormField(
                                          controller: t1,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Can't be blank";
                                            } else {
                                              return null;
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 5,
                                          maxLength: 500,
                                          decoration: InputDecoration(
                                            hintText: 'Write Something',
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2,
                                              ),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 100,
                                        margin:
                                            const EdgeInsets.only(bottom: 15),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: P.appbar2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                20,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (fromkey.currentState!
                                                .validate()) {
                                              voidfeedback(
                                                t1.text,
                                                _rating.toString(),
                                              );
                                              t1.text = " ";
                                              // _rating.text = "";
                                              Navigator.pop(context);
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: "Fill details",
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Submit',
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
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 25,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          title: Row(
                            children: const [
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
                          content: const Text(
                            'Are You Sure Want to Logout?',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                var prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => logins(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: const Text(
                                'Ok',
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
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
                child: GridView(
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
                              builder: (context) => Studentbalance(user),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets/images/rupee.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "Wallets",
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
                          fetchtime().whenComplete(
                            () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => order(
                                    user,
                                    timechange,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets/images/bento.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "Order Meal",
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
                              builder: (context) => token(user),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets/images/qrcode.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "Generate Token",
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
                          fetchtime().whenComplete(
                            () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      cancel(user, timechange),
                                ),
                              );
                            },
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets/images/cancel.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "Cancel Meal",
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
                              builder: (context) => studenthistory(user),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets/images/clock.png",
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            AutoSizeText(
                              "Order History",
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
