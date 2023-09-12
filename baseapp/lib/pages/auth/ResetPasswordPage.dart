import 'dart:convert';
import 'package:baseapp/enums/ErrorCode.dart';
import 'package:baseapp/enums/MessageType.dart';
import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/pages/auth/ConfirmResetPasswordPage.dart';
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

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> with TickerProviderStateMixin {
  bool finishLoading = false;
  bool _isNetworkAvail = true;
  final TextEditingController emailEdit = TextEditingController();
  FocusNode emailFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  BuildContext? dialogcontext;

  @override
  void initState() {
    super.initState();
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
          title: LocalizationUtil.translate("ResetPassword"),
          background: ThemeColor.colorAppBar_Background,
          foreground: ThemeColor.colorAppBar_Foreground,
          colorFont: ThemeColor.colorAppBar_Font,
          colorIcon: ThemeColor.colorAppBar_Icon,
          onBack: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
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
                  left: 10.w, right: 10.w, bottom: 1.h, top: 2.h),
              child: CustomTextFieldWidget(
                  focusNode: emailFocus,
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
                  textController: emailEdit,
                  onFieldSubmitFunc: (v) {
                  },
                  hintLabel: LocalizationUtil.translate('lblEmail')!),
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
                      LocalizationUtil.translate('Send')!,
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
                      fnSendReset(context);
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

  Future fnSendReset(BuildContext context) async {
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

    _isNetworkAvail = await CommonUtil.IsNetworkAvailable();
    if (_isNetworkAvail) {
      String ulr = ConstValue.api_ForgetPassURL;
      setFinishWorking(false);
      Map<String, String> parameters = {
        'email': emailEdit.text.toString(),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ConfirmResetPasswordPage(email: emailEdit.text)));
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
}
