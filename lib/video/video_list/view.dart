

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/actions/mysliver.dart';
import 'package:flutter_app_videolist/view/video_cell.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'logic.dart';
import 'state.dart';

class VideoListPage extends StatelessWidget {
  final VideoListLogic logic = Get.put(VideoListLogic());
  final VideoListState state = Get.find<VideoListLogic>().state;
  @override
  Widget build(BuildContext context) {
    state.isScreen = MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '视频列表'
        ),
      ),
      body: WillPopScope(
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification){
              if(scrollNotification is ScrollEndNotification){
                _onEndScroll(scrollNotification.metrics);
              }
              return true;
            },
            //GetBuilder 简单的状态管理
            child: GetBuilder<VideoListLogic>(
              builder: (logicGet){
                /// 记录是否为横屏
                if(!state.isScreen){
                  return ListView.custom(
                    childrenDelegate: MySliverChildBuilderDelegate(
                          (BuildContext context,int index){
                        return Container(
                            child: VideoItemView(
                              key: state.videoPlayerKeys[index],
                              dataModel: state.videoList[index],
                              index: index,)
                        );
                      },
                      childCount: state.videoList.length,
                    ),
                    cacheExtent: 0,
                  );
                }else {
                  return VideoItemView(
                    key: state.videoPlayerKeys[APPInfo.selectIndex],
                    dataModel: state.videoList[APPInfo.selectIndex],
                    index: APPInfo.selectIndex,
                  );
                }
              },
              dispose: (dis){
                print('页面销毁======>');
                // 销毁GetController
                Get.delete<VideoListLogic>();

                if(APPInfo.oldVideoPlayerController != null){
                  // APPInfo.oldVideoPlayerController.dispose();
                  APPInfo.oldVideoPlayerController = null;
                }
                if(APPInfo.oldIsShowPlayButton != null){
                  APPInfo.oldIsShowPlayButton = null;
                }
              },
            ),
          ),
          onWillPop: _onWillPop
      ),
    );
  }
  /// 拦截返回键
  Future<bool> _onWillPop() async {

    if (state.isScreen) {
      AutoOrientation.portraitAutoMode();
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      return false;
    }

    return true;
  }
  _onEndScroll(ScrollMetrics metrics){
    print("Scroll End");
    state.videoPlayerKeys[APPInfo.index].currentState?.stopVideoPlayer();
    state.videoPlayerKeys[APPInfo.index].currentState?.startVideoPlayer();
  }
}
