// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final Function onpressed;
  final bool outlineBtn;
  final bool isLoading;
  const CustomBtn({this.text, this.onpressed, this.outlineBtn, this.isLoading});

  @override
  Widget build(BuildContext context) {
    bool _outlineBtn = outlineBtn ?? false;
    bool _isLoading = isLoading ?? false;
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        height: 60,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
            color: _outlineBtn ? Colors.transparent : Colors.black,
            border: Border.all(
              color: Colors.black,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Stack(
          children: [
            Visibility(
              visible: _isLoading ? false : true,
              child: Center(
                child: Text(text ?? 'text',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _outlineBtn ? Colors.black : Colors.white)),
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                  child: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator())),
            )
          ],
        ),
      ),
    );
  }
}
