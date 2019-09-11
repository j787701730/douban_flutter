import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubjectTV extends StatefulWidget {
  @override
  _SubjectTVState createState() => _SubjectTVState();
}

class _SubjectTVState extends State<SubjectTV> {
  @override
  void initState() {
    super.initState();
    _getRecommend('');
    _getRecommend2('');
    _getRecommend3('');
  }

  int tvType = 0;
  int showType = 0;

  List tvList = [
    '综合',
    '国产剧',
    '英美剧',
    '日剧',
    '韩剧',
    '动画',
  ];

  List showList = [
    '综合',
    '国内',
    '国外',
  ];

  Map tvSubjectEntrances = {}; // 头部导航栏
  List tvHot = []; // 热播新剧 综合
  List tvDomestic = []; // 热播新剧 国产剧
  List tvAmerican = []; // 热播新剧 英美剧
  List tvJapanese = []; // 热播新剧 日剧
  List tvKorean = []; // 热播新剧 韩剧
  List tvAnimation = []; // 热播新剧 动画

  List showHot = []; // 综艺 综合
  List showDomestic = []; // 综艺 国内
  List showForeign = []; // 综艺 国外

  List tvSelectedCollections = []; // 豆瓣榜单
  List tvComingCoon = []; // 即将播出

  List hotChannels = []; // 分类预览
  List recommendTVs = []; // 为你推荐的

