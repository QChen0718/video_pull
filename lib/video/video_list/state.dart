import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/view/video_cell.dart';
import 'package:get/get.dart';

class VideoListState {
  List<VideoListSubDataModel> videoList;
  List<GlobalKey<VideoItemViewState>> videoPlayerKeys;
  int pageSize;
  RxInt currentPage;
  int oldIndex;
  bool isScreen;
  VideoListState() {
    /// Initialize variables
    videoList = [];
    /// 视频播放器key集合
    videoPlayerKeys = [];
    /// 每页个数
    pageSize = 10;
    /// 当前页
    currentPage = 1.obs;
    ///
    oldIndex = 0;
    ///
    isScreen = false;
  }
}
