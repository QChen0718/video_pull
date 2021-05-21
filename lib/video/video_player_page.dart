// 视频列表滚动播放插件
import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/actions/toast_util.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/newhttp/request_manager.dart';
import 'package:flutter_app_videolist/view/multiple_video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultipleVideoPlayerPage extends StatefulWidget {
  final String dynamicResourcesId;

  const MultipleVideoPlayerPage({Key key, this.dynamicResourcesId})
      : assert(dynamicResourcesId != null),
        super(key: key);

  @override
  _MultipleVideoPlayerPageState createState() =>
      _MultipleVideoPlayerPageState();
}

class _MultipleVideoPlayerPageState extends State<MultipleVideoPlayerPage> {
  /// 页面控制器
  PageController _pageController;

  /// 当前视频播放索引
  int _currentIndex = 0;

  /// 当前页数
  int _currentPage = 1;

  /// 分页大小
  int _pageSize = 10;

  /// 是否可以继续上啦加载
  bool _enablePullDown = true;

  /// 数据是否正在加载中
  bool _isRefreshing = false;

  /// 视频数据源
  List<VideoListSubDataModel> _videoList = [];

  /// 视频播放器key集合
  List<GlobalKey<MultipleVideoPlayerState>> _videoPlayerKeys = [];

  /// 是否横屏
  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(_pageControllerListener);
    _initMultipleVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController?.removeListener(() {});
    _pageController?.dispose();
    super.dispose();
  }

  // 加载网络数据，初始化第一个视频播放器
  void _initMultipleVideoPlayer() async {
    // 获取网络数据
    List<VideoListSubDataModel> videos = await _fetchVideoData();
    videos.forEach((_) {
      _videoPlayerKeys.add(GlobalKey());
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _videoPlayerKeys[0].currentState?.initVideoPlayer();
    });
    setState(() {});
  }

  /// 页面滑动事件
  void _pageControllerListener() {
    int floorValue = _pageController.page.floor();
    int ceilValue = _pageController.page.ceil();
    if (floorValue == ceilValue) {
      if (ceilValue != _currentIndex) {
        _currentIndex = ceilValue;
        if (_videoPlayerKeys != null) {
          _videoPlayerKeys[ceilValue].currentState?.initVideoPlayer();
        }
        // 滑动到最后一个
        if (_currentIndex == _videoList.length - 1 &&
            _enablePullDown &&
            !_isRefreshing) {
          _currentPage++;
          _initMultipleVideoPlayer();
        }
        if (_currentIndex == _videoList.length - 1 && !_enablePullDown) {
          Future.delayed(Duration(seconds: 2), () {
            ToastOk.show(msg: '没有更多视频了');
            //  没有更多视频
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                '没有更多视频了',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            );
          });
        }
      }
    }
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

  /// 拦截返回键
  Future<bool> _onWillPop() async {
    if (_isFullScreen) {
      AutoOrientation.portraitAutoMode();
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      return false;
    }
    // Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
          child: Stack(
            children: [
              _buildPageView(),
              _buildAppbar()
            ],
          ),
          onWillPop: _onWillPop),
    );
  }

  /// 构建导航
  Widget _buildAppbar() {
    return Positioned(
      left: 0,
      top: _isFullScreen ? 10 : ScreenUtil().statusBarHeight,
      child: Offstage(
        offstage: !_isFullScreen,
        child: Container(
          height: kToolbarHeight,
          padding: EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () async => _onWillPop(),
            child: Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }

  /// 视频页面
  Widget _buildPageView() {
    if (_videoList == null || _videoList.isEmpty) {
      return VideoLoadingPlaceHolder();
    }
    final ScrollPhysics physics = _isFullScreen
        ? NeverScrollableScrollPhysics()
        : ClampingScrollPhysics();
    return PageView.builder(
      controller: _pageController,
      pageSnapping: true,
      physics: physics,
      scrollDirection: Axis.vertical,
      itemCount: _videoList.length ?? 0,
      itemBuilder: (context, index) {
        var data = _videoList[index];
        return MultipleVideoPlayer(
          key: _videoPlayerKeys[index],
          data: data,
        );
      },
    );
  }
}
