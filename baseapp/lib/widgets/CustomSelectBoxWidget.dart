import 'package:baseapp/commons/ThemeValue.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';
import 'package:sizer/sizer.dart';

class CustomSelectBoxWidget extends StatelessWidget {
  CustomSelectBoxWidget(
      {super.key,
      this.fontSize,
      this.selectedLang,
      required this.onChangeFunc,
      this.colorFont,
      this.coloBackground,
      this.dropdownItems,
      this.colorIconEnabled});

  //Variables
  Color? colorFont;
  Color? colorIconEnabled;
  final Function(Object? value) onChangeFunc;
  Color? coloBackground;
  double? fontSize;
  Locale? selectedLang;
  List<DropdownMenuItem<Locale>>? dropdownItems = [];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton(
      iconEnabledColor: colorIconEnabled,
      padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
      isDense: true,
      style: TextStyle(
          color: colorFont, fontWeight: FontWeight.bold, fontSize: fontSize),
      value: selectedLang,
      dropdownColor: coloBackground,
      items: dropdownItems,
      onChanged: onChangeFunc,
    ));
  }

  @override
  void dispose() {}
}
