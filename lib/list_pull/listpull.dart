import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/model/posterlistmodel.dart';
import 'package:flutter_app_videolist/newhttp/request_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class ListPullPage extends StatefulWidget{
  @override
  _ListPullPageState createState() => _ListPullPageState();
}
class _ListPullPageState extends State<ListPullPage>{
  List<Color> colors = <Color>[];
  int _pageSize = 10;
  int _pageIndex = 1;
  List<PosterListDataModel> _posterListModelList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadListData();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '瀑布流',
          style: TextStyle(

          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text(
                'I\'m other slivers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SliverWaterfallFlow(
              delegate: SliverChildBuilderDelegate((BuildContext c, int index){
                //cell 样式
                final Color color = Colors.red;
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: getRandomColor(index)),
                  alignment: Alignment.center,
                  child:Column(
                    children: [
                      ExtendedImage.network(
                        APPInfo.HTTP_IMAGE_DOWNLOAD_REQUEST_URL + _posterListModelList[index].image,
                        cache: true,
                        fit: BoxFit.fitWidth,
                        loadStateChanged: (ExtendedImageState state){
                            switch(state.extendedImageLoadState){
                              case LoadState.loading:
                                return Container(
                                  child: Text('加载中'),
                                );
                                break;
                              case LoadState.completed:
                                print('width:${state.extendedImageInfo.image.width} height:${state.extendedImageInfo.image.height}');
                                return ExtendedRawImage(
                                  image: state.extendedImageInfo?.image,
                                );
                                break;
                              case LoadState.failed:
                                return GestureDetector(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: <Widget>[

                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Text(
                                          "load image failed, click to reload",
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                  onTap: () {
                                    state.reLoadImage();
                                  },
                                );
                                break;
                            }
                            return Container();
                        },
                        mode: ExtendedImageMode.gesture,
                        initGestureConfigHandler: (state) {
                          return GestureConfig(
                            minScale: 0.9,
                            animationMinScale: 0.7,
                            maxScale: 3.0,
                            animationMaxScale: 3.5,
                            speed: 1.0,
                            inertialSpeed: 100.0,
                            initialScale: 1.0,
                            inPageView: false,
                            initialAlignment: InitialAlignment.center,
                          );
                        },
                        onDoubleTap: (ExtendedImageGestureState state) {
                          ///you can use define pointerDownPosition as you can,
                          ///default value is double tap pointer down postion.
                          var pointerDownPosition = state.pointerDownPosition;
                          double begin = state.gestureDetails.totalScale;
                          double end;
                          print('双击图片');

                        },
                      ),
                      Text(
                        _posterListModelList[index].name,
                        style: TextStyle(
                            color: color.computeLuminance() < 0.5 ? Colors.white:Colors.black
                        ),
                      )
                    ],
                  ),
                  // height: ((index % 3) + 1) * 100.0,
                );
              },
                childCount: _posterListModelList?.length ?? 0
              ),
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  collectGarbage: (List<int> garbages){
                    print('collect garbage : $garbages');
                  },
                  viewportBuilder: (int firstIndex, int lastIndex){
                    print('viewport : [$firstIndex,$lastIndex]');
                  }
              )
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              color: Colors.red,
              alignment: Alignment.center,
              child: const Text(
                'I\'m other slivers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Color getRandomColor(int index) {
    if (index >= colors.length) {
      colors.add(Color.fromARGB(255, Random.secure().nextInt(255),
          Random.secure().nextInt(255), Random.secure().nextInt(255)));
    }

    return colors[index];
  }

  void loadListData() async{
    var params = APPInfo.getRequestnomalparams(APPInfo.getFirstHeader()[APPInfo.ApiVersionKey]);
    params.addAll({
      // "typeParentId":11
      "typeId":10,
      "pageSize": _pageSize,
      "pageIndex":_pageIndex,
      'userMobile': '18311055781',
      'userId': 1833334
    });
    _posterListModelList = await RequestManager.getPosterListData(params);
    setState(() {

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print('销毁');
    super.dispose();
  }
}