// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:ecommerce_app/screen/constants.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hinttext;
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final FocusNode focusNode;
  final TextInputAction textInputAction;
  final bool isPasswordField;

  CustomInput(
      {this.hinttext,
      this.onChanged,
      this.onSubmitted,
      this.focusNode,
      this.textInputAction,
      this.isPasswordField});

  @override
  Widget build(BuildContext context) {
    bool _isPasswordFiled = isPasswordField ?? false;
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
            color: Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(12)),
        child: TextField(
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          focusNode: focusNode,
          textInputAction: textInputAction,
          obscureText: _isPasswordFiled,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext ?? 'hintText..',
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
          style: Constants.regularDarktext,
        ));
  }
}
