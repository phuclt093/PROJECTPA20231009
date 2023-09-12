import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

extension themeValue on ColorScheme {
  static const Color colorPinkMomo = Color(0xffD43D8C);
  static const Color colorBackgroundMomo = Color(0xffECECEE); //C9C9C9 F0F0F0

  static const Color primary = Color(0xffff3f4c);
  static const Color tempboxColor = Color(0xffffffff);
  static const Color bgColor = Color(0xffEEEEEE);
  static const Color templightColor = Color(0xffE5E5E5);
  static const Color tempBorderColor = Color(0xff6B6B6B);
  static const Color lightBorderColor = Color(0xff92c4e);
  static const Color lightTextColor = Color(0xfffafafa);
  static const Color textFormFieldColor = Color(0xfff5f4f9);
  static const Color tempdarkColor = Color(0xff305599);
  static const Color darkBorderColor = Color(0xff629afe);
  static const Color darkColor1 = Color(0xff1a2e51);
  static const Color darkModeColor = Color(0xff102041);
  static const Color clearColor = Colors.transparent;
  static const Color blackColor = Colors.black;
  static const Color secondaryColor = Color(0xff102041);
  static const Color disabledColor = Color(0xffbebdc4);
  static const Color settingsIconClrL = Color(0xff5c5c5c);

  // static const Color settingsIconClrD = Color(0xff8db2f5);
  static const Color shadowColor = Color(0xff29000000);
  static const Color lightLikeContainerColor = Color(0xfff5f5f5);
  static const Color dartLikeContainerColor = Color(0xff1b325b);
  static const Color coverageUnSelColor = Color(0xff7b8cac);
  static const Color colorGrey = Color(0xffE7E7E7);
  static const Color colorGrey1 = Color(0xff838383);
  static const Color transparentColor = Colors.transparent;
  static const Color colorBlueTDT = Color(0xff0064A7);

  static List<Color> lstWeekColor = [
    const Color(0xffFEC76F),
    const Color(0xffB3BE62),
    const Color(0xffBE95BE),
    const Color(0xff6DBFB8),
    const Color(0xffF5945C),
    const Color.fromARGB(255, 96, 146, 221),
    const Color(0xffFF6C55),
  ];

  //System
  static const Brightness brightnessLight = Brightness.light;
  static const Brightness statusBarBrightnessLight = Brightness.light;
  static const Brightness statusBarIconBrightnessLight = Brightness.dark;
  static const Color statusBarColorLight = Colors.transparent;
  static const Color splashColorLight = Colors.transparent;
  static const Color splashBackgroundColorLight = Colors.white;
  static const Brightness brightnessDark = Brightness.dark;
  static const Brightness statusBarBrightnessDark = Brightness.dark;
  static const Brightness statusBarIconBrightnessDark = Brightness.light;
  static const Color statusBarColorDark = Colors.transparent;
  static const Color splashColorDark = Colors.transparent;
  static const Color splashBackgroundColorDark = Colors.white;
  static const Color processCircleBarColor = Color(0xff8EC41C) ;

  //Control
  Color get colorAppBar_Background =>
      this.brightness == Brightness.light ? const Color(0xff8EC41C)
      : const Color(0xff8EC41C);
  Color get colorAppBar_Font =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;
  Color get colorAppBar_Foreground =>
      this.brightness == Brightness.light ? Colors.white : Colors.white;
  Color get colorAppBar_Icon =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;

  Color get colorMainBackground =>
      this.brightness == Brightness.light ? Colors.white : Colors.white;

  Color get colorButtonLogin_Background =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;
  Color get colorButtonLogin_Text =>
      this.brightness == Brightness.light ? Colors.white : Colors.white;

  Color get colorBorder_TextBox => this.brightness == Brightness.light
      ? Colors.transparent
      : Colors.transparent;
  Color get colorBorderActive_TextBox => this.brightness == Brightness.light
      ? Colors.transparent
      : Colors.transparent;
  Color get colorBackground_TextBox => this.brightness == Brightness.light
      ? const Color(0xffF5F5F5)
      : const Color(0xffF5F5F5);
  Color get colorFont_TextBox =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;
  Color get colorHint_TextBox => this.brightness == Brightness.light
      ? Colors.grey.withOpacity(0.5)
      : Colors.grey.withOpacity(0.5);

  Color get colorSplashSuffix_Password => this.brightness == Brightness.light
      ? Colors.green.withOpacity(0.5)
      : Colors.green.withOpacity(0.5);

  Color get colorBackground_Dropdown => this.brightness == Brightness.light
      ? const Color(0xffF5F5F5)
      : const Color(0xffF5F5F5);
  Color get colorFont_Dropdown =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;
  Color get colorIconEnabled_Dropdown =>
      this.brightness == Brightness.light ? Colors.black : Colors.black;


  Color get colorIconProgress_Dialog =>
      this.brightness == Brightness.light ? const Color(0xff8EC41C) : const Color(0xff8EC41C);
  Color get colorMessage_Dialog =>
      this.brightness == Brightness.light ? Colors.white : Colors.white;

  Color get colorText_Link =>
      this.brightness == Brightness.light ? Colors.amber : Colors.amber;

//Size
  static double TextBox_BorderRadius = 35.sp;
  static double Button_BorderRadius = 35.sp;
  static double heightMainLogo = 8.h;
  static double widthMainLogo = 80.w;


}
