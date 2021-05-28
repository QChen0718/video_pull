import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/newhttp/request_manager.dart';
import 'package:get/get.dart';

import 'state.dart';

class VideoListLogic extends GetxController {
  final state = VideoListState();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initVideoData();
  }
  void initVideoData() async{
    List<VideoListSubDataModel> videos = await _fetchVideoData();
    videos.forEach((_) {
      state.videoPlayerKeys.add(GlobalKey());
    });
    Future.delayed(Duration(milliseconds: 500), () {
      state.videoPlayerKeys[0].currentState.startVideoPlayer();
    });
    update(); //刷新数据
  }
  // 网络请求数据
  Future<List<VideoListSubDataModel>> _fetchVideoData() async {
    var params = APPInfo.getRequestnomalparams(
        APPInfo.getFirstHeader()[APPInfo.ApiVersionKey]);
    // params.addAll(APPInfo.getUserDict());
    params.addAll({
      'pageSize': state.pageSize,
      'pageIndex': state.currentPage.value,
      'type': 6,
      'userMobile': '18311055781',
      'userId': 1833334
    });
    try {
      VideoListDataModel model = await RequestManager.getVideoListData(params);
      model.data.forEach((element) {
        state.videoList.add(element);
      });
      return state.videoList;
    } catch (e) {
      return [];
    }
  }
}
