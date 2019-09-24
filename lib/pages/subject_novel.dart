import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import './rating_widget.dart';

class SubjectNovel extends StatefulWidget {
  @override
  _SubjectNovelState createState() => _SubjectNovelState();
}

class _SubjectNovelState extends State<SubjectNovel> {
  @override
  void initState() {
    super.initState();
    _getRecommend('');
    _getRecommend2('');
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  Map arkTopicRec = {}; // 主题推荐
  Map arkSelectedCollections = {}; // 榜单
  Map arkStronglyRec = {}; // 重磅推荐
  Map arkFinalizedWorksSubjectUnion = {}; // 最热完本
  List arkFinalizedWorksSubjectUnionList = [];
  List modules = [];
  int start = 0;
  List topBooks = [];

  // 一堆数据
  _getRecommend(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/ark/modules?udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=KyEhhqxxVuZDPmtfVWifAb8miUA%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
//          movie = response.data['modules'];
          for (var o in response.data['modules']) {
            if (o['module_name'] == 'ark_topic_rec') {
              arkTopicRec = o;
            } else if (o['module_name'] == 'ark_selected_collections') {
              arkSelectedCollections = o;
            } else if (o['module_name'] == 'ark_strongly_rec') {
              arkStronglyRec = o;
            } else if (o['module_name'] == 'ark_finalized_works_subject_union') {
              arkFinalizedWorksSubjectUnion = o;

              for (var o1 in arkFinalizedWorksSubjectUnion['data']['collections']) {
                for (var o3 in response.data['modules']) {
                  if (o1 == o3['module_name']) {
                    arkFinalizedWorksSubjectUnionList.add(o3['data']);
                  }
                }
              }
            }
          }
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  // 一周可播等
  _getRecommend2(type) async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/ark/suggestion?start=$start&count=10&new_struct=1&with_review=1&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=%2FLq10SsCH1Xm9p99km%2BQ%2B3SuByc%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          topBooks.addAll(response.data['items']);
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

  int showType = 0;

  void _onLoading() async {
    setState(() {
      start += 8;
      _getRecommend2('load');
    });
  }

  _strongWidget(width, item) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.only(bottom: 10),
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
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '作者: ${item['author'].join(', ')}',
                  style: TextStyle(fontSize: 12),
                ),
                item['rating'] == null
                    ? Container()
                    : Rating(double.tryParse('${item['rating']['value']}')),
                Container(
                  margin: EdgeInsets.only(top: 6),
                  width: width,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)), color: Color(0xffF7F7F7)),
                  child: Text(
                    '${item['abstract']}',
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
                Text(
                  '${item['abstract']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${item['reading_user_count']}人读过',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
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
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          arkStronglyRec.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${arkStronglyRec['data']['subject_collection_boards'][0]['subject_collection']['name']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          arkStronglyRec.isEmpty
              ? Container()
              : Container(
                  height: 270,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: width * 0.8,
                        child: Column(
                          children: <Widget>[
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][0]),
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][1]),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.8,
                        child: Column(
                          children: <Widget>[
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][2]),
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][3]),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 0.8,
                        child: Column(
                          children: <Widget>[
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][4]),
                            _strongWidget(width,
                                arkStronglyRec['data']['subject_collection_boards'][0]['items'][5]),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
          arkFinalizedWorksSubjectUnion.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${arkFinalizedWorksSubjectUnion['data']['title']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          arkFinalizedWorksSubjectUnionList.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xff999999), width: 1))),
                  child: Row(
                    children: arkFinalizedWorksSubjectUnionList.map<Widget>((item) {
                      int idx = arkFinalizedWorksSubjectUnionList.indexOf(item);
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
                            '${item['subject_collection_boards'][0]['subject_collection']['name']}',
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
          arkFinalizedWorksSubjectUnionList.isEmpty
              ? Container()
              : Container(
                  child: Column(
                    children: arkFinalizedWorksSubjectUnionList.map<Widget>((item) {
                      int idx = arkFinalizedWorksSubjectUnionList.indexOf(item);
                      return Offstage(
                        offstage: showType == idx ? false : true,
                        child: _commonWidget(
                            item['subject_collection_boards'][0]['items'].sublist(0, 6), width),
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
                  '原创榜单',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          arkSelectedCollections.isEmpty
              ? Container()
              : Container(
                  height: 340,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children:
                        arkSelectedCollections['data']['selected_collections'].map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: arkSelectedCollections['data']['selected_collections']
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
          arkTopicRec.isEmpty
              ? Container()
              : Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        '${arkTopicRec['data']['title']}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
          arkTopicRec.isEmpty
              ? Container()
              : Container(
                  child: Column(
                    children: arkTopicRec['data']['items'].map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 72,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    left: 18,
                                    top: 20,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      child: CachedNetworkImage(
                                        imageUrl: '${item['cover_images'][2]}',
                                        placeholder: (context, url) => new Container(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => new Icon(Icons.error),
                                        width: 54,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    top: 10,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      child: CachedNetworkImage(
                                        imageUrl: '${item['cover_images'][1]}',
                                        placeholder: (context, url) => new Container(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => new Icon(Icons.error),
                                        width: 50,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(6)),
                                      child: CachedNetworkImage(
                                        imageUrl: '${item['cover_images'][0]}',
                                        placeholder: (context, url) => new Container(
                                          child: Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => new Icon(Icons.error),
                                        width: 60,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
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
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${item['items_count']}本 · ${item['followers_count']}人加入书架',
                                      style: TextStyle(fontSize: 20, color: Colors.grey),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  '经典高分',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          topBooks.isEmpty
              ? Container()
              : Container(
                  padding: EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color(0xffEDEDED), width: 1))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: topBooks.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                width: 74,
                                height: 110,
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
                                      style: TextStyle(fontSize: 16, color: Colors.black),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '作者: ${item['author'].join(', ')}',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Container(
                                    height: 3,
                                  ),
                                  item['rating'] == null
                                      ? Container()
                                      : Rating(double.tryParse('${item['rating']['value']}')),
                                  Container(
                                    height: 3,
                                  ),
                                  Text(
                                    '${item['abstract']}',
                                    style: TextStyle(fontSize: 12),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        '${item['tag'].join(', ')}',
                                        style: TextStyle(color: Color(0xffC6C6C6), fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
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
        ],
      ),
    );
  }
}
