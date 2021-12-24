// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, missing_required_param

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageSwipe extends StatefulWidget {
  final List imageList;

  ImageSwipe({this.imageList});

  @override
  _ImageSwipeState createState() => _ImageSwipeState();
}

class _ImageSwipeState extends State<ImageSwipe> {
  int _selectPage = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        child: Stack(
          children: [
            PageView(
              onPageChanged: (value) {
                setState(() {
                  _selectPage = value;
                });
              },
              children: [
                for (var i = 0; i < widget.imageList.length; i++)
                  Container(
                    child: Image.network(
                      widget.imageList[i],
                      fit: BoxFit.cover,
                    ),
                  ),
              ],
            ),
            Positioned(
              bottom: 24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < widget.imageList.length; i++)
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      height: 10,
                      width: _selectPage == i ? 30 : 10,
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12)),
                    )
                ],
              ),
            )
          ],
        ));
  }
}
