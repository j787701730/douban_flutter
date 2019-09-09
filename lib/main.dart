import 'package:douban_flutter/pages/group.dart';
import 'package:douban_flutter/pages/index.dart';
import 'package:douban_flutter/pages/profile.dart';
import 'package:douban_flutter/pages/shiji.dart';
import 'package:douban_flutter/pages/subject.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class NoSplashFactory extends InteractiveInkFeatureFactory {
  const NoSplashFactory();

  @override
  InteractiveInkFeature create(
      {MaterialInkController controller,
      RenderBox referenceBox,
      Offset position,
      Color color,
      TextDirection textDirection,
      bool containedInkWell = false,
      rectCallback,
      BorderRadius borderRadius,
      ShapeBorder customBorder,
      double radius,
      onRemoved}) {
    return new NoSplash(
      controller: controller,
      referenceBox: referenceBox,
    );
  }
}

class NoSplash extends InteractiveInkFeature {
  NoSplash({
    @required MaterialInkController controller,
    @required RenderBox referenceBox,
  })  : assert(controller != null),
        assert(referenceBox != null),
        super(
          controller: controller,
          referenceBox: referenceBox,
        );

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {}
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;
  DateTime _lastPressedAt; //上次点击时间

  List nav = [Home(), Subject(), Group(), ShiJi(), Profile()];
  var _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _pageChanged(int index) {
//    print('_pageChanged');
    if (mounted)
      setState(() {
        if (_tabIndex != index) _tabIndex = index;
      });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffffffff),
//          image: DecorationImage(
//              alignment: Alignment.topCenter,
//              image: AssetImage('images/${Provider.of<ProviderModel>(context).topBackground}'))
      ),
      child: WillPopScope(
          onWillPop: () async {
            Toast.show("再按一次退出app", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            if (_lastPressedAt == null ||
                DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
              //两次点击间隔超过1秒则重新计时
              _lastPressedAt = DateTime.now();
              return false;
            }
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
//      appBar: AppBar(
//        title: Text(widget.title),
//      ),
            body: PageView.builder(
                //要点1
                physics: NeverScrollableScrollPhysics(),
                //禁止页面左右滑动切换
                controller: _pageController,
                onPageChanged: _pageChanged,
                //回调函数
                itemCount: nav.length,
                itemBuilder: (context, index) => nav[index]),
            bottomNavigationBar: Theme(
                data: ThemeData(splashFactory: NoSplashFactory(), highlightColor: Color(0xffff)),
                child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: Color(0xffEBEBEB), width: 1))),
                  child: BottomNavigationBar(
                    elevation: 0,
                    selectedFontSize: 10,
                    unselectedFontSize: 10,
//                    showSelectedLabels: false,
//                    showUnselectedLabels: false,
                    type: BottomNavigationBarType.fixed,
//                    backgroundColor: Color(0x00ffffff),
                    selectedItemColor: Color(0xff42BD56),
                    unselectedItemColor: Color(0xff999999),
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            _tabIndex == 0
                                ? 'images/ic_tab_home_active.webp'
                                : 'images/ic_tab_home_normal.webp',
                            width: 38,
                            height: 38,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text(
                            '首页',
                          )),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            _tabIndex == 1
                                ? 'images/ic_tab_subject_active.webp'
                                : 'images/ic_tab_subject_normal.webp',
                            width: 38,
                            height: 38,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text(
                            '书影音',
                          )),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            _tabIndex == 2
                                ? 'images/ic_tab_group_active.webp'
                                : 'images/ic_tab_group_normal.webp',
                            width: 38,
                            height: 38,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text(
                            '小组',
                          )),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            _tabIndex == 3
                                ? 'images/ic_tab_shiji_active.webp'
                                : 'images/ic_tab_shiji_normal.webp',
                            width: 38,
                            height: 38,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text('市集')),
                      BottomNavigationBarItem(
                          icon: Image.asset(
                            _tabIndex == 4
                                ? 'images/ic_tab_profile_active.webp'
                                : 'images/ic_tab_profile_normal.webp',
                            width: 38,
                            height: 38,
                            fit: BoxFit.fitHeight,
                          ),
                          title: Text('我的')),
                    ],
                    currentIndex: _tabIndex,
                    onTap: (index) {
                      if (mounted)
                        setState(() {
                          _tabIndex = index;
                        });
                      _pageController.jumpToPage(index);
                    },
                  ),
                )),
          )),
    );
  }
}
