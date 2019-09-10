import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

// 首页
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getRecommend('');
  }

  List recommend = [];

  int start = 0;

  _getRecommend(type) async {
//    setState(() {
//      recommend.clear();
//    });
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/elendil/recommend_feed?start=$start&count=20&ad_ids=207339%2C207341&mooncake=b8234943de004fd5c017b9f72ae78509&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&webview_ua=Mozilla%2F5.0%20%28Linux%3B%20Android%205.1.1%3B%20SM-G9350%20Build%2FLMY48Z%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Version%2F4.0%20Chrome%2F39.0.0.0%20Safari%2F537.36&longitude=119.275036&latitude=26.096229&os_rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&channel=Douban&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&_sig=GlvVSezRdEHfOcnOAc5nSPvhHd4%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'api-client/1 com.douban.frodo/5.26.0(134) Android/23 product/OnePlus3 vendor/One model/ rom/android  network/wifi'
        }),
      );
      if (mounted) {
        setState(() {
          recommend.addAll(response.data['items']);
          Toast.show("${response.data['toast']}", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
          print(jsonEncode(recommend));
          if (type == 'refresh') {
            _refreshController.refreshCompleted();
          } else if (type == 'load') {
            _refreshController.loadComplete();
          }
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {
      recommend.clear();
      start = 0;
    });
    _getRecommend('refresh');
  }

  void _onLoading() async {
    setState(() {
      start += 20;
      _getRecommend('load');
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffF4F4F4),
      appBar: AppBar(
        title: Text('推荐'),
      ),
      body: recommend.isEmpty
          ? Center(
              child: CupertinoActivityIndicator(),
            )
          : SmartRefresher(
              enablePullDown: true,
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
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: ListView.builder(
                itemBuilder: (c, i) => GestureDetector(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    margin: EdgeInsets.only(top: 10, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: '${recommend[i]['owner']['avatar']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              width: 10,
                            ),
                            Text('${recommend[i]['owner']['name']}')
                          ],
                        ),
                        recommend[i]['topic'] == null
                            ? Container()
                            : Wrap(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(top: 6, bottom: 6),
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: Color(0xffF7F7F7)),
                                    child: Text(
                                      '${recommend[i]['topic']['name']}',
                                      style: TextStyle(color: Color(0xff42BD56)),
                                    ),
                                  )
                                ],
                              ),
                        recommend[i]['content']['status'] == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 6, bottom: 6),
                                child: Text('${recommend[i]['content']['status']['text']}'),
                              ),
                        recommend[i]['content']['status'] == null
                            ? Container()
                            : Wrap(
                                spacing: 10,
                                children:
                                    recommend[i]['content']['status']['images'].map<Widget>((item) {
                                  return Container(
                                    width: (width - 60) / 3,
                                    height: (width - 60) / 3,
                                    child: CachedNetworkImage(
                                      imageUrl: '${item['large']['url']}',
                                      placeholder: (context, url) => new Container(
                                        child: Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                        recommend[i]['content']['title'] == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: 6, bottom: 6),
                                child: Text('${recommend[i]['content']['title']}'),
                              ),
                        recommend[i]['content']['photos'] == null
                            ? Container()
                            : Wrap(
                                spacing: 10,
                                children: recommend[i]['content']['photos'].map<Widget>((item) {
                                  return Container(
                                    width: (width - 60) / 3,
                                    height: (width - 60) / 3,
                                    child: CachedNetworkImage(
                                      imageUrl: '${item['image']['large']['url']}',
                                      placeholder: (context, url) => new Container(
                                        child: Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => new Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'images/ic_vote_small.webp',
                                    width: 30,
                                    height: 30,
                                  ),
                                  Text('${recommend[i]['reactions_count']}')
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'images/ic_reply_large.webp',
                                    width: 30,
                                    height: 30,
                                  ),
                                  Text('${recommend[i]['comments_count']}')
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'images/ic_status_detail_reshare_icon.webp',
                                    width: 30,
                                    height: 30,
                                  ),
                                  Text('${recommend[i]['reshares_count']}')
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                itemCount: recommend.length,
              ),
            ),
    );
  }
}