  // 一堆数据
  _getRecommend(type) async {
//    setState(() {
//      recommend.clear();
//    });
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/tv/modules?udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=0Ajo5nnfXSyP8BHVKT2AWWB45TA%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
//          movie = response.data['modules'];
          for (var o in response.data['modules']) {
            if (o['module_name'] == 'tv_subject_entrances') {
              tvSubjectEntrances = o;
            } else if (o['module_name'] == 'tv_hot') {
              tvHot = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_domestic') {
              tvDomestic = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_american') {
              tvAmerican = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_japanese') {
              tvJapanese = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_korean') {
              tvKorean = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_animation') {
              tvAnimation = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'show_hot') {
              showHot = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'show_domestic') {
              showDomestic = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'show_foreign') {
              showForeign = o['data']['subject_collection_boards'][0]['items'].sublist(0, 9);
            } else if (o['module_name'] == 'tv_selected_collections') {
              tvSelectedCollections = o['data']['selected_collections'];
            } else if (o['module_name'] == 'tv_coming_soon') {
              tvComingCoon = o['data']['items'];
            }
          }
//          print(jsonEncode(response.data));
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  int start = 0;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  // 为你推荐的
  _getRecommend2(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/tv/suggestion?start=$start&count=10&new_struct=1&with_review=1&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=9IeY00oMh78OgsqOTWrogYXaWaQ%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          recommendTVs.addAll(response.data['items']);
//          print(jsonEncode(response.data));
        });
        if (type == 'load') {
          _refreshController.loadComplete();
        }
      }
    } catch (e) {
      return print(e);
    }
  }

  // 分类预览
  _getRecommend3(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/tv/hot_channels?udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=FQhINhuyB0EHBTZbuKlDT0LZeQc%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          hotChannels = response.data;
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  void _onLoading() async {
    setState(() {
      start += 8;
      _getRecommend2('load');
    });
  }

  _commonWidget(data, width) {
    return Container(
      child: Wrap(
        spacing: 10,
        runSpacing: 15,
        children: data.map<Widget>((item) {
          return Container(
            width: (width - 30 - 20) / 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: (width - 30 - 20) / 3 * 810 / 540,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        child: CachedNetworkImage(
                          imageUrl: '${item['cover']['url']}',
                          placeholder: (context, url) => new Container(
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                          width: (width - 30 - 20) / 3,
                          height: (width - 30 - 20) / 3 * 810 / 540,
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
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    '${item['title']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  child: Text(
                    '${item['rating'] == null ? '' : item['rating']['value']}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, color: Color(0xff808080)),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: ListView(padding: EdgeInsets.all(15),children: <Widget>[
          tvSubjectEntrances.isEmpty
              ? Container()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: tvSubjectEntrances['data']['subject_entraces'].map<Widget>((item) {
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
                                errorWidget: (context, url, error) => new Icon(Icons.error),
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
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '热播新剧',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff999999), width: 1))),
            child: Row(
              children: tvList.map<Widget>((item) {
                int idx = tvList.indexOf(item);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      tvType = idx;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: tvType == idx ? Colors.black : Colors.transparent,
                                width: 4))),
                    child: Text(
                      '$item',
                      style: TextStyle(
                        color: tvType == idx ? Colors.black : Color(0xff808080),
                        fontSize: 22,
                        fontWeight: tvType == idx ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          tvHot.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 0 ? false : true,
                  child: _commonWidget(tvHot, width),
                ),
          tvDomestic.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 1 ? false : true,
                  child: _commonWidget(tvDomestic, width),
                ),
          tvAmerican.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 2 ? false : true,
                  child: _commonWidget(tvAmerican, width),
                ),
          tvJapanese.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 3 ? false : true,
                  child: _commonWidget(tvJapanese, width),
                ),
          tvKorean.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 4 ? false : true,
                  child: _commonWidget(tvKorean, width),
                ),
          tvAnimation.isEmpty
              ? Container()
              : Offstage(
                  offstage: tvType == 5 ? false : true,
                  child: _commonWidget(tvAnimation, width),
                ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '热播综艺',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xff999999), width: 1))),
            child: Row(
              children: showList.map<Widget>((item) {
                int idx = showList.indexOf(item);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      showType = idx;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: showType == idx ? Colors.black : Colors.transparent,
                                width: 4))),
                    child: Text(
                      '$item',
                      style: TextStyle(
                        color: showType == idx ? Colors.black : Color(0xff808080),
                        fontSize: 22,
                        fontWeight: showType == idx ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          showHot.isEmpty
              ? Container()
              : Offstage(
                  offstage: showType == 0 ? false : true,
                  child: _commonWidget(showHot, width),
                ),
          showDomestic.isEmpty
              ? Container()
              : Offstage(
                  offstage: showType == 1 ? false : true,
                  child: _commonWidget(showDomestic, width),
                ),
          showForeign.isEmpty
              ? Container()
              : Offstage(
                  offstage: showType == 2 ? false : true,
                  child: _commonWidget(showForeign, width),
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
          tvSelectedCollections.isEmpty
              ? Container()
              : Container(
                  height: 340,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: tvSelectedCollections.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: tvSelectedCollections.indexOf(item) == 0 ? 0 : 15),
                        width: width * 0.618,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 220,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                                image: DecorationImage(
                                    image: NetworkImage('${item['header_bg_image']}'),
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
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              width: width * 0.618,
                              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
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
                                          text: '${item['items'].indexOf(list) + 1}. ',
                                          style: TextStyle(fontSize: 16, height: 1.2),
                                          children: <TextSpan>[
                                            TextSpan(text: '${list['title']}'),
                                            TextSpan(
                                                text:
                                                    ' ${list['rating'] == null ? '' : list['rating']['value']}',
                                                style: TextStyle(color: Color(0xffF4A833))),
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
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '分类浏览',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          hotChannels.isEmpty
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${hotChannels[0]['channel']['reason_data']['tpl']} >',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    _commonWidget(hotChannels[0]['items'].sublist(0, 6), width),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, top: 10),
                      child: Text(
                        '${hotChannels[1]['channel']['reason_data']['tpl']} >',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    _commonWidget(hotChannels[1]['items'].sublist(0, 6), width),
                  ],
                ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '即将播出剧集',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          tvComingCoon.isEmpty
              ? Container()
              : Container(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: tvComingCoon.map<Widget>((item) {
                      return Container(
                        width: width * 0.618,
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              child: CachedNetworkImage(
                                imageUrl: '${item['pic']['normal']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                width: 72,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '${item['title']}',
                                    style: TextStyle(fontSize: 20),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            left: BorderSide(color: Color(0xffFF9F0D), width: 2))),
                                    child: Text(
                                      ' ${item['pubdate'].join(', ')}开播',
                                      style: TextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${item['card_subtitle']}',
                                    style: TextStyle(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
            ),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '为你推荐',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          recommendTVs.isEmpty?Container():
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: recommendTVs.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: 15
                        ),
                        padding: EdgeInsets.only(
                          bottom: 10
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color(0xffeeeeee),
                              width: 1
                            )
                          )
                        ),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                              child: CachedNetworkImage(
                                imageUrl: '${item['pic']['normal']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                width: 72,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      text: '${item['title']}',
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '(${item['year']})',
                                          style: TextStyle(
                                            color: Color(0xff999999)
                                          )
                                        )
                                      ],
                                    style: TextStyle(fontSize: 20,color: Colors.black),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text('${item['rating'] == null ? '' : item['rating']['value']}'),
                                  Text(
                                    '${item['card_subtitle']}',
                                    style: TextStyle(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: 6
                                    ),
                                    width: width,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                        color: Color(0xffF7F7F7)),
                                    child: Text(
                                      '你可能感兴趣',
                                      style: TextStyle(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                  }).toList(),
                ),
              )
        ]));
  }
}
