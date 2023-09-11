import 'package:baseapp/commons/ConstValue.dart';
import 'package:baseapp/commons/Session.dart';
import 'package:flutter/cupertino.dart';
import '../commons/Constant.dart';

class MenuModel {
  int menuID;
  String  menuType;
  String nameMenu;
  IconData iconMenu;
  Color colorMenu;
  String imageName;
  Function function;
  MenuModel(this.nameMenu, this.iconMenu, this.colorMenu, this.imageName,
      this.function, this. menuID, this.menuType){
        var tempFunction = function;
        function = () async {
          await tempFunction();
          var listID  = ConstValue.recentMenuIDStr.split(",");
          listID.removeWhere((element) => element == menuID.toString());
          listID.insert(0,menuID.toString());
          ConstValue.recentMenuIDStr = listID.join(",");
          setPrefrence(Key_ListRecentMenu, ConstValue.recentMenuIDStr);
        };
  }


}
