import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:baseapp/models/menu_model.dart';
import '../data/img.dart';

// showSnackBar(String msg, BuildContext context) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(
//         msg,
//         textAlign: TextAlign.center,
//         style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
//       ),
//       duration: const Duration(milliseconds: 1000), //bydefault 4000 ms
//       backgroundColor: isDark! ? colors.tempdarkColor : colors.bgColor,
//       elevation: 1.0,
//     ),
//   );
// }

//prefrence string set using this function
setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

//prefrence string get using this function
Future<String?> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

//prefrence boolean set using this function
setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

//prefrence boolean get using this function
Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

setPrefrenceList(String key, String query) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? valueList = await getPrefrenceList(key);
  if (!valueList!.contains(query)) {
    if (valueList.length > 4) valueList.removeAt(0);
    valueList.add(query);

    prefs.setStringList(key, valueList);
  }
}

Future<List<String>?> getPrefrenceList(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(key);
}

Widget showCircularProgress(bool _isProgress, Color color) {
  if (_isProgress) {
    // return Center(
    //     child: CircularProgressIndicator(
    //   valueColor: AlwaysStoppedAnimation<Color>(color),
    // ));
    return Center(
      child: Container(
        width: 200,
        //height: 30,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // CircleAvatar(
            //   backgroundImage:
            //       ExactAssetImage(Img.get('logo_only.png'), scale: 0.05),
            //   // Optional as per your use case
            //   // minRadius: 30,
            //   // maxRadius: 70,
            //   radius: 15,
            //   backgroundColor: Colors.white,
            // ),
            Image.asset(Img.get(ConstValue.path_full_logo),
                fit: BoxFit.fill, height: 20, width: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 238, 44, 53)),
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }
  return const SizedBox.shrink();
  /* Container(
    height: 0.0,
    width: 0.0,
  ); */
}

placeHolder() {
  return Image.asset("assets/images/placeholder.png");
}

//network image in error
errorWidget(double height, double width) {
  return Image.asset(
    "assets/images/placeholder.png",
    height: height,
    width: width,
  );
}

//password validation check
// String? passValidation(String value, BuildContext context) {
//   if (value.length == 0)
//     return LocalizationUtil.translate('pwd_required')!;
//   else if (value.length <= 5)
//     return LocalizationUtil.translate('pwd_length')!;
//   else
//     return null;
// }

// String? convertToAgo(BuildContext context, DateTime input, int from) {
//   Duration diff = DateTime.now().difference(input);
//
//   if (diff.inDays >= 1) {
//     if (from == 0) {
//       var newFormat = DateFormat("dd MMMM yyyy");
//       final newsDate1 = newFormat.format(input);
//       return newsDate1;
//     } else if (from == 1) {
//       return "${diff.inDays} ${LocalizationUtil.translate('days')} ${LocalizationUtil.translate('ago')}";
//     } else if (from == 2) {
//       var newFormat = DateFormat("dd MMMM yyyy HH:mm:ss");
//       final newsDate1 = newFormat.format(input);
//       return newsDate1;
//     }
//   } else if (diff.inHours >= 1) {
//     if (input.minute == 00) {
//       return "${diff.inHours} ${LocalizationUtil.translate('hours')} ${LocalizationUtil.translate('ago')}";
//     } else {
//       if (from == 2) {
//         return "${LocalizationUtil.translate('about')} ${diff.inHours} ${LocalizationUtil.translate('hours')} ${input.minute} ${LocalizationUtil.translate('minutes')} ${LocalizationUtil.translate('ago')}";
//       } else {
//         return "${diff.inHours} ${LocalizationUtil.translate('hours')} ${input.minute} ${LocalizationUtil.translate('minutes')} ${LocalizationUtil.translate('ago')}";
//       }
//     }
//   } else if (diff.inMinutes >= 1) {
//     return "${diff.inMinutes} ${LocalizationUtil.translate('minutes')} ${LocalizationUtil.translate('ago')}";
//   } else if (diff.inSeconds >= 1) {
//     return "${diff.inSeconds} ${LocalizationUtil.translate('seconds')} ${LocalizationUtil.translate('ago')}";
//   } else {
//     return "${LocalizationUtil.translate('just_now')}";
//   }
//   return null;
// }


// Text setCoverageText(BuildContext context) {
//   return Text(
//     LocalizationUtil.translate('view_full_coverage')!,
//     textAlign: TextAlign.center,
//     style: Theme.of(context).textTheme.subtitle1?.copyWith(
//         color: Theme.of(context).colorScheme.fontColor.withOpacity(0.9),
//         fontWeight: FontWeight.w600),
//   );
// }

contentShimmer(BuildContext context) {
  //bookmarks
  return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.6),
      highlightColor: Colors.grey,
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          top: 15.0,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          //  BouncingScrollPhysics(),
          itemBuilder: (_, i) => Padding(
              padding: EdgeInsetsDirectional.only(
                top: i == 0 ? 0 : 15.0,
              ), //start: 10, end: 10
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.withOpacity(0.6)),
                  height: 215.0,
                ),
              ])),
          itemCount: 6,
        ),
      ));
}




Widget getIconFromByte(BuildContext context,String icon) {
  // List<int> codeUnits = icon.codeUnits;
  Uint8List bytes = base64.decode(icon);
  return   Image(image: Image.memory(bytes).image, fit: BoxFit.fill);
}



Widget iconFake() {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        //border: Border.all(color: Colors.red),
        //color: Color.fromARGB(255, 167, 27, 27),
      ),
      height: 62,
    ),
  );
}





void setTimeout(callback, time) {
  Duration timeDelay = Duration(milliseconds: time);
  Timer(timeDelay, callback);
}

String fnGetValidUrl(String url) {
  RegExp urlRegExp =
      new RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  var urlMatches = urlRegExp.allMatches(url);
  List<String> urls = urlMatches
      .map((urlMatch) => url.substring(urlMatch.start, urlMatch.end))
      .toList();
  return urls.first;
}

String fnGetValidHtml(String html) {
  var validHtml = html;
  validHtml = validHtml.replaceAll("label", "span");
  return validHtml;
}
