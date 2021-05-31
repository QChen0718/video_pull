import 'dart:ui';

import 'package:flutter/material.dart';

class MemoryUsageView extends StatefulWidget{
  @override
  _MemoryUsageViewState createState() => _MemoryUsageViewState();
}
class _MemoryUsageViewState extends State<MemoryUsageView>{
  double _top = 0;
  double _left = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _top = window.physicalSize.height / window.devicePixelRatio / 2 - 80;
    _left = window.physicalSize.width / window.devicePixelRatio / 2 - 40;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Positioned(
        top: _top,
        left: _left,
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails dragUpdateDetails){
            print('dy:$_top dx:$_left');
            print('width:${MediaQuery.of(context).size.width}');
            if(_left < 0 || _left > 328){
              if(_left>328){
                _left = 328;
              }else {
                _left = 0;
              }
              setState(() {
                _top += dragUpdateDetails.delta.dy;
              });
              return;
            }
            if(_top < 44){
              _top = 44;
              setState(() {
                _left += dragUpdateDetails.delta.dx;
              });
              return;
            }
            setState(() {
              _top += dragUpdateDetails.delta.dy;
              _left += dragUpdateDetails.delta.dx;
            });
          },
          child: DefaultTextStyle(
              style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.68)),
            child:Container(
              color: Colors.black.withOpacity(0.5),
              width: 100,
              height: 200,
              child: Text('浮动视图',style: TextStyle(color: Colors.white,fontSize: 20)),
            )
          ),
        )
    );
  }
}