// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ecommerce_app/tabs/home_tab.dart';
import 'package:ecommerce_app/tabs/saved_tab.dart';
import 'package:ecommerce_app/tabs/search_tab.dart';
import 'package:ecommerce_app/widgets/bottom_tabs.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _tabPageController;
  int _selectedTab = 0;

  @override
  void initState() {
    _tabPageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _tabPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: PageView(
            controller: _tabPageController,
            onPageChanged: (value) {
              setState(() {
                _selectedTab = value;
              });
            },
            children: [
              HomeTab(),
              SearchTab(),
              SavedTab(),
            ],
          )),
          BottamTabs(
            selectedTab: _selectedTab,
            tabPressed: (v) {
              _tabPageController.animateToPage(v,
                  duration: Duration(milliseconds: 300), curve: Curves.ease);
            },
          ),
        ],
      )),
    );
  }
}
