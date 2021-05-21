import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// 研究一下json动画
class VideoListPage extends StatefulWidget{
  @override
  _VideoListPageState createState() => _VideoListPageState();
}
class _VideoListPageState extends State<VideoListPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      children: [
        Lottie.network('https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json')
      ],
    );
  }
}