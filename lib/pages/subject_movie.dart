import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubjectMovie extends StatefulWidget {
  @override
  _SubjectMovieState createState() => _SubjectMovieState();
}

class _SubjectMovieState extends State<SubjectMovie>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getRecommend('');
    _getRecommend2('');
    _getRecommend3('');
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int start = 0;
  bool showTab = false;
  Map movieSubjectEntrances = {}; // 头部导航栏
  List movieShowing = []; // 影院热映
  List movieSoon = []; // 即将上映
  List movieHotGaia = []; // 豆瓣热门
  Map movieSelectedCollections = {}; // 豆瓣榜单
  Map todayPlays = {}; // 今日
  List weekPlays = []; // 一周推荐

  // 一堆数据
  _getRecommend(type) async {
//    setState(() {
//      recommend.clear();
//    });
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/movie/modules?loc_id=118200&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&_sig=yy%2F%2F6KHYjXRaGuRoeF4WYiMhsXs%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
//          movie = response.data['modules'];
          for (var o in response.data['modules']) {
            if (o['module_name'] == 'movie_subject_entrances') {
              movieSubjectEntrances = o;
            } else if (o['module_name'] == 'movie_showing') {
              movieShowing = o['data']['subject_collection_boards'][0]['items']
                  .sublist(0, 6);
            } else if (o['module_name'] == 'movie_soon') {
              movieSoon = o['data']['subject_collection_boards'][0]['items']
                  .sublist(0, 6);
            } else if (o['module_name'] == 'movie_hot_gaia') {
              movieHotGaia = o['data']['subject_collection_boards'][0]['items'];
            } else if (o['module_name'] == 'movie_selected_collections') {
              movieSelectedCollections = o;
            }
          }
        });
      }
    } catch (e) {
//      return print(e);
    }
  }

  // 一周可播等
  _getRecommend2(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/movie/recommend?tags=&playable=0&start=$start&count=8&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=%2FzYhb8OxfAQ0yJr%2FdqOOLDJzua0%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          weekPlays.addAll(response.data['items']);
//          print(jsonEncode(response.data));
        });
        if (type == 'load') {
          _refreshController.loadComplete();
        }
      }
    } catch (e) {
//      return print(e);
    }
  }

  // 今日可播
  _getRecommend3(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/skynet/playlist/recommend/event_videos?count=3&out_skynet=true&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=RpzOOLH6BOcWswisTvA85qk8riM%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          todayPlays = response.data;
//          print(jsonEncode(response.data));
        });
      }
    } catch (e) {
//      return print(e);
    }
  }

  void _onLoading() async {
    setState(() {
      start += 8;
      _getRecommend2('load');
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = MediaQuery.of(context).size.width;
    return SmartRefresher(
      enablePullDown: false,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onLoading: _onLoading,
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          movieSubjectEntrances.isEmpty
              ? Container()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: movieSubjectEntrances['data']['subject_entraces']
                        .map<Widget>((item) {
                      return Container(
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: '${item['icon']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                '${item['title']}',
                                style: TextStyle(height: 1.5),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
          todayPlays.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 15),
                  height: 180,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: 15,
                          left: 0,
                          width: width - 30,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff4C4C4C),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                            height: 164,
                          )),
                      Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.event_seat,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  ' 看电影',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          )),
                      Positioned(
                          top: 20,
                          left: 70,
                          width: 98,
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${todayPlays['videos'][2]['pic']['large']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                fit: BoxFit.cover,
                              ))),
                      Positioned(
                          top: 10,
                          left: 45,
                          width: 108,
                          height: 160,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl:
                                    '${todayPlays['videos'][1]['pic']['large']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    new Icon(Icons.error),
                                fit: BoxFit.cover,
                              ))),
                      Positioned(
                          top: 0,
                          left: 20,
                          width: 118,
                          height: 170,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${todayPlays['videos'][0]['pic']['large']}',
                              placeholder: (context, url) => new Container(
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  new Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          )),
                      Positioned(
                          top: 60,
                          left: 200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '今日可播放电影已更新',
                                style: TextStyle(
                                    color: Colors.white,
                                    height: 1.5,
                                    fontSize: 16),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '全部 ${todayPlays['total']}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white,
                                  )
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Color(0xff999999), width: 1))),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTab = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: !showTab
                                    ? Colors.black
                                    : Colors.transparent,
                                width: 2))),
                    child: Text(
                      '影院热映',
                      style: TextStyle(
                        color: !showTab ? Colors.black : Color(0xff808080),
                        fontSize: 20,
                        fontWeight:
                            !showTab ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showTab = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    showTab ? Colors.black : Colors.transparent,
                                width: 2))),
                    child: Text(
                      '即将上映',
                      style: TextStyle(
                        color: showTab ? Colors.black : Color(0xff808080),
                        fontSize: 20,
                        fontWeight:
                            showTab ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          movieShowing.isEmpty
              ? Container()
              : Offstage(
                  offstage: showTab,
                  child: Container(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: movieShowing.map<Widget>((item) {
                        return Container(
                          width: (width - 20 - 20) / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: (width - 20 - 20) / 2 * 810 / 540,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                        child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      child: CachedNetworkImage(
                                        imageUrl: '${item['cover']['url']}',
                                        placeholder: (context, url) =>
                                            new Container(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                        width: (width - 20 - 20) / 2,
                                        height:
                                            (width - 20 - 20) / 2 * 810 / 540,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                    Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          color: Color(0x99dddddd),
                                          child: Center(
                                            child: Image.asset(
                                              'images/ic_skynet_add.webp',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  '${item['title']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Text(
                                  '${item['rating'] == null ? '' : item['rating']['value']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xff808080)),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
          movieSoon.isEmpty
              ? Container()
              : Offstage(
                  offstage: !showTab,
                  child: Container(
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 15,
                      children: movieSoon.map<Widget>((item) {
                        return Container(
                          width: (width - 20 - 20) / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                height: (width - 20 - 20) / 2 * 810 / 540,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                        child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      child: CachedNetworkImage(
                                        imageUrl: '${item['cover']['url']}',
                                        placeholder: (context, url) =>
                                            new Container(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                        width: (width - 20 - 20) / 2,
                                        height:
                                            (width - 20 - 20) / 2 * 810 / 540,
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                    Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          color: Color(0x99dddddd),
                                          child: Center(
                                            child: Image.asset(
                                              'images/ic_skynet_add.webp',
                                              width: 30,
                                              height: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: Text(
                                  '${item['title']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(bottom: 5),
                                child: Text(
                                  '${item['wish_count']}人想看',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Color(0xff999999)),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.red, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                padding: EdgeInsets.only(
                                    top: 1, bottom: 1, left: 6, right: 6),
                                child: Text(
                                  '${item['release_date']}'
                                          .replaceAll('.', '月') +
                                      '日',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.red),
                                ),
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '豆瓣热门',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          movieHotGaia.isEmpty
              ? Container()
              : Container(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    children: movieHotGaia.map<Widget>((item) {
                      return Container(
                        width: (width - 20 - 20) / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: (width - 20 - 20) / 2 * 810 / 540,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                      child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6)),
                                    child: CachedNetworkImage(
                                      imageUrl: '${item['cover']['url']}',
                                      placeholder: (context, url) =>
                                          new Container(
                                        child: Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                      width: (width - 20 - 20) / 2,
                                      height: (width - 20 - 20) / 2 * 810 / 540,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                                  Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        color: Color(0x99dddddd),
                                        child: Center(
                                          child: Image.asset(
                                            'images/ic_skynet_add.webp',
                                            width: 30,
                                            height: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                '${item['title']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                '${item['rating'] == null ? '' : item['rating']['value']}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Color(0xff808080)),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '豆瓣榜单',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          movieSelectedCollections.isEmpty
              ? Container()
              : Container(
                  height: 340,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: movieSelectedCollections['data']
                            ['selected_collections']
                        .map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: movieSelectedCollections['data']
                                            ['selected_collections']
                                        .indexOf(item) ==
                                    0
                                ? 0
                                : 15),
                        width: width * 0.618,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6)),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        '${item['header_bg_image']}'),
                                    fit: BoxFit.cover),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: Text(
                                      '${item['description']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Text(
                                      '${item['name']}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: width * 0.618,
                              padding:
                                  EdgeInsets.only(top: 10, left: 15, right: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                      bottomRight: Radius.circular(6)),
                                  color: Color(int.tryParse(
                                      '0xff${item['background_color_scheme']['primary_color_light']}'))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: item['items'].map<Widget>((list) {
                                  return Container(
                                    child: RichText(
                                      text: TextSpan(
                                          text:
                                              '${item['items'].indexOf(list) + 1}. ',
                                          style: TextStyle(
                                              fontSize: 16, height: 1.2),
                                          children: <TextSpan>[
                                            TextSpan(text: '${list['title']}'),
                                            TextSpan(
                                                text:
                                                    ' ${list['rating'] == null ? '' : list['rating']['value']}',
                                                style: TextStyle(
                                                    color: Color(0xffF4A833))),
                                          ]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
          weekPlays.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6)),
                          child: CachedNetworkImage(
                            imageUrl: '${weekPlays[0]['cover_url']}',
                            placeholder: (context, url) => new Container(
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                            width: (width - 20),
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        width: width - 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6),
                              bottomRight: Radius.circular(6)),
//                            color: Color(int.tryParse(
//                                '0xff${weekPlays[0]['color_scheme']['primary_color_light']}'))
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${weekPlays[0]['subtitle']}',
                              style: TextStyle(
                                  color: Color(0xff657580), fontSize: 24),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.play_circle_filled,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                Text(
                                  '${weekPlays[0]['title']}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 30),
                                )
                              ],
                            ),
                            Text(
                              '共${weekPlays[0]['items_count']}部片',
                              style: TextStyle(
                                  color: Color(0xffA4AEB4), fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: weekPlays.map<Widget>((item) {
                            return weekPlays.indexOf(item) == 0
                                ? Container()
                                : item['comment'] == null
                                    ? Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CachedNetworkImage(
                                              imageUrl: '${item['cover_url']}',
                                              placeholder: (context, url) =>
                                                  new Container(
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      new Icon(Icons.error),
                                              width: (width - 20),
                                              height: 290,
                                              fit: BoxFit.cover,
                                            ),
                                            Text(
                                              '${item['subtitle']}',
                                              style: TextStyle(
                                                  color: Color(0xffBDBDBD),
                                                  height: 1.5),
                                            ),
                                            Text(
                                              '${item['title']}',
                                              style: TextStyle(fontSize: 26),
                                            ),
                                            Text(
                                              '共${item['items_count']}部',
                                              style: TextStyle(
                                                  color: Color(0xffBDBDBD),
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                item['pic'] == null
                                                    ? Container()
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '${item['pic']['normal']}',
                                                        placeholder:
                                                            (context, url) =>
                                                                new Container(
                                                          child: Center(
                                                            child:
                                                                CupertinoActivityIndicator(),
                                                          ),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            new Icon(
                                                                Icons.error),
                                                        width:
                                                            (width - 20) * 0.3,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      ),
                                                item['photos'] == null
                                                    ? Container()
                                                    : Expanded(
                                                        child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: item['pic'] ==
                                                                    null
                                                                ? 0
                                                                : 15),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: item[
                                                                      'photos']
                                                                  .isEmpty
                                                              ? ''
                                                              : '${item['photos'][0]}',
                                                          placeholder:
                                                              (context, url) =>
                                                                  new Container(
                                                            child: Center(
                                                              child:
                                                                  CupertinoActivityIndicator(),
                                                            ),
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                          width: (width - 20) *
                                                              0.3,
                                                          height: 200,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ))
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      RichText(
                                                        text: TextSpan(
                                                            text:
                                                                '${item['title']}',
                                                            style: TextStyle(color: Colors.black, fontSize: 18),
                                                            children: <TextSpan>[
                                                              TextSpan(
                                                                  text:
                                                                      '(${item['year']})')
                                                            ]),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                          '${item['rating'] == null ? '' : item['rating']['value']}'),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Column(
                                                    children: <Widget>[
                                                      Image.asset(
                                                        'images/ic_info_wish.webp',
                                                        width: 30,
                                                      ),
                                                      Text(
                                                        '想看',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xffFF9E0A)),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 6,
                                            ),
                                            Text(
                                                '${item['comment']['comment']}--${item['comment']['user']['name']}'),
                                            Container(
                                              height: 6,
                                            ),
                                            Wrap(
                                              spacing: 10,
                                              runSpacing: 4,
                                              children: item['tags']
                                                  .map<Widget>((tag) {
                                                return Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      color: Color(0xffF7EFE4)),
                                                  padding: EdgeInsets.only(
                                                      top: 3,
                                                      bottom: 3,
                                                      left: 6,
                                                      right: 6),
                                                  child: Text(
                                                    '${tag['name']} >',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff6E4A11)),
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          ],
                                        ),
                                      );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
