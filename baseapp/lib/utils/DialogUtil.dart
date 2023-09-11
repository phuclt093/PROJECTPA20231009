import 'package:baseapp/enums/ErrorCode.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DialogUtil {
  static Future<bool> fncShowLoadingScreen(BuildContext context, Color colorIconProgress, Color colorMessage) async {
    // Duration duration = const Duration(seconds: 2);
    var message = LocalizationUtil.translate("Loading...");

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AbsorbPointer(
            child: AlertDialog(
              backgroundColor: Colors.transparent,
              alignment: Alignment.center,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                      color: colorIconProgress),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Text(
                    message,
                    style: TextStyle(
                        color: colorMessage),
                  ),
                ],
              ),
            ),
          );
        });
    // await Future.delayed(duration);
    return true;
  }

  static Future<bool> hideLoadingScreen(BuildContext context) async {
    Navigator.of(context).pop();
    return true;
  }
}
