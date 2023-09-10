import 'dart:convert';
import 'package:baseapp/commons/ErrorCode.dart';
import 'package:baseapp/commons/MessageType.dart';
import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/pages/auth/LoginPage.dart';
import 'package:baseapp/widgets/CustomLanguageSelectBoxWidget.dart';
import 'package:baseapp/widgets/CustomPasswordFieldWidget.dart';
import 'package:baseapp/widgets/CustomTextFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sizer/sizer.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:baseapp/models/token.dart';
import 'package:baseapp/pages/common/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/commonUtil.dart';
import 'package:baseapp/utils/localizationUtil.dart';
import '../../data/img.dart';
import '../../utils/httpUtil.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  bool finishLoading = false;
  bool isCheckedRememberMe = true;
  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  bool _isNetworkAvail = true;
  final TextEditingController userNameEdit = TextEditingController();
  final TextEditingController passWordEdit = TextEditingController();
  final TextEditingController passWordConfirmEdit = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passwordConfirmFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {}

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        finishLoading = true;
      });
    });
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
                      textController: userNameEdit,
                      onFieldSubmitFunc: (v) {
                        CommonUtil.ChangeFocus(context, emailFocus, passwordFocus);
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
                      setState(() {});
                    },
                    colorFont: ThemeColor.colorFont_TextBox,
                    colorFontHint: ThemeColor.colorHint_TextBox,
                    textController: passWordEdit,
                    onFieldSubmitFunc: (v) {
                      CommonUtil.ChangeFocus(context, passwordFocus, passwordConfirmFocus);
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
                      left: 10.w, right: 10.w, bottom: 5.h, top: 1.h),
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
                      setState(() {});
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
                          fnSignUp();
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

  Future fnSignUp() async {
    if (userNameEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailEmpty_Message')!, MessageType.ERROR);
      return;
    }

    if (CommonUtil.CheckEmailFormat(userNameEdit.text) == false) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailFormatInvalid_Message')!, MessageType.ERROR);
      return;
    }

    if (passWordEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblPasswordEmpty_Message')!, MessageType.ERROR);
      return;
    }

    if (passWordConfirmEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblConfirmPasswordEmpty_Message')!, MessageType.ERROR);
      return;
    }

    if (passWordConfirmEdit.text.toString() != passWordEdit.text.toString()) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblPasswordMismatch')!, MessageType.ERROR);
      return;
    }

    //Check password strength
    var resultCheck =
    CommonUtil.CheckPasswordFormat(passWordEdit.text);
    if (resultCheck == ErrorCode.ERROR_CODE_TWO_UPPERCASE_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordUppercaseError_Message')!, MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_ONE_SPECIAL_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordSpecialcaseError_Message')!, MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_TWO_DIGIT) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordDigitError_Message')!, MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_THREE_LOWERCASE_LETTER) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordLowercaseError_Message')!, MessageType.ERROR);
      return false;
    }

    if (resultCheck == ErrorCode.ERROR_CODE_SMALLER_THAN_8) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('PasswordLengthError_Message')!, MessageType.ERROR);
      return false;
    }

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_RegisterUserURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': userNameEdit.text.toString(),
        'pass': passWordEdit.text.toString(),
        'retypepass': passWordConfirmEdit.text.toString()
      };

      String resultStr = await HttpHelper.fetchPost(
          context: context,
          fnWorking: setFinishWorking,
          parameters: parameters,
          isAuth: false,
          ulr: ulr);

      try {
        final json = jsonDecode(resultStr);
        var token = Token.fromJsonSignUp(json);
        if(token != null){
          if (token.result == "OK") {
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!), MessageType.OK);
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', ModalRoute.withName('/login'));
          } else {
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.ERROR);
            setFinishWorking(true);
          }
        }
       else {
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('lblError')!, MessageType.ERROR);
          setFinishWorking(true);
        }
      } catch (e) {
        ToastMessage.showColoredToast(
            LocalizationUtil.translate('lblError')!, MessageType.ERROR);
        setFinishWorking(true);
      } finally {
        setFinishWorking(true);
      }
    } else {

    }
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
