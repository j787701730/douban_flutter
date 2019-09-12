import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SubjectBook extends StatefulWidget {
  @override
  _SubjectBookState createState() => _SubjectBookState();
}

class _SubjectBookState extends State<SubjectBook> {
  @override
  void initState() {
    super.initState();
    _getRecommend('');
    _getRecommend2('');
  }

  Map bookSubjectEntrances = {}; // 头部导航栏
  List bookLatest = []; // 新书速递
  List bookSelectedCollections = []; // 新书速递
  List bookReadlist = []; // 豆瓣书单
  List bookSubjectThemes = []; // 今日推荐
  List bookGalleryTopic = []; // 话题推荐
  List marketProductBook = []; // 豆瓣书店

  List recommendBooks = []; // 推荐书

  // 一堆数据
  _getRecommend(type) async {
//    setState(() {
//      recommend.clear();
//    });
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/book/modules?udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=bv0poYy%2FE0F2Mqxw%2FP%2B6dpqeDFQ%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
//          movie = response.data['modules'];
          for (var o in response.data['modules']) {
            if (o['module_name'] == 'book_subject_entrances') {
              bookSubjectEntrances = o;
            } else if (o['module_name'] == 'book_latest') {
              bookLatest = o['data']['subject_collection_boards'][0]['items'];
            } else if (o['module_name'] == 'book_selected_collections') {
              bookSelectedCollections = o['data']['selected_collections'];
            } else if (o['module_name'] == 'book_readlist') {
              bookReadlist = o['data']['items'];
            } else if (o['module_name'] == 'book_subject_themes') {
              bookSubjectThemes = o['data']['items'];
            } else if (o['module_name'] == 'book_gallery_topic') {
              bookGalleryTopic = o['data']['items'].sublist(0, 1);
            } else if (o['module_name'] == 'market_product_book') {
              marketProductBook = o['data']['subject_collection_boards'][0]['items'].sublist(0, 4);
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
        "https://frodo.douban.com/api/v2/book/suggestion?start=$start&count=10&new_struct=1&with_review=1&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&s=rexxar_new&channel=Douban&device_id=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&os_rom=android&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&mooncake=b8234943de004fd5c017b9f72ae78509&loc_id=118200&_sig=HvfmiukBMWglrwfurT6RX8A7u2k%3D&_ts=${(new DateTime.now().millisecondsSinceEpoch) ~/ 1000}",
        options: new Options(headers: {
          'User-Agent':
              'Rexxar-Core/0.1.3 api-client/1 com.douban.frodo/6.21.0.beta2(164) Android/22 product/SM-G9350 vendor/samsung model/SM-G9350  rom/android  network/wifi  platform/AndroidPad com.douban.frodo/6.21.0.beta2(164) Rexxar/1.2.151  platform/AndroidPad 1.2.151'
        }),
      );
      if (mounted) {
        setState(() {
          recommendBooks.addAll(response.data['items']);
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
        child: ListView(padding: EdgeInsets.all(15), children: <Widget>[
          bookSubjectEntrances.isEmpty
              ? Container()
              : Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: bookSubjectEntrances['data']['subject_entraces'].map<Widget>((item) {
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
                  '新书速递',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          bookLatest.isEmpty
              ? Container()
              : Container(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: bookLatest.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(left: bookLatest.indexOf(item) == 0 ? 0 : 15),
                        width: width * 0.618,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              border:
                                  Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(6)),
                                child: CachedNetworkImage(
                                  imageUrl: '${item['cover']['url']}',
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
                                    RichText(
                                      text: TextSpan(
                                          text: '${item['wish_count']} 人想看',
                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(text: '/${item['author'].join(', ')}')
                                          ]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 6),
                                      width: width,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                          color: Color(0xffF7F7F7)),
                                      child: Text(
                                        '${item['description']}',
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
          bookSelectedCollections.isEmpty
              ? Container()
              : Container(
                  height: 340,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: bookSelectedCollections.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(
                            left: bookSelectedCollections.indexOf(item) == 0 ? 0 : 15),
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
                  '豆瓣书单',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          bookReadlist.isEmpty
              ? Container()
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: bookReadlist.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
                        child: Row(
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
                                      text: '${item['items_count']}本 ${item['followers_count']}人关注',
                                      style: TextStyle(fontSize: 20, color: Colors.grey),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    width: width,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(6)),
                                        color: Color(0xffF7F7F7)),
                                    child: Row(
                                      children: <Widget>[
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(6)),
                                          child: CachedNetworkImage(
                                            imageUrl: '${item['owner']['avatar']}',
                                            placeholder: (context, url) => new Container(
                                              child: Center(
                                                child: CupertinoActivityIndicator(),
                                              ),
                                            ),
                                            errorWidget: (context, url, error) =>
                                                new Icon(Icons.error),
                                            width: 20,
                                            height: 20,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          width: 10,
                                        ),
                                        Text(
                                          '${item['owner']['name']}',
                                          style: TextStyle(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '创建',
                                          style: TextStyle(color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
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
                  '今日推荐',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          bookSubjectThemes.isEmpty
              ? Container()
              : Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${bookSubjectThemes[0]['title']}',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 4,
                          ),
                          Text(
                            '${bookSubjectThemes[0]['target']['desc']}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            height: 4,
                          ),
                          Text(
                            '作者 : ${bookSubjectThemes[0]['target']['author']['name']}',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      )),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          child: CachedNetworkImage(
                            imageUrl: '${bookSubjectThemes[0]['target']['cover_url']}',
                            placeholder: (context, url) => new Container(
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => new Icon(Icons.error),
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ],
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
          recommendBooks.isEmpty
              ? Container()
              : Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: recommendBooks.map<Widget>((item) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 1))),
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
                                  Text('${item['rating'] == null ? '' : item['rating']['value']}'),
                                  Text(
                                    '${item['card_subtitle']}',
                                    style: TextStyle(),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
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
