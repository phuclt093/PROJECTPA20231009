import 'package:flutter/material.dart';

class ConstValue {
  static String path_full_logo = "logo_full.png";
  static String path_only_logo = "logo_only.png";

  static String chucnangSearchText = "";
  static String defaultLanguageCode = "en";
  static String recentMenuIDStr = "";
  static String api_BaseUrl = "https://inforestapi.site";
  static String api_RegisterUserURL = "/api/login/RegisterUser";
  static String api_LoginCheckURL = "/api/login/LoginCheck";
  static String api_SendEmailVerifyURL = "/api/login/SendEmailVerify";
  static String api_CheckVerifyEmailURL = "/api/login/CheckVerifyEmail";
  static String api_ForgetPassURL = "/api/login/ForgetPass";
  static String api_ConfirmCodeChangePassURL = "/api/login/ConfirmCodeChangePass";
  static const String url_AssetMainBackground = "assets/images/main_background.jpg";

  static List<DropdownMenuItem<Locale>> dropdownItems = [
    const DropdownMenuItem(child: Text("VI"), value: Locale("vi","VN")),
    const DropdownMenuItem(child: Text("US"), value: Locale("en","US")),
  ];

}
