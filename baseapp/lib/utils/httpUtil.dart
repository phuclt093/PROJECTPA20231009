
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baseapp/utils/commonUtil.dart';
import '../commons/ConstValue.dart';
import 'package:http/http.dart' as http;


class HttpHelper {
  static Future<String> fetchPostWithoutLogin(String ulr, Map<String, String> parameters,
      BuildContext context, Function fnWorking) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("id_token") ?? "";

    fnWorking(false);

    var _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      var headers = {'Authorization': 'Bearer $token'};
      String result = "";
      String fullUrl = ConstValue.api_BaseUrl + ulr;

      var url = Uri.parse(fullUrl);
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(parameters);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 401) {
        // Navigator.pushNamedAndRemoveUntil(
        //     context, '/login', ModalRoute.withName('/login'));
        fnWorking(true);
        return "";
      }

      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON

        var result = await response.stream.bytesToString();
        // print("Status OK");
        fnWorking(true);
        return result;
      } else {
        fnWorking(true);
        return result;
        //ToastMessage.showColoredToast("Please select grade!", "WARNING");
      }
    } else {
      // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
      return "";
    }
  }

  static Future<String> fetchPost({String? ulr, Map<String, String>? parameters,
      BuildContext? context, Function? fnWorking, bool isAuth = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("id_token") ?? "";

    fnWorking!(false);

    if (token == "" && isAuth == true) {
      Navigator.pushNamedAndRemoveUntil(
          context!, '/login', ModalRoute.withName('/login'));
      fnWorking(true);
      return "";
    }

    var _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      var headers = {'Authorization': 'Bearer $token'};
      String result = "";
      String fullUrl = ConstValue.api_BaseUrl + ulr!;

      var request = http.MultipartRequest('POST', Uri.parse(fullUrl));
      request.fields.addAll(parameters!);
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 401) {
        Navigator.pushNamedAndRemoveUntil(
            context!, '/login', ModalRoute.withName('/login'));
        fnWorking(true);
        return "";
      }

      if (response.statusCode == 200) {
        var result = await response.stream.bytesToString();
        fnWorking(true);
        return result;
      } else {
        fnWorking(true);
        return result;
        //ToastMessage.showColoredToast("Please select grade!", "WARNING");
      }
    } else {
      // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
      return "";
    }
  }
}
