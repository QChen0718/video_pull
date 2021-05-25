import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/actions/mysliver.dart';
import 'package:flutter_app_videolist/view/video_cell.dart';
import 'package:get/get.dart';

import 'logic.dart';
import 'state.dart';

class VideoListPage extends StatelessWidget {
  final VideoListLogic logic = Get.put(VideoListLogic());
  final VideoListState state = Get.find<VideoListLogic>().state;

  @override
  Widget build(BuildContext context) {
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
        //GetBuilder 简单的状态管理
        child: GetBuilder<VideoListLogic>(
          builder: (logicGet){
            return ListView.custom(
              childrenDelegate: MySliverChildBuilderDelegate(
                  (BuildContext context,int index){
                    return Container(
                        child: VideoItemView(
                          key: state.videoPlayerKeys[index],
                          dataModel: state.videoList[index],)
                    );
                  },
                childCount: state.videoList.length,
              ),
              cacheExtent: 0,
            );
          },
        ),
      ),
    );
  }
  _onEndScroll(ScrollMetrics metrics){
    print("Scroll End");
    print('=========>' + APPInfo.index.toString() + 'oldIndex:' + state.oldIndex.toString());
    if(state.oldIndex != APPInfo.index){
      state.videoPlayerKeys[state.oldIndex].currentState?.stopVideoPlayer();
      state.videoPlayerKeys[APPInfo.index].currentState?.initVideoPlayer();
    }
    state.oldIndex = APPInfo.index;
  }
}
