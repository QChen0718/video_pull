import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/main.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/view/asperct_raio_image.dart';
import 'package:flutter_app_videolist/view/social_tool_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';
// 监听页面切换  RouteObserver & RouteAware

//视频播放，展示控制器 重要重要重要！！！
class MultipleVideoPlayer extends StatefulWidget{
  //视频数据
  final VideoListSubDataModel data;
  const MultipleVideoPlayer({Key key, this.data}) : super(key: key);

  @override
  MultipleVideoPlayerState createState() => MultipleVideoPlayerState();
}

class MultipleVideoPlayerState extends State<MultipleVideoPlayer>{
  GlobalKey<MultipleVideoItemState> _videoItemKey = GlobalKey();
  /// 记录是否为横屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  //初始化视频播放器
  void initVideoPlayer(){
    _videoItemKey.currentState.initVideoPlayer();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<Widget> children = [
    //  播放视频视图
      MultipleVideoItem(key: _videoItemKey,data: widget.data,)
    ];
    // 非横屏显示
    if(!_isFullScreen){
      children.add(Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.bottomRight,
        child: SocialToolBar(video: widget.data),
      ));
    //
      children.add(
        Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.bottomLeft,
          child: VideoUserInfo(video: widget.data,),
        )
      );
    }
    return Stack(children: children);
  }
}

// 视频视图类
class MultipleVideoItem extends StatefulWidget{
  final VideoListSubDataModel data;

  const MultipleVideoItem({Key key, this.data}) : super(key: key);
  @override
  MultipleVideoItemState createState() => MultipleVideoItemState();
}
// 页面去向监听方法
class MultipleVideoItemState extends State<MultipleVideoItem> with RouteAware{
  VideoPlayerController _videoPlayerController;
  ValueNotifier<bool> _isPlayerNotifier;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPlayerNotifier = ValueNotifier<bool>(null);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)); //订阅观察者
  }
  // 已经push到下个界面
  @override
  void didPushNext() {
    // TODO: implement didPushNext
    print("didPushNext");
    super.didPushNext();
    if(_videoPlayerController != null){
      // 暂停播放
      _videoPlayerController?.pause();
      _isPlayerNotifier.value = false;
    }
  }
  // 返回到当前界面
  @override
  void didPopNext() {
    // TODO: implement didPopNext
    print("didPopNext");
    super.didPopNext();
    if(_videoPlayerController != null){
    //  播放视频
      _videoPlayerController.play();
      _isPlayerNotifier.value = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //界面销毁,销毁播放器，和valueNotifier
    if(_videoPlayerController != null){
      _videoPlayerController.pause();
      _videoPlayerController.dispose();
      _videoPlayerController = null;
    }
    if(_isPlayerNotifier != null){
      _isPlayerNotifier.dispose();
      _isPlayerNotifier = null;
    }
    // 取消订阅
    routeObserver.unsubscribe(this);
    super.dispose();
  }
  // 初始化视频播放器
  void initVideoPlayer(){
    // 允许循环播放
    _videoPlayerController = VideoPlayerController.network(widget.data?.files ?? '');
    _videoPlayerController.setLooping(true);
    _videoPlayerController.initialize().then((_) {
      _videoPlayerController.play();
      _isPlayerNotifier.value = true;
      setState(() {});
    });
  }

  /// 记录是否为横屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;

  /// 控制全屏播放
  void _toggleFullScreen(){
    if(_isFullScreen){
    //  如果是全屏就切换竖屏
      AutoOrientation.portraitAutoMode();
      // 显示状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIOverlays([
        SystemUiOverlay.top,
        SystemUiOverlay.bottom
      ]);
    }else {
        AutoOrientation.landscapeAutoMode();
    //    关闭状态栏，与底部虚拟操作按钮
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  ///全屏查看按钮
  Widget _buildFullScreenButton(){
    final double width = _videoPlayerController.value.size.width;
    //纵横比
    final double aspectRatio = _videoPlayerController.value.aspectRatio;
    final double height = min(width, ScreenUtil().screenWidth)/aspectRatio;
    if(aspectRatio <= 0.8 || _isFullScreen){
      return Container();
    }
    GestureDetector tap = GestureDetector(
      onTap: () => _toggleFullScreen(),
      child: Container(
        width: 90,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.grey,
            width: 0.5
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.fullscreen,
              size: 16,
              color: Colors.grey,
            ),
            SizedBox(width: 3,),
            Text(
              '全屏观看',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w200
              ),
            )
          ],
        ),
      ),
    );
    return Positioned(
        top: (ScreenUtil().screenHeight + height) / 2.0 + 10.0,
        child: tap
    );
  }

  /// 显示/隐藏播放按钮
  Widget _buildPlayOrPauseIcon(){
    return ValueListenableBuilder(
        valueListenable: _isPlayerNotifier,
        builder: (_,isPlayer,__){
          if(isPlayer != null && isPlayer == false){
            return Icon(
              Icons.play_arrow_rounded,
              color: Colors.white.withOpacity(0.5),
              size: 80,
            );
          }
          return Container();
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget videoPlayer;
    Widget loading;
    Widget fullScreen;
    if(_videoPlayerController != null &&
        _videoPlayerController.value != null &&
        _videoPlayerController.value.isInitialized){
      videoPlayer = VideoPlayer(_videoPlayerController);
      loading = Container();
      fullScreen = _buildFullScreenButton();
    }else {
      videoPlayer = Container();
      loading = SpinKitFadingCircle(size: 30,color: Colors.white.withOpacity(0.8),);
      fullScreen = Container();
    }
    // 封面URL
    final String fmurl = APPInfo.HTTP_IMAGE_DOWNLOAD_REQUEST_URL + widget.data.image;
    final Widget child = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox.expand(
          child: AsperctRaioImage.network(
            fmurl,
            builder: (ctx,snapshot,url){
              if(!snapshot.hasData){
                return Container();
              }
              double width = snapshot.data.width.toDouble();
              double height = snapshot.data.height.toDouble();
              double aspectRatio = width / height;
              BoxFit fit = aspectRatio > 0.8 ? BoxFit.contain : BoxFit.cover;
              return FittedBox(
                fit: fit,
                child: Container(
                  width: snapshot.data.width.toDouble(),
                  height: snapshot.data.height.toDouble(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(fmurl),
                      fit: fit
                    )
                  ),
                  child: videoPlayer,
                ),
              );
            }
          )
        ),
        loading,
        fullScreen,
        _buildPlayOrPauseIcon()
      ],
    );
    // TODO: implement build
    return  Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: GestureDetector(
                onTap: () async{
                  if(_videoPlayerController == null || _videoPlayerController.value == null){
                    return;
                  }
                  if(_videoPlayerController.value.isPlaying){
                    if(_videoPlayerController != null){
                      await _videoPlayerController.pause();
                      _isPlayerNotifier.value = false;
                    }
                  }else{
                    if(_videoPlayerController != null) {
                      await _videoPlayerController.play();
                      _isPlayerNotifier.value = true;
                    }
                  }
                },
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: child,
                ),
              ),
          ),
         Container(
              width: MediaQuery.of(context).size.width,
              height: 15,
              color: Colors.transparent,
              child: _videoPlayerController != null ?
              VideoProgressIndicator(
                _videoPlayerController,
                allowScrubbing: true, // 允许手势操作进度条
                padding: EdgeInsets.only(top: 5,bottom: 5),
                colors: VideoProgressColors( // 配置进度条颜色，也是video_player现成的，直接用
                  playedColor: Colors.red,
                  // 已播放的颜色
                  bufferedColor: Color.fromRGBO(255, 255, 255, .5),
                  // 缓存中的颜色
                  backgroundColor: Color.fromRGBO(
                      255, 255, 255, .2), // 为缓存的颜色
                ),
              ):Container(),
          )
        ],
    );
  }
}

