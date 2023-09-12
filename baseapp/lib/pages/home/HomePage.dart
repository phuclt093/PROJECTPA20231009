import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/utils/DialogUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';
import 'package:baseapp/commons/ThemeValue.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/CommonUtil.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool finishLoading = false;
  bool isCheckedRememberMe = true;
  bool _isNetworkAvail = true;
  final TextEditingController userNameEdit = TextEditingController();
  final TextEditingController passWordEdit = TextEditingController();
  final TextEditingController passWordConfirmEdit = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode passwordConfirmFocus = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext? dialogcontext;

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
          ConstValue.url_AssetMainBackground,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          // drawer: Drawer(
          //     child: MainDrawer(
          //       colorBackgroundTop: ThemeColor.colorBackground_TopDrawer,
          //       fontSize: 10.sp,
          //       fontSizeMenu: 14.sp,
          //       iconSizeMenu: 18.sp,
          //       parentContext: context,
          //       callback: () {
          //         setState(() {});
          //       },
          //     )),
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          appBar: CommonUtil.SetHomeAppBar(
              scaffoldKey: _scaffoldKey,
              context: context,
              fontSize: 18.sp,
              iconSize: 26.sp,
              title: LocalizationUtil.translate("Home"),
              background: ThemeColor.colorAppBar_Background,
              foreground: ThemeColor.colorAppBar_Foreground,
              colorFont: ThemeColor.colorAppBar_Font,
              colorIcon: ThemeColor.colorAppBar_Icon,
              onBack: () {
                // DialogUtil.ShowLogoutDialog(context);
              }),
          body: const SingleChildScrollView(
              child: Align(
                child: Column(
                  children: <Widget>[],
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
}