import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:toast/toast.dart';

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
    _getRecommend();
  }

  Map recommend = {};

  _getRecommend() async {
    try {
      Response response = await Dio().get(
        "https://frodo.douban.com/api/v2/elendil/recommend_feed?start=0&count=20&ad_ids=204184&mooncake=b8234943de004fd5c017b9f72ae78509&apple=d2c2b0448e0b4b2ee1a6e2323dd5480f&icecream=3145fda4565998ad4b561ca18587f290&webview_ua=Mozilla%2F5.0%20%28Linux%3B%20Android%205.1.1%3B%20SM-G9350%20Build%2FLMY48Z%29%20AppleWebKit%2F537.36%20%28KHTML%2C%20like%20Gecko%29%20Version%2F4.0%20Chrome%2F39.0.0.0%20Safari%2F537.36&longitude=119.275036&latitude=26.096229&os_rom=android&apikey=0dad551ec0f84ed02907ff5c42e8ec70&channel=Douban&udid=f13917d8dcb79f9ef68de0c7b5abb435c3c02189&_sig=RQMwpTM%2BAW56rs87ljxi%2BZ59YWs%3D&_ts=1568018274",
        options: new Options(headers: {
          'User-Agent':
              'api-client/1 com.douban.frodo/5.26.0(134) Android/23 product/OnePlus3 vendor/One model/ rom/android  network/wifi'
        }),
      );
      if (mounted) {
        setState(() {
          recommend = response.data;
          Toast.show("${recommend['toast']}", context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
          print(recommend);
        });
      }
    } catch (e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: () {
          _getRecommend();
        },
        child: Text('11111'),
      ),
    );
  }
}