class VideoLoadingPlaceHolder extends StatelessWidget {
  const VideoLoadingPlaceHolder({Key key, this.gradient = false})
      : super(key: key);

  final bool gradient;

  @override
  Widget build(BuildContext context) {
    Widget loading = Center(
      child: SpinKitFadingCircle(
        size: 30,
        color: Colors.white.withOpacity(0.8),
      ),
    );
    if (!gradient) return loading;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: <Color>[
            Colors.blue,
            Colors.green,
          ],
        ),
      ),
      child: loading,
    );
  }
}

//视频用户信息
class VideoUserInfo extends StatelessWidget {
  final VideoListSubDataModel video;

  const VideoUserInfo({Key key, this.video}) :
        assert(video != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
     height: 160,
     alignment: Alignment.bottomLeft,
     padding: EdgeInsets.only(
       left: 12,
       bottom: ScreenUtil().bottomBarHeight + 20,
     ),
      margin: EdgeInsets.only(right: 80),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: (){
              //  跳转到用户信息界面
              },
              child: Text(
                '@' + video?.guest,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  inherit: true,
                  color: Colors.white
                ),
              ),
            ),
            Container(
              height: 6,
            ),
            _buildContent(context),
            Container(height: 6,)
          ],
        ),
      ),
    );
  }
  // 文字
  Widget _buildContent(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
         Text(
            video?.content,
            maxLines: 9999,
            overflow: TextOverflow.ellipsis,
            style: _kContentTextStyle,
          ),
          Container(
            margin: EdgeInsets.only(top: 2),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '#' +
                        'dfgdg' +
                        ' ',
                    style: _kTopicTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {

                      },
                  ),
                  TextSpan(
                    text: '@' + 'jljwelj',
                    style: _kFollowTextStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

const _kContentTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
  letterSpacing: 1,
  height: 1.3,
);

const _kTopicTextStyle = TextStyle(
  color: Colors.white, //Colours.text_green,
  fontSize: 15,
  letterSpacing: 1,
  height: 1.3,
  fontWeight: FontWeight.w600,
);

const _kFollowTextStyle = TextStyle(
  color: Colors.white, //Colours.text_blue,
  fontSize: 15,
  letterSpacing: 1,
  height: 1.3,
  fontWeight: FontWeight.w600,
);