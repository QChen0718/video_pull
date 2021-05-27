import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/actions/dateformat.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/view/asperct_raio_image.dart';
import 'package:flutter_app_videolist/view/video_player_toolbar.dart';
import 'package:video_player/video_player.dart';

class VideoItemView extends StatefulWidget{
  final VideoListSubDataModel dataModel;
  final int index;
  const VideoItemView({Key key, this.dataModel,this.index}) : super(key: key);
  @override
  VideoItemViewState createState() => VideoItemViewState();
}
class VideoItemViewState extends State<VideoItemView> {

  VideoPlayerController _videoPlayerController;
  ValueNotifier<bool> _isShowPlayButton;
  /// 记录是否为横屏
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isShowPlayButton = ValueNotifier(true);
    initVideo();
  }
  // 初始化播放器
  void initVideo(){
    if(_videoPlayerController == null){
      _videoPlayerController = VideoPlayerController.network(widget.dataModel?.files);
      _videoPlayerController.setLooping(true);
    }
  }
  //  开始播放视频
  void startVideoPlayer(){
    // 判断一下视频是否初始化，
    if(!_videoPlayerController.value.isInitialized){
      _videoPlayerController.initialize().then((value){
        _videoPlayerController.play();
        // 设置播放到指定时间
        _videoPlayerController.seekTo(Duration(seconds: widget.dataModel.time));
        _isShowPlayButton.value = false;
        print('总时长：${_videoPlayerController.value.duration.inMilliseconds}  总秒数：${_videoPlayerController.value.duration.inSeconds}');
        setState(() {

        });
      });

    }else {
      if(!_videoPlayerController.value.isPlaying){
        _videoPlayerController.play();
        _isShowPlayButton.value = false;
      }
    }

    APPInfo.oldVideoPlayerController = _videoPlayerController;
    APPInfo.oldIsShowPlayButton = _isShowPlayButton;
  }
  //停止上个视频的播放
  void stopVideoPlayer() {
    if(APPInfo.oldVideoPlayerController != null && APPInfo.oldIsShowPlayButton != null){
      APPInfo.oldVideoPlayerController.pause();
      APPInfo.oldIsShowPlayButton.value = true;
    }
  }
  //播放或者暂停
  void playOrPause(){
    if(_videoPlayerController != null){
      if(_videoPlayerController.value.isPlaying){
        _videoPlayerController.pause();
        _isShowPlayButton.value = true;
      }else{
        //判断是否初始化视频
        if(_videoPlayerController.value.isInitialized){
          // 直接播放
           _videoPlayerController.play();
        }else {
          // 初始化
          startVideoPlayer();
        }
        _isShowPlayButton.value = false;
      }
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    if(_videoPlayerController != null){
      // 判断当前的视频控制器和保存的老的控制器是否是一个，是的话就进行销毁
      if(APPInfo.oldVideoPlayerController == _videoPlayerController){
        APPInfo.oldVideoPlayerController = null;
      }
      //获取被销毁的视频当前播放的位置，等到下次滑动到该视频时，从上次播放的位置进行播放
      widget.dataModel.time = _videoPlayerController.value.position.inSeconds;
      _videoPlayerController.pause();
      _videoPlayerController.dispose();
      _videoPlayerController = null;
    }
    if(_isShowPlayButton != null){
      if(APPInfo.oldIsShowPlayButton == _isShowPlayButton){
        APPInfo.oldIsShowPlayButton = null;
      }
      _isShowPlayButton.dispose();
      _isShowPlayButton = null;
    }
    super.dispose();

    print('------dispose-------');
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String fmurl = APPInfo.HTTP_IMAGE_DOWNLOAD_REQUEST_URL + widget.dataModel?.image ?? '';
    Widget videoPlayer;
    if(_videoPlayerController != null &&
        _videoPlayerController.value != null){
      videoPlayer = VideoPlayer(_videoPlayerController);
    }else {
      videoPlayer = VideoPlayer(_videoPlayerController);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: _isFullScreen ? MediaQuery.of(context).size.height : 390,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onTap: () => playOrPause(),
                child: AsperctRaioImage.network(
                    fmurl,
                    builder: (context,snapshot,url){
                      if(!snapshot.hasData){
                        return Container();
                      }
                      return  Container(
                        width:snapshot.data.width.toDouble(),
                        height: snapshot.data.height.toDouble(),
                        child: videoPlayer,
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(
                                    fmurl
                                ),
                                fit: BoxFit.fill
                            )
                        ),
                      );
                    }
                ),
              ),
              Positioned(
                  child: Text(
                    widget.dataModel.guest,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                left: 10,
                top: 8,
              ),
              ValueListenableBuilder(
                  valueListenable: _isShowPlayButton,
                  builder: (context,value,child){
                    return Offstage(
                      offstage: !value,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.red,
                          size: 80,
                        ),
                      ),
                    );
                  }
              ),
              Positioned(
                bottom: 10,
                right: _videoPlayerController.value.isInitialized ? 0 : 5,
                child: ValueListenableBuilder(
                  valueListenable: _isShowPlayButton,
                  builder: (context,value,child){
                    if(!value){
                     return VideoPlayerToolbar(
                       videoPlayerController: _videoPlayerController,
                       totalDuration:APPInfo.durationToTime(_videoPlayerController.value.duration.inMilliseconds)
                       ,position: APPInfo.durationToTime(_videoPlayerController.value.position.inMilliseconds),
                       selectIndex: widget.index,
                     );
                    }else {
                      if(_videoPlayerController.value.isInitialized){
                        return VideoPlayerToolbar(
                          videoPlayerController: _videoPlayerController,
                          totalDuration:APPInfo.durationToTime(_videoPlayerController.value.duration.inMilliseconds)
                          ,position: APPInfo.durationToTime(_videoPlayerController.value.position.inMilliseconds),
                          selectIndex: widget.index,
                        );
                      }else {
                        return Row(
                          children: [
                            Text(
                              '1375次播放',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 22,
                              margin: EdgeInsets.only(left: 10),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '05:56',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15)
                              ),
                            )
                          ],
                        );
                      }
                    }
                  },
                )
              )
            ],
          ),
          Offstage(
            offstage: _isFullScreen,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15,right: 10,top: 10,bottom: 10),
                      child: CircleAvatar(
                        child: Image.asset(
                          'images/icon_user.png',
                          width: 50,
                          height: 50,
                        ),
                        radius: 25,
                      ),
                    ),
                    Expanded(
                        child: RichText(
                            text: TextSpan(
                                text: '拉叔说创业',
                                children: [
                                  TextSpan(
                                      text: ' | ',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      )
                                  ),
                                  TextSpan(
                                      text: '关注',
                                      style: TextStyle(
                                          color: Colors.red
                                      )
                                  )
                                ],
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15
                                )
                            )
                        )
                    ),
                    Container(
                      child: Row(
                        children: [
                          Icon(
                            Icons.messenger_outline,
                            size: 15,
                          ),
                          Container(
                            child: Text(
                                '4'
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 15,left: 10),
                      child: Text(
                        '...',
                        style: TextStyle(
                            color: Colors.black87
                        ),
                      ),
                    )
                  ],
                ),
                Container(height: 10,color: Colors.grey,)
              ],
            ),
          )
        ],
      )
    );
  }
}