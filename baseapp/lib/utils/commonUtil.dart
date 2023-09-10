import 'package:baseapp/commons/ErrorCode.dart';
import 'package:baseapp/utils/localizationUtil.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonUtil {
  static final RegExp _emailRegexp = RegExp(r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  static bool IsNetworkAvailable() {
    var isNetwork = true;
    return isNetwork;
  }

  static bool CheckEmailFormat(String email){
    var result = true;
    if( _emailRegexp.firstMatch(email) == null){
      result = false;
    }
    return result;
  }

  static int CheckPasswordFormat(String password){
    //Ensure string has two uppercase letters.
    RegExp passwordRegex = RegExp(r'(?=.*[A-Z].*[A-Z])');
    if(!password.contains(passwordRegex)){
      return ErrorCode.ERROR_CODE_TWO_UPPERCASE_LETTER;
    }

    //Ensure string has one special case letter.
    passwordRegex = RegExp(r"(?=.*[!@#$&*])");
    if(!password.contains(passwordRegex)){
      return ErrorCode.ERROR_CODE_ONE_SPECIAL_LETTER;
    }

    //Ensure string has two digits.
    passwordRegex = RegExp(r"(?=.*[0-9].*[0-9])");
    if(!password.contains(passwordRegex)){
      return ErrorCode.ERROR_CODE_TWO_DIGIT;
    }

    //Ensure string has three lowercase letters.
    passwordRegex = RegExp(r"(?=.*[a-z].*[a-z].*[a-z])");
    if(!password.contains(passwordRegex)){
      return ErrorCode.ERROR_CODE_THREE_LOWERCASE_LETTER;
    }

    //Ensure string is of length 8
    if(password.length < 8){
      return ErrorCode.ERROR_CODE_SMALLER_THAN_8;
    }

    return 0;
  }



  static void ChangeFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static PreferredSizeWidget SetAppBar(
      {String? title,
      BuildContext? context,
      Color? background,
      Color? foreground,
      Color? colorFont,
      Color? colorIcon,
      double? fontSize,
      Function? onBack}) {
    var barPadding = EdgeInsets.fromLTRB(0.w, 0.h, 0.w, 0.h);

    return AppBar(
      title: Container(
        padding: barPadding,
        child: Text(
          LocalizationUtil.translate(title!),
          style: TextStyle(
              color: colorFont,
              fontSize: fontSize,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: background,
      foregroundColor: foreground,
      toolbarHeight: 8.h,
      leading: Padding(
          padding: barPadding,
          child: IconButton(
            icon: Icon(Icons.chevron_left, color: colorIcon, size: 5.h),
            onPressed: () {
              onBack!();
            },
          )),
    );
  }
}
