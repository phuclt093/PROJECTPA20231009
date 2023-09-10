import 'dart:convert';
import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/pages/auth/SignUpPage.dart';
import 'package:baseapp/widgets/CustomLanguageSelectBoxWidget.dart';
import 'package:baseapp/widgets/CustomPasswordFieldWidget.dart';
import 'package:baseapp/widgets/CustomTextFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:baseapp/models/token.dart';
import 'package:baseapp/pages/auth/authentication.dart';
import 'package:baseapp/pages/common/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baseapp/utils/commonUtil.dart';
import 'package:baseapp/utils/localizationUtil.dart';
import '../../data/img.dart';
import '../../helpers/session.dart';
import '../../utils/httpUtil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {
  bool finishLoading = false;
  late String _username, _password;
  bool isCheckedRememberMe = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObsecure = true;

  String initUsername = "";
  String initPassword = "";
  String? userType = "Student";
  bool isChecked = false;
  bool _isNetworkAvail = true;
  String? privacyTitle, privacyDesc, termsTitle, termsDesc;
  bool isTermsShow = false;
  String codeLangue = "vi";

  final TextEditingController userNameEdit = TextEditingController();
  final TextEditingController passWordEdit = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  void showInSnackBar(String value) {}

  @override
  void initState() {
    getPreviousUsernamePassword();
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
          //backgroundColor: Colors.white,
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: Container(color: ThemeColor.colorMainBackground)),
          body: SingleChildScrollView(
              child: Align(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(60.w, 5.h, 0.w, 0),
                    padding: EdgeInsets.fromLTRB(5.w, 0.h, 5.w, 0.h),
                    decoration: BoxDecoration(
                        color: ThemeColor.colorBackground_Dropdown),
                    child: CustomLanguageSelectBoxWidget(
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
                  margin: EdgeInsets.fromLTRB(0, 15.h, 0, 0),
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
                        _fieldFocusChange(context, emailFocus, passFocus);
                      },
                      hintLabel: LocalizationUtil.translate('lblEmail')!),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 10.w, right: 10.w, bottom: 5.h, top: 1.h),
                  child: CustomPasswordFieldWidget(
                    focusNode: passFocus,
                    borderRadius: themeValue.TextBox_BorderRadius,
                    coloBackground: Theme.of(context)
                        .colorScheme
                        .colorBackground_TextBox
                        .withOpacity(0.7),
                    colorBorderEnabled: ThemeColor.colorBorder_TextBox,
                    colorBorderFocus: ThemeColor.colorBorderActive_TextBox,
                    onChangeFunc: (String? value) {
                      setState(() {
                        _password = value!;
                      });
                    },
                    colorFont: ThemeColor.colorFont_TextBox,
                    colorFontHint: ThemeColor.colorHint_TextBox,
                    textController: passWordEdit,
                    onFieldSubmitFunc: (v) {},
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
                          LocalizationUtil.translate('lblLogin')!,
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

                          var deviceID = await Authentication.getDeviceID();
                          submitLoginForm(
                              _username, _password, deviceID, false);

                          //signInWithEmailPassword(email!.trim(), pass!);
                        } else {
                          // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      child: Text(
                        LocalizationUtil.translate('lblSignUp')!,
                        //login_btn
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                            fontSize: 10.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .colorHint_TextBox),
                      ),
                      onTap: () async {
                        FocusScope.of(context).unfocus(); //dismiss keyboard
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const SignUpPage()));
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

  void getPreviousUsernamePassword() async {
    setFinishWorking(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userNameEdit.text = prefs.getString("initUsername") ?? "";
      _username = userNameEdit.text;
      _password = passWordEdit.text;

      setFinishWorking(true);
    });
  }

  void setFinishWorking(bool status) {
    if (mounted) {
      setState(() {
        finishLoading = status;
      });
    }
  }

  // void _handleRefreshTokenByBiometrics() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //String tokenBiometrics = prefs.getString("token_biometrics") ?? "";
  //   String isEnableLogin = prefs.getString("is_enable_login") ?? "no";
  //   if (isEnableLogin == "yes") {
  //     var check = await Authentication.authenticateWithBiometricsFunc();
  //     if (check) {
  //       String userNameBi = prefs.getString("username_bi") ?? "";
  //       String passwordBi = prefs.getString("password_bi") ?? "";
  //       var deviceID = await Authentication.getDeviceID();
  //       submitLoginForm(userNameBi, passwordBi, deviceID, true);
  //     } else {
  //       ToastMessage.showColoredToast(
  //           LocalizationUtil.translate("LOGIN_FAIL_LBL")!, "ERROR");
  //       setFinishWorking(true);
  //     }
  //   } else {
  //     ToastMessage.showColoredToast(
  //         LocalizationUtil.translate('You_have_not_enabled_biometric_login')!,
  //         "WARNING");
  //     setFinishWorking(true);
  //   }
  // }

  Future submitLoginForm(String usernameval, String passwordval,
      String deviceid, bool isLoginByBiometrics) async {
    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = "login/checklogin";
      setFinishWorking(false);
      Map<String, String> parameters = {
        'username': usernameval,
        'password': passwordval,
        'deviceid': deviceid
      };

      String resultStr = await HttpHelper.fetchPost(
        context: context,
        fnWorking: setFinishWorking,
        parameters: parameters,
        isAuth: false,
        ulr: ulr
      );

      try {
        final json = jsonDecode(resultStr);
        var token = Token.fromJson(json);
        if (token.idToken != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          setState(() {
            prefs.setString("id_token", token.idToken ?? "");
            prefs.setString("username", token.username ?? "");
            prefs.setString("userTypeID", token.userTypeID ?? "");
            prefs.setString("email", token.email ?? "");
            prefs.setString("fullName", token.fullName ?? "");
            prefs.setString("userType", token.userType ?? "");
            prefs.setString("passwordTest", _password ?? "");
            prefs.setString("hashinfo", token.hashinfo ?? "");

            if (!isLoginByBiometrics) {
              prefs.setString("username_bi", _username);
              prefs.setString("password_bi", _password);

              if (isCheckedRememberMe) {
                prefs.setString("initUsername", _username);
                prefs.setString("initPassword", _password);
                prefs.setString("initUserType", userType ?? "");
              } else {
                prefs.setString("initUsername", "");
                prefs.setString("initPassword", "");
                prefs.setString("initUserType", "");
              }
            }
          });

          Navigator.pushNamedAndRemoveUntil(
              context, '/home', ModalRoute.withName('/home'));
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('login_msg')!, "OK");
        } else {
          ToastMessage.showColoredToast(json["message"], "ERROR");
          setFinishWorking(true);
        }
      } catch (e) {
        ToastMessage.showColoredToast(
            LocalizationUtil.translate("lblLoginFailed")!, "ERROR");
        setFinishWorking(true);
      } finally {
        setFinishWorking(true);
      }
    } else {
      // showSnackBar(LocalizationUtil.translate('internetmsg')!, context);
    }
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void _toggle() {
    setState(() {
      _isObsecure = !_isObsecure;
    });
  }
}
