
import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/newhttp/request_manager.dart';
import 'package:flutter_app_videolist/view/video_cell.dart';
import 'package:lottie/lottie.dart';

class VideoListPage extends StatefulWidget{
  @override
  _VideoListPageState createState() => _VideoListPageState();
}
class _VideoListPageState extends State<VideoListPage> {
  List<VideoListSubDataModel> _videoList = [];
  /// 视频播放器key集合
  List<GlobalKey<VideoItemViewState>> _videoPlayerKeys = [];
  int _pageSize = 10;
  int _currentPage = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initVideoData();
  }
  void initVideoData() async{
    List<VideoListSubDataModel> videos = await _fetchVideoData();
    videos.forEach((_) {
      _videoPlayerKeys.add(GlobalKey());
    });

    Future.delayed(Duration(milliseconds: 500), () {
      _videoPlayerKeys[0].currentState?.startVideoPlayer();
    });
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '视频列表'
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification){
          if(scrollNotification is ScrollEndNotification){
            _onEndScroll(scrollNotification.metrics);
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _videoList.length,
          cacheExtent: 0,
          itemBuilder: (context,index){
            return Container(
                child: VideoItemView(
                  key: _videoPlayerKeys[index],
                  dataModel: _videoList[index],
                )
            );
          },
        ),
      ),
    );
  }
  _onEndScroll(ScrollMetrics metrics){
    print("Scroll End");
  }
  // 网络请求数据
  Future<List<VideoListSubDataModel>> _fetchVideoData() async {
    var params = APPInfo.getRequestnomalparams(
        APPInfo.getFirstHeader()[APPInfo.ApiVersionKey]);
    // params.addAll(APPInfo.getUserDict());
    params.addAll({
      'pageSize': _pageSize,
      'pageIndex': _currentPage,
      'type': 2,
      'userMobile': '18311055781',
      'userId': 1833334
    });
    try {
      VideoListDataModel model = await RequestManager.getVideoListData(params);
      model.data.forEach((element) {
        _videoList.add(element);
      });
      return _videoList;
    } catch (e) {
      return [];
    }
  }
}

