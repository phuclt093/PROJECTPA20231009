import 'dart:async';
import 'dart:convert';
import 'package:baseapp/enums/ErrorCode.dart';
import 'package:baseapp/enums/MessageType.dart';
import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/pages/auth/ConfirmSignUpPage.dart';
import 'package:baseapp/pages/auth/LoginPage.dart';
import 'package:baseapp/utils/DialogUtil.dart';
import 'package:baseapp/widgets/CustomLanguageSelectBoxWidget.dart';
import 'package:baseapp/widgets/CustomPasswordFieldWidget.dart';
import 'package:baseapp/widgets/CustomTextFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:baseapp/models/token.dart';
import 'package:baseapp/pages/common/Toast_message.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/CommonUtil.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';
import '../../utils/ImageUtil.dart';
import '../../utils/HttpUtil.dart';

class ConfirmResetPasswordPage extends StatefulWidget {
  ConfirmResetPasswordPage({super.key, required this.email});

  String email;

  @override
  ConfirmResetPasswordPageState createState() =>
      ConfirmResetPasswordPageState();
}

class ConfirmResetPasswordPageState extends State<ConfirmResetPasswordPage>
    with TickerProviderStateMixin {
  bool finishLoading = false;
  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  bool _isNetworkAvail = true;
  final TextEditingController codeEdit = TextEditingController();
  final TextEditingController passWordEdit = TextEditingController();
  final TextEditingController passWordConfirmEdit = TextEditingController();
  FocusNode codeFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passwordConfirmFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? dialogcontext;

  bool isPasswordDigitError_Message = false;
  bool isPasswordLengthError_Message = false;
  bool isPasswordLowercaseError_Message = false;
  bool isPasswordSpecialcaseError_Message = false;
  bool isPasswordUppercaseError_Message = false;
  bool isPasswordHavingSpaces_Message = false;

  late Timer timerCountDown;
  Duration duration = const Duration(minutes: 2);

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timerCountDown = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (duration.inSeconds <= 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            duration = duration - oneSec;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    duration = const Duration(minutes: 2);
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    dialogcontext = context;
    var ThemeColor = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      key: _scaffoldKey,
      appBar: CommonUtil.SetAppBar(
          context: context,
          fontSize: 18.sp,
          title: LocalizationUtil.translate("ChangePassword"),
          background: ThemeColor.colorAppBar_Background,
          foreground: ThemeColor.colorAppBar_Foreground,
          colorFont: ThemeColor.colorAppBar_Font,
          colorIcon: ThemeColor.colorAppBar_Icon,
          onBack: () {
            Navigator.pop(context);
          }),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ConstValue.url_AssetMainBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.fromLTRB(60.w, 5.h, 0.w, 0),
                padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0.h),
                decoration:
                    BoxDecoration(color: ThemeColor.colorBackground_Dropdown),
                child: CustomSelectBoxWidget(
                  colorIconEnabled: ThemeColor.colorIconEnabled_Dropdown,
                  colorFont: ThemeColor.colorFont_Dropdown,
                  coloBackground: ThemeColor.colorBackground_Dropdown,
                  fontSize: 10.sp,
                  dropdownItems: ConstValue.dropdownItems,
                  selectedLang: context.locale,
                  onChangeFunc: (Object? newValue) {
                    Locale? selected = newValue as Locale?;
                    LocalizationUtil.ChangeLanguage(selected!, context);
                    setState(() {});
                  },
                )),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10.h, 0, 0),
              child: Image.asset(
                Img.get(ConstValue.path_full_logo),
                //color: Colors.white,
              ),
              width: themeValue.widthMainLogo,
              height: themeValue.heightMainLogo,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0.5.h, 0, 5.h),
              child: Text(
                LocalizationUtil.translate("lblChatYourWay"),
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                    color: ThemeColor.colorText_Label),
              ),
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
                hintLabel: LocalizationUtil.translate('lblPasswordConfirm')!,
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
                  left: 10.w, right: 10.w, bottom: 1.h, top: 2.h),
              child: CustomTextFieldWidget(
                  focusNode: codeFocus,
                  borderRadius: themeValue.TextBox_BorderRadius,
                  coloBackground: Theme.of(context)
                      .colorScheme
                      .colorBackground_TextBox
                      .withOpacity(0.7),
                  colorBorderEnabled: ThemeColor.colorBorder_TextBox,
                  colorBorderFocus:
                      Theme.of(context).colorScheme.colorBorderActive_TextBox,
                  onChangeFunc: (String? value) {
                    setState(() {
                      // _username = value;
                    });
                  },
                  colorFont: ThemeColor.colorFont_TextBox,
                  colorFontHint: ThemeColor.colorHint_TextBox,
                  textController: codeEdit,
                  onFieldSubmitFunc: (v) {},
                  hintLabel: LocalizationUtil.translate('CodeConfirm')!),
            ),
            duration.inSeconds <= 0
                ? Container(
                    margin: EdgeInsets.only(
                        left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                    child: InkWell(
                        splashColor: Colors.transparent,
                        child: Text(
                          LocalizationUtil.translate('Resend')!,
                          //login_btn
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 12.sp,
                              color:
                                  Theme.of(context).colorScheme.colorText_Link),
                        ),
                        onTap: () async {
                          fnGetCodeConfirmInEmail(context);
                        }),
                  )
                : Container(
                    margin: EdgeInsets.only(
                        left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                    child: Text(
                      CommonUtil.DislayMMSS(duration),
                      //login_btn
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Theme.of(context).colorScheme.colorText_Link),
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
                      LocalizationUtil.translate('Confirm')!,
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
                      fnChange(context);
                      //signInWithEmailPassword(email!.trim(), pass!);
                    } else {
                      // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
                    }
                  }),
            )
          ],
        )),
      ),
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

  Future fnGetCodeConfirmInEmail(BuildContext context) async {
    if (widget.email.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_ForgetPassURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': widget.email,
      };

      try {
        //Show loading
        var ThemeColor = Theme.of(context).colorScheme;
        var result = await DialogUtil.fncShowLoadingScreen(
            context,
            ThemeColor.colorIconProgress_Dialog,
            ThemeColor.colorMessage_Dialog,
            dialogcontext!);
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

            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(dialogcontext!);

            duration = const Duration(minutes: 2);
            startTimer();

            return;
          } else {
            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(dialogcontext!);
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.ERROR);
            setFinishWorking(true);
          }
        } else {
          if (!mounted) return false;
          await DialogUtil.hideLoadingScreen(dialogcontext!);
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('lblError')!, MessageType.ERROR);
          setFinishWorking(true);
        }
      } catch (e) {
        if (!mounted) return false;
        await DialogUtil.hideLoadingScreen(dialogcontext!);
        ToastMessage.showColoredToast(
            LocalizationUtil.translate('lblError')!, MessageType.ERROR);
        setFinishWorking(true);
      } finally {
        setFinishWorking(true);
      }
    } else {}
  }

  Future fnChange(BuildContext context) async {
    if (codeEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('CodeConfirmEmpty_Message')!,
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
      String ulr = ConstValue.api_ConfirmCodeChangePassURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': widget.email,
        'code': codeEdit.text.toString(),
        'pass': passWordEdit.text.toString(),
        'retypepass': passWordConfirmEdit.text.toString()
      };

      try {
        //Show loading
        var ThemeColor = Theme.of(context).colorScheme;
        var result = await DialogUtil.fncShowLoadingScreen(
            context,
            ThemeColor.colorIconProgress_Dialog,
            ThemeColor.colorMessage_Dialog,
            dialogcontext!);
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

            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(dialogcontext!);

            setState(() {
              if (mounted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              }
            });

            return;
          } else {
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.ERROR);
            if (!mounted) return false;
            await DialogUtil.hideLoadingScreen(dialogcontext!);
            setFinishWorking(true);
          }
        } else {
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('lblError')!, MessageType.ERROR);
          if (!mounted) return false;
          await DialogUtil.hideLoadingScreen(dialogcontext!);
          setFinishWorking(true);
        }
      } catch (e) {
        ToastMessage.showColoredToast(
            LocalizationUtil.translate('lblError')!, MessageType.ERROR);
        if (!mounted) return false;
        await DialogUtil.hideLoadingScreen(dialogcontext!);
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
