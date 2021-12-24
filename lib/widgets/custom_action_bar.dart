// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/screen/cart_page.dart';

import 'package:ecommerce_app/screen/constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomActionBar extends StatelessWidget {
  final String title;
  final bool hasBackArrow;
  final bool hastitle;
  final bool hasgradient;

  CustomActionBar(
      {this.title, this.hasBackArrow, this.hastitle, this.hasgradient});

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    bool _hasBackArrow = hasBackArrow ?? false;
    bool _hastitle = hastitle ?? true;
    bool _hasgradient = hasgradient ?? true;

    User _user = FirebaseAuth.instance.currentUser;

    return Container(
      decoration: _hasgradient
          ? BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0)],
                  begin: Alignment(0, 0),
                  end: Alignment(0, 1)))
          : null,
      padding: EdgeInsets.only(top: 16, left: 22, right: 24, bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_hasBackArrow)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: Image(
                  image: AssetImage(
                    'assets/images/back_arrow.png',
                  ),
                  height: 16,
                  width: 16,
                ),
              ),
            ),
          if (_hastitle)
            Text(
              title ?? 'ActionBar',
              style: Constants.boldHeading,
            ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
            child: Container(
                alignment: Alignment.center,
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: StreamBuilder(
                  stream:
                      _userRef.doc(_user.uid).collection('Cart').snapshots(),
                  builder: (context, snapshot) {
                    int _totalitem = 0;
                    if (snapshot.connectionState == ConnectionState.active) {
                      List _documentData = snapshot.data.docs;
                      _totalitem = _documentData.length;
                    }
                    return Text(
                      "$_totalitem" ?? '0',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
