// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, use_key_in_widget_constructors, empty_constructor_bodies, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BottamTabs extends StatefulWidget {
  final int selectedTab;
  final Function(int) tabPressed;
  BottamTabs({this.selectedTab, this.tabPressed});
  @override
  State<BottamTabs> createState() => _BottamTabsState();
}

class _BottamTabsState extends State<BottamTabs> {
  int _selectedtab = 0;

  @override
  Widget build(BuildContext context) {
    _selectedtab = widget.selectedTab ?? 0;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 30)
          ],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          BottomTabBtn(
            btnname: 'assets/images/tab_home.png',
            isSelected: _selectedtab == 0 ? true : false,
            onpressed: () {
              widget.tabPressed(0);
            },
          ),
          BottomTabBtn(
            btnname: 'assets/images/tab_search.png',
            isSelected: _selectedtab == 1 ? true : false,
            onpressed: () {
              widget.tabPressed(1);
            },
          ),
          BottomTabBtn(
            btnname: 'assets/images/tab_saved.png',
            isSelected: _selectedtab == 2 ? true : false,
            onpressed: () {
              widget.tabPressed(2);
            },
          ),
          BottomTabBtn(
            btnname: 'assets/images/tab_logout.png',
            isSelected: _selectedtab == 3 ? true : false,
            onpressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}

class BottomTabBtn extends StatelessWidget {
  final String btnname;
  final bool isSelected;
  final Function onpressed;

  BottomTabBtn({this.btnname, this.isSelected, this.onpressed});

  @override
  Widget build(BuildContext context) {
    bool _isSelected = isSelected ?? false;

    return GestureDetector(
      onTap: onpressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(
              color: _isSelected
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.transparent,
              width: 2),
        )),
        child: Image(
          image: AssetImage(
            btnname ?? 'assets/images/tab_home.png',
          ),
          width: 24,
          height: 24,
          color: _isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.black,
        ),
      ),
    );
  }
}
