import 'dart:async';
import 'dart:convert';
import 'package:baseapp/enums/ErrorCode.dart';
import 'package:baseapp/enums/MessageType.dart';
import 'package:baseapp/commons/ConstValue.dart';
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

class ConfirmSignUpPage extends StatefulWidget {
  ConfirmSignUpPage({super.key, required this.email});

  String email = "";

  @override
  ConfirmSignUpPageState createState() => ConfirmSignUpPageState();
}

class ConfirmSignUpPageState extends State<ConfirmSignUpPage>
    with TickerProviderStateMixin {
  bool finishLoading = false;
  bool _isNetworkAvail = true;
  final TextEditingController codeEdit = TextEditingController();
  FocusNode codeFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? codeConfirm = "";

  late Timer timerCountDown;
  Duration duration = Duration(minutes: 2);

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timerCountDown = new Timer.periodic(
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

  void showInSnackBar(String value) {}

  @override
  void initState() {
    super.initState();
    fnGetCodeConfirmInEmail(context);
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
              title: LocalizationUtil.translate("lblConfirmSignUp"),
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
                      focusNode: codeFocus,
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
                      textController: codeEdit,
                      onFieldSubmitFunc: (v) {},
                      hintLabel: LocalizationUtil.translate('CodeConfirm')!),
                ),
                duration.inSeconds <= 0 ? Container(
                  margin: EdgeInsets.only(
                      left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                  child: InkWell(
                      splashColor: Colors.transparent,
                      child: Text(
                        LocalizationUtil.translate('Resend')!,
                        //login_btn
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 10.sp,
                            color: Theme.of(context)
                                .colorScheme
                                .colorHint_TextBox),
                      ),
                      onTap: () async {
                        fnGetCodeConfirmInEmail(context);
                      }),
                ) :  Container(
                  margin: EdgeInsets.only(
                      left: 30.w, right: 30.w, bottom: 1.h, top: 1.h),
                  child: Text(
                    CommonUtil.DislayMMSS(duration),
                    //login_btn
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Theme.of(context)
                            .colorScheme
                            .colorHint_TextBox),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      left: 30.w, right: 30.w, bottom: 1.h, top: 5.h),
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
                          fnConfirmSignUp(context);
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

  Future fnGetCodeConfirmInEmail(BuildContext context) async {
    if (widget.email.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_SendEmailVerifyURL;
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

            if (!mounted) return false;
            Navigator.of(context).pop();

            duration = Duration(minutes: 2);
            startTimer();

            return;
          } else {
            if (!mounted) return false;
            Navigator.of(context).pop();
            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.ERROR);
            setFinishWorking(true);
          }
        } else {
          if (!mounted) return false;
          Navigator.of(context).pop();
          ToastMessage.showColoredToast(
              LocalizationUtil.translate('lblError')!, MessageType.ERROR);
          setFinishWorking(true);
        }
      } catch (e) {
        if (!mounted) return false;
        Navigator.of(context).pop();
        ToastMessage.showColoredToast(
            LocalizationUtil.translate('lblError')!, MessageType.ERROR);
        setFinishWorking(true);
      } finally {
        setFinishWorking(true);
      }
    } else {}
  }

  Future fnConfirmSignUp(BuildContext context) async {
    if (codeEdit.text.isEmpty) {
      ToastMessage.showColoredToast(
          LocalizationUtil.translate('lblEmailEmpty_Message')!,
          MessageType.ERROR);
      return;
    }

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_CheckVerifyEmailURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': widget.email,
        'randomnumber': codeEdit.text.toString(),
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

            ToastMessage.showColoredToast(
                LocalizationUtil.translate(token.message!)!, MessageType.OK);

            setState(() {
              if (mounted) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
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
}
