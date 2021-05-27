import 'package:flutter/cupertino.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';

class MySliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  MySliverChildBuilderDelegate(
      Widget Function(BuildContext,int) builder,{
      int childCount,
      bool addAutomaticKeepAlives = true,
      bool addRepaintBoundaries = true,
  }):super(builder,
    childCount: childCount,
    addAutomaticKeepAlives: addAutomaticKeepAlives,
    addRepaintBoundaries: addRepaintBoundaries
  );
  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    // TODO: implement didFinishLayout
    super.didFinishLayout(firstIndex, lastIndex);
    // print('firstIndex: $firstIndex, lastIndex: $lastIndex');
    APPInfo.index = firstIndex + 1;
  }
}