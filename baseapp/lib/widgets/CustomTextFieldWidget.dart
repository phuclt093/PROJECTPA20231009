import 'package:baseapp/commons/ThemeValue.dart';
import 'package:flutter/material.dart';
import 'package:baseapp/utils/LocalizationUtil.dart';

class CustomTextFieldWidget extends StatelessWidget {
  CustomTextFieldWidget({super.key,
    this.focusNode,
    required this.onChangeFunc,
    this.colorFont,
    this.colorFontHint,
    this.textController,
    required this.onFieldSubmitFunc,
    this.hintLabel,
    this.colorBorderEnabled,
    this.colorBorderFocus,
    this.borderRadius,
    this.coloBackground});

  //Variables
  FocusNode? focusNode;
  Color? colorFont;
  Color? colorFontHint;
  TextEditingController? textController;
  final Function(String? value) onChangeFunc;
  final Function(String? value) onFieldSubmitFunc;
  String? hintLabel = "";
  Color? coloBackground;
  Color? colorBorderEnabled;
  Color? colorBorderFocus;
  double? borderRadius;

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      style: Theme
          .of(context)
          .textTheme
          .subtitle1
          ?.copyWith(
          color: colorFont,
          fontWeight: FontWeight.bold),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return LocalizationUtil.translate('username_required')!;
        }
      },
      onChanged: onChangeFunc,
      controller: textController,
      onFieldSubmitted: onFieldSubmitFunc,
      decoration: InputDecoration(
        hintText: hintLabel!,
        hintStyle: Theme
            .of(context)
            .textTheme
            .subtitle1
            ?.copyWith(
            color: colorFontHint
        ),
        filled: true,
        fillColor: Theme
            .of(context)
            .colorScheme
            .colorBackground_TextBox
            .withOpacity(0.7),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: colorBorderFocus!),
          borderRadius:
          BorderRadius.circular(borderRadius!),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: colorBorderEnabled!),
          borderRadius:
          BorderRadius.circular(borderRadius!),
        ),
      ),
    );
  }

  @override
  void dispose() {
  }
}
