import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/actions/toast_util.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerToolbar extends StatefulWidget{
  final String totalDuration;
  final String position;
  final int selectIndex;
  final VideoPlayerController videoPlayerController;
  const VideoPlayerToolbar({Key key, this.totalDuration, this.position,@required this.videoPlayerController,this.selectIndex}) : super(key: key);
  @override
  _VideoPlayerToolbarState createState() => _VideoPlayerToolbarState();
}

class _VideoPlayerToolbarState extends State<VideoPlayerToolbar>{
  ValueNotifier<int> position = ValueNotifier(0);
  VoidCallback listener;
  _VideoPlayerToolbarState(){
    listener = (){
      //控制器监听
      if(!mounted){
        return;
      }
      position.value = widget.videoPlayerController.value.position.inMilliseconds;
    };
  }
  /// 记录是否为横屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.videoPlayerController.addListener(listener);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    widget.videoPlayerController.removeListener(listener);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 30,
      color: Colors.black.withOpacity(0.5),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            child: ValueListenableBuilder(
              valueListenable: position,
              builder: (context,value,child){
                return RichText(
                    text: TextSpan(
                        text: APPInfo.durationToTime(value) ?? '--',
                        children:[
                          TextSpan(
                              text: '/',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16
                              )
                          ),
                          TextSpan(
                              text: widget.totalDuration ?? '--',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 16
                              )
                          )
                        ]
                    )
                );
              },
            ),
          ),
          Expanded(
              child: VideoProgressIndicator( // 嘻嘻，这是video_player编写好的进度条，直接用就是了~~
                widget.videoPlayerController,
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
              ),
          ),
          GestureDetector(
            onTap: _toggleFullScreen,
            child: Container(
              width: 30,
              height: 30,
              margin: EdgeInsets.only(left: 20,right: 20),
              child: Icon(
                  Icons.fullscreen
              ),
            ),
          )
        ],
      ),
    );
  }
  /// 控制全屏播放
  void _toggleFullScreen(){
    APPInfo.selectIndex = widget.selectIndex;
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
}
