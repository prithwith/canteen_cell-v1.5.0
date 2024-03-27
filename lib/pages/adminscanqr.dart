// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, prefer_interpolation_to_compose_strings, prefer_const_constructors, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:canteen_cell/models/FullSdetails.dart';
import 'package:canteen_cell/utils/url1.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:canteen_cell/models/colorclass.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/material.dart';

class Adminscanqr extends StatefulWidget {
  const Adminscanqr({super.key});

  @override
  State<Adminscanqr> createState() => _AdminscanqrState();
}

class _AdminscanqrState extends State<Adminscanqr> {
  FlutterTts flutterTts = FlutterTts();
  Barcode? result;
  QRViewController? controller;
  bool isIconFontAvailable = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isScanning = true;
  Timer? scanTimer;
  List<FullSdetails> detailslist = [];

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 250.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          result = scanData;
          if (result != null && result!.code!.isNotEmpty) {
            qrpermission(result?.code);
            isScanning = false;
            // scanTimer = Timer(const Duration(seconds: 2), () {
            //   isScanning = true;
            // });
          }
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission'.toUpperCase())),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future Studentfulldetails() async {
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "student_scan_fulldetails.php"),
        body: {
          "Order_id": result!.code,
        },
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == "true") {
        detailslist.clear();
        for (int i = 0; i < jsondata['data'].length; i++) {
          FullSdetails fdetailslist = FullSdetails(
            jsondata['data'][i]['Username'],
            jsondata['data'][i]['Order_status'],
            jsondata['data'][i]['Roll'],
            jsondata['data'][i]['Order_id'],
            jsondata['data'][i]['Date'],
          );
          detailslist.add(fdetailslist);
        }
      } else {
        Fluttertoast.showToast(
          msg: jsondata['msg'],
        );
      }
      return detailslist;
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  Future qrpermission(dynamic parse) async {
    Map data = {'Order_id': parse};
    try {
      var response = await http.post(
        Uri.parse(MyUrl.fullurl + "admin_scan_qr.php"),
        body: data,
      );
      var jsondata = jsonDecode(response.body.toString());
      if (jsondata["status"] == true) {
        await flutterTts.speak('Thank You');

        List<FullSdetails> detailslist = await Studentfulldetails();
        // ignore: avoid_single_cascade_in_expression_statements
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          dismissOnTouchOutside: false,
          title: jsondata['msg'],
          desc: 'Student Details:',
          btnOkOnPress: () {
            setState(() {
              isScanning = true;
              result = null;
            });
            //Navigator.pop(context);
          },
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: detailslist.map(
                (details) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Order_status:'.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ' ${details.order_status}'.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: details.order_status == 'Confirmed'
                                    ? P.confirm
                                    : details.order_status == 'Redeemed'
                                        ? P.redeem
                                        : P.unknown,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Name : - '.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Text(
                              ' ${details.username}'.toUpperCase(),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'User-Id : -'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' ${details.roll}',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Order_id : -'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '# ${details.order_id}',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Date : -'.toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ' ${details.date}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        )..show();
      } else {
        // ignore: avoid_single_cascade_in_expression_statements
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          title: jsondata['msg'],
          dismissOnTouchOutside: false,
          titleTextStyle: TextStyle(
            color: Colors.red,
            fontSize: 18,
          ),
          btnOkOnPress: () {
            setState(() {
              isScanning = true;
              result = null;
            });
            //Navigator.pop(context);
          },
          desc: 'Try, Again with another QR',
          btnOkColor: Colors.red,
        )..show();

        await flutterTts.speak('Sorry ,Invalid QR');
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: P.secondtheamecolor,
        appBar: AppBar(
          backgroundColor: P.appbar2,
          iconTheme: IconThemeData(
            color: P.textcolor,
          ),
          title: Text(
            'Scan QR',
            style: TextStyle(
              fontSize: 20,
              color: P.textcolor,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: _buildQrView(context),
            ),
            Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.all(8),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.black,
                            child: TextButton(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  bool flashOn = snapshot.data ?? false;
                                  return Icon(
                                    flashOn
                                        ? Icons.flashlight_on_outlined
                                        : Icons.flashlight_off_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (result != null)
                      Column(
                        children: [
                          Text(
                            'Barcode Type: ${describeEnum(result!.format)}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          Text(
                            'ID : ${result!.code}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Scan QR-code'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
