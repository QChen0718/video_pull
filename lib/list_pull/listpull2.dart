import 'dart:math';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/model/posterlistmodel.dart';
import 'package:flutter_app_videolist/newhttp/request_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class PullListPage extends StatefulWidget{
  @override
  _PullListPageState createState() => _PullListPageState();
}
class _PullListPageState extends State<PullListPage>{
  int _pageSize = 10;
  int _pageIndex = 1;
  List<PosterListDataModel> _posterListModelList;
  List<IntSize> _sizes;
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
        title: Text('测试'),
      ),
      body: StaggeredGridView.builder(
        itemCount: _posterListModelList?.length ?? 0,
        itemBuilder: (context,index){
          return Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.center,
              child: ExtendedImage.network(
                'https://picsum.photos/${_sizes[index].width}/${_sizes[index].height}/',
                // APPInfo.HTTP_IMAGE_DOWNLOAD_REQUEST_URL + _posterListModelList[index].image,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
        gridDelegate: SliverStaggeredGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          staggeredTileBuilder: (index){
            return StaggeredTile.fit(1);
          },
          staggeredTileCount: 10
        ),
      ),
    );
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
   _sizes = _createSizes(_posterListModelList.length);
    setState(() {

    });
  }
}
class IntSize {
  const IntSize(this.width, this.height);

  final int width;
  final int height;
}
List<IntSize> _createSizes(int count) {
  final rnd = Random();
  return List.generate(
      count, (i) => IntSize(rnd.nextInt(500) + 200, rnd.nextInt(800) + 200));
}