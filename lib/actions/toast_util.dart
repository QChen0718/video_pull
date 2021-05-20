import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastOk {
  ///此toast 和输入法弹出使用会有问题  输入框提示时慎用
  static show(
      {String msg,
      Toast toastLength,
      int gravity = 0,
      int timeInSecForIos = 1,
      double fontSize = 16.0,
      Color backgroundColor,
      Color textColor}) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: backgroundColor ?? Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
