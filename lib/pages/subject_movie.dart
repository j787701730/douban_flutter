import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubjectMovie extends StatefulWidget {
  @override
  _SubjectMovieState createState() => _SubjectMovieState();
}

class _SubjectMovieState extends State<SubjectMovie> {
  @override
  void initState() {
    super.initState();
    _getRecommend('');
    _getRecommend2('');
    _getRecommend3('');
  }

  Map movieSubjectEntrances = {}; // 头部导航栏
  Map movieShowing = {}; // 影院热映
  Map movieSoon = {}; // 即将上映
  Map movieHotGaia = {}; // 豆瓣热门
  Map movieSelectedCollections = {}; // 豆瓣榜单
  Map todayPlays = {}; // 今日
  Map weekPlays = {}; // 一周推荐

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
              movieShowing = o;
            } else if (o['module_name'] == 'movie_soon') {
              movieSoon = o;
            } else if (o['module_name'] == 'movie_hot_gaia') {
              movieHotGaia = o;
            } else if (o['module_name'] == 'movie_selected_collections') {
              movieSelectedCollections = o;
            }
          }
//          print(jsonEncode(response.data));
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
        "https://frodo.douban.com/api/v2/movie/recommend?tags=&playable=0&start=0&count=8&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=%2FzYhb8OxfAQ0yJr%2FdqOOLDJzua0%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          weekPlays = response.data;
//          print(jsonEncode(response.data));
        });
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          movieSubjectEntrances.isEmpty
              ? Container()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: movieSubjectEntrances['data']['subject_entraces'].map<Widget>((item) {
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
                                fit: BoxFit.fill,
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
                                borderRadius: BorderRadius.all(Radius.circular(6))),
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
                          left: 75,
                          width: 98,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl: '${todayPlays['videos'][2]['pic']['large']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                fit: BoxFit.fitWidth,
                              ))),
                      Positioned(
                          top: 10,
                          left: 45,
                          width: 108,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl: '${todayPlays['videos'][1]['pic']['large']}',
                                placeholder: (context, url) => new Container(
                                  child: Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) => new Icon(Icons.error),
                                fit: BoxFit.fitWidth,
                              ))),
                      Positioned(
                          top: 0,
                          left: 20,
                          width: 118,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: CachedNetworkImage(
                              imageUrl: '${todayPlays['videos'][0]['pic']['large']}',
                              placeholder: (context, url) => new Container(
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => new Icon(Icons.error),
                              fit: BoxFit.fitWidth,
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
                                style: TextStyle(color: Colors.white, height: 1.5, fontSize: 18),
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
                )
        ],
      ),
    );
  }
}
