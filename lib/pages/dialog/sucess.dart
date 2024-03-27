import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class sucessdialog extends StatelessWidget {
  const sucessdialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(10),
            height: 1000,
            width: 1000,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'Assets/lotti/loading2.json',
                  height: 400,
                  width: 500,
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                // const Text(
                //   "Loading....",
                //   style: TextStyle(
                //     fontSize: 10,
                //     color: Colors.white,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
