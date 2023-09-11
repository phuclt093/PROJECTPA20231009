import 'dart:convert';
import 'package:baseapp/enums/ErrorCode.dart';
import 'package:baseapp/enums/MessageType.dart';
import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/pages/auth/ConfirmSignUpPage.dart';
import 'package:baseapp/pages/auth/LoginPage.dart';
import 'package:baseapp/utils/DialogUtil.dart';
import 'package:baseapp/widgets/CustomPasswordFieldWidget.dart';
import 'package:baseapp/widgets/CustomTextFieldWidget.dart';
import 'package:sizer/sizer.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:baseapp/models/token.dart';
import 'package:baseapp/pages/common/Toast_message.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/CommonUtil.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/HttpUtil.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  bool finishLoading = false;
  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  bool _isNetworkAvail = true;
  final TextEditingController emailEdit = TextEditingController();
  final TextEditingController passWordEdit = TextEditingController();
  final TextEditingController passWordConfirmEdit = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passwordConfirmFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {}

  bool isPasswordDigitError_Message = false;
  bool isPasswordLengthError_Message = false;
  bool isPasswordLowercaseError_Message = false;
  bool isPasswordSpecialcaseError_Message = false;
  bool isPasswordUppercaseError_Message = false;
  bool isPasswordHavingSpaces_Message = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var ThemeColor = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Image.asset(
          "assets/images/main_background.jpg",
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: CommonUtil.SetAppBar(
              context: context,
              fontSize: 18.sp,
              title: LocalizationUtil.translate("lblSignUp"),
              background: ThemeColor.colorAppBar_Background,
              foreground: ThemeColor.colorAppBar_Foreground,
              colorFont: ThemeColor.colorAppBar_Font,
              colorIcon: ThemeColor.colorAppBar_Icon,
              onBack: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }),
          body: SingleChildScrollView(
              child: Align(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
                  child: Image.asset(
                    Img.get(ConstValue.path_full_logo),
                    //color: Colors.white,
                  ),
                  width: 80.w,
                  height: 12.h,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0.5.h, 0, 5.h),
                  child: Text(
                    LocalizationUtil.translate("lblChatYourWay"),
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                        color: ThemeColor.colorHint_TextBox),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 1.h, top: 2.h),
                  child: CustomTextFieldWidget(
                      focusNode: emailFocus,
                      borderRadius: themeValue.TextBox_BorderRadius,
                      coloBackground: Theme.of(context)
                          .colorScheme
                          .colorBackground_TextBox
                          .withOpacity(0.7),
                      colorBorderEnabled: ThemeColor.colorBorder_TextBox,
                      colorBorderFocus: Theme.of(context)
                          .colorScheme
                          .colorBorderActive_TextBox,
                      onChangeFunc: (String? value) {
                        setState(() {
                          // _username = value;
                        });
                      },
                      colorFont: ThemeColor.colorFont_TextBox,
                      colorFontHint: ThemeColor.colorHint_TextBox,
                      textController: emailEdit,
                      onFieldSubmitFunc: (v) {
                        CommonUtil.ChangeFocus(
                            context, emailFocus, passwordFocus);
                      },
                      hintLabel: LocalizationUtil.translate('lblEmail')!),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 1.h, top: 1.h),
                  child: CustomPasswordFieldWidget(
                    focusNode: passwordFocus,
                    borderRadius: themeValue.TextBox_BorderRadius,
                    coloBackground: Theme.of(context)
                        .colorScheme
                        .colorBackground_TextBox
                        .withOpacity(0.7),
                    colorBorderEnabled: ThemeColor.colorBorder_TextBox,
                    colorBorderFocus: ThemeColor.colorBorderActive_TextBox,
                    onChangeFunc: (String? value) {
                      CheckPasswordStrength(value!);
                    },
                    colorFont: ThemeColor.colorFont_TextBox,
                    colorFontHint: ThemeColor.colorHint_TextBox,
                    textController: passWordEdit,
                    onFieldSubmitFunc: (v) {
                      CommonUtil.ChangeFocus(
                          context, passwordFocus, passwordConfirmFocus);
                    },
                    hintLabel: LocalizationUtil.translate('lblPassword')!,
                    suffixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: IconButton(
                          icon: !_isObsecure
                              ? Icon(Icons.visibility_rounded, size: 2.h)
                              : Icon(Icons.visibility_off_rounded, size: 2.h),
                          color: ThemeColor.colorHint_TextBox,
                          splashColor: Theme.of(context)
                              .colorScheme
                              .colorSplashSuffix_Password,
                          onPressed: () {
                            _toggle();
                          },
                        )),
                    isObsecureText: _isObsecure,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 1.h, top: 1.h),
                  child: CustomPasswordFieldWidget(
                    focusNode: passwordConfirmFocus,
                    borderRadius: themeValue.TextBox_BorderRadius,
                    coloBackground: Theme.of(context)
                        .colorScheme
                        .colorBackground_TextBox
                        .withOpacity(0.7),
                    colorBorderEnabled: ThemeColor.colorBorder_TextBox,
                    colorBorderFocus: ThemeColor.colorBorderActive_TextBox,
                    onChangeFunc: (String? value) {
                      CheckPasswordStrength(value!);
                    },
                    colorFont: ThemeColor.colorFont_TextBox,
                    colorFontHint: ThemeColor.colorHint_TextBox,
                    textController: passWordConfirmEdit,
                    onFieldSubmitFunc: (v) {},
                    hintLabel:
                        LocalizationUtil.translate('lblPasswordConfirm')!,
                    suffixIcon: Padding(
                        padding: EdgeInsetsDirectional.only(end: 1.w),
                        child: IconButton(
                          icon: !_isObsecureConfirm
                              ? Icon(Icons.visibility_rounded, size: 2.h)
                              : Icon(Icons.visibility_off_rounded, size: 2.h),
                          color: ThemeColor.colorHint_TextBox,
                          splashColor: Theme.of(context)
                              .colorScheme
                              .colorSplashSuffix_Password,
                          onPressed: () {
                            _toggleConfirm();
                          },
                        )),
                    isObsecureText: _isObsecureConfirm,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 0.h, top: 0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isPasswordDigitError_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordDigitError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                      isPasswordLengthError_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordLengthError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                      isPasswordLowercaseError_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordLowercaseError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                      isPasswordSpecialcaseError_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordSpecialcaseError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                      isPasswordUppercaseError_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordUppercaseError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                      isPasswordHavingSpaces_Message == true
                          ? Text(
                              LocalizationUtil.translate(
                                  "PasswordSpaceError_Message"),
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: ThemeColor.colorHint_TextBox))
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      child: Container(
                        height: 6.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .colorButtonLogin_Background,
                            borderRadius: BorderRadius.circular(
                                themeValue.Button_BorderRadius)),
                        child: Text(
                          LocalizationUtil.translate('lblSignUp')!,
                          //login_btn
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Theme.of(context)
                                  .colorScheme
                                  .colorButtonLogin_Text),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).unfocus(); //dismiss keyboard
                        _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
                        if (_isNetworkAvail) {
                          setState(() {
                            finishLoading = true;
                          });
                          fnSignUp(context);
                          //signInWithEmailPassword(email!.trim(), pass!);
                        } else {
                          // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
                        }
                      }),
                )
              ],
            ),
          )),
        )
      ],
    );
  }

  void CheckPasswordStrength(String password) {
    isPasswordDigitError_Message = false;
    isPasswordLengthError_Message = false;
    isPasswordLowercaseError_Message = false;
    isPasswordSpecialcaseError_Message = false;
    isPasswordUppercaseError_Message = false;
    isPasswordHavingSpaces_Message = false;

    if (password.isEmpty == false) {
      var listError = CommonUtil.CheckPasswordFormatArr(password);
      if (listError.contains(ErrorCode.ERROR_CODE_ONE_UPPERCASE_LETTER)) {
        isPasswordUppercaseError_Message = true;
      }

      if (listError.contains(ErrorCode.ERROR_CODE_ONE_SPECIAL_LETTER)) {
        isPasswordSpecialcaseError_Message = true;
      }

      if (listError.contains(ErrorCode.ERROR_CODE_ONE_DIGIT)) {
        isPasswordDigitError_Message = true;
      }

      if (listError.contains(ErrorCode.ERROR_CODE_ONE_LOWERCASE_LETTER)) {
        isPasswordLowercaseError_Message = true;
      }

      if (listError.contains(ErrorCode.ERROR_CODE_SMALLER_THAN_8)) {
        isPasswordLengthError_Message = true;
      }

      if (listError.contains(ErrorCode.ERROR_CODE_HAVING_SPACE)) {
        isPasswordHavingSpaces_Message = true;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setFinishWorking(bool status) {
    if (mounted) {
      setState(() {
        finishLoading = status;
      });
    }
  }

  Future fnSignUp(BuildContext context) async {
    if (emailEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    if (CommonUtil.CheckEmailFormat(emailEdit.text) == false) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailFormatInvalid_Message')!,
          MessageType.ERROR);
      return;
    }

    if (passWordEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblPasswordEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    if (passWordConfirmEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblConfirmPasswordEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    if (passWordConfirmEdit.text.toString() != passWordEdit.text.toString()) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblPasswordMismatch')!,
          MessageType.ERROR);
      return;
    }

    //Check password strength
    var resultCheck = CommonUtil.CheckPasswordFormat(passWordEdit.text);
    if (resultCheck == ErrorCode.ERROR_CODE_ONE_UPPERCASE_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordUppercaseError_Message')!,
          MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_ONE_SPECIAL_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordSpecialcaseError_Message')!,
          MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_ONE_DIGIT) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordDigitError_Message')!,
          MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_ONE_LOWERCASE_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordLowercaseError_Message')!,
          MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_SMALLER_THAN_8) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordLengthError_Message')!,
          MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_HAVING_SPACE) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordSpaceError_Message')!,
          MessageType.ERROR);
      return false;
    }

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_RegisterUserURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': emailEdit.text.toString(),
        'pass': passWordEdit.text.toString(),
        'retypepass': passWordConfirmEdit.text.toString()
      };

      try {
        //Show loading
        var ThemeColor = Theme.of(context).colorScheme;
        var result = await DialogUtil.fncShowLoadingScreen(
            context,
            ThemeColor.colorIconProgress_Dialog,
            ThemeColor.colorMessage_Dialog);
        if (!result) {
          return false;
        }

        String resultStr = await HttpHelper.fetchPost(
            context: context,
            fnWorking: setFinishWorking,
            parameters: parameters,
            isAuth: false,
            ulr: ulr);

        final json = jsonDecode(resultStr);
        var token = Token.fromJsonSignUp(json);
        if (token != null) {
          if (token.result == "OK") {
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!), MessageType.OK);

            // if (mounted) {
            //   await DialogUtil.hideLoadingScreen(context);
            // }

            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(context);

            setState(() {
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfirmSignUpPage(email: emailEdit.text)));
              }
            });

            return;
          } else {
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.ERROR);
            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(context);
            setFinishWorking(true);
          }
        } else {
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('lblError')!, MessageType.ERROR);
          if (!mounted) return false;
          await DialogUtil.hideLoadingScreen(context);
          setFinishWorking(true);
        }
      } catch (e) {
        ToastMessage.showColoredToast(
            LocalizationUtil.translate('lblError')!, MessageType.ERROR);
        if (!mounted) return false;
        await DialogUtil.hideLoadingScreen(context);
        setFinishWorking(true);
      } finally {
        setFinishWorking(true);
      }
    } else {}
  }

  void _toggle() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _isObsecureConfirm = !_isObsecureConfirm;
    });
  }
}
