import 'package:douban_flutter/pages/subject_book.dart';
import 'package:douban_flutter/pages/subject_city.dart';
import 'package:douban_flutter/pages/subject_movie.dart';
import 'package:douban_flutter/pages/subject_music.dart';
import 'package:douban_flutter/pages/subject_novel.dart';
import 'package:douban_flutter/pages/subject_tv.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// 书影音
class Subject extends StatefulWidget {
  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> with SingleTickerProviderStateMixin {
  TabController controller;

  var tabs = <Tab>[
    Tab(
      text: "电影",
    ),
    Tab(
      text: "电视",
    ),
    Tab(
      text: "读书",
    ),
    Tab(
      text: "原创小说",
    ),
    Tab(
      text: "音乐",
    ),
    Tab(
      text: "同城",
    ),
  ];

  PageController _pageController;
  var tabView = [
    SubjectMovie(),
    SubjectTV(),
    SubjectBook(),
    SubjectNovel(),
    SubjectMusic(),
    SubjectCity()
  ];

  @override
  void initState() {
    super.initState();
    controller = TabController(initialIndex: 0, length: tabs.length, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          '书影音',
          style: TextStyle(color: Colors.black),
        ),
        bottom: TabBar(
          controller: controller,
          tabs: tabs,
          labelColor: Colors.black,
          unselectedLabelColor: Color(0xff999999),
          indicatorColor: Colors.black,
          labelPadding: EdgeInsets.zero,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: tabView,
//        onPageChanged: (index) {
//          controller.animateTo(index);
//        },
      ),
    );
  }
}
