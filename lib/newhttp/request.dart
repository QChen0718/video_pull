import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/appinfo.dart';
// import 'package:hqp_enterprise/common/app_global.dart';
// import 'package:hqp_enterprise/common/event/event_bus.dart';
// import 'package:hqp_enterprise/common/event/event_models.dart';
import 'package:flutter_app_videolist/model/basemodel.dart';
import 'package:flutter_app_videolist/actions/toast_util.dart';

import 'result_code.dart';

enum Method { get, post, put, delete }

enum ContentType { form, applicationJson }

class Request {
  //写一个单例
  static Request instance;

  static Request getInstance() {
    if (instance == null) {
      instance = Request();
    }
    return instance;
  }

  Dio dio = new Dio();

  Request() {
    //请求基地址
//    设置连接超时的时间 30 秒
    dio.options.connectTimeout = 10000;
//    接收超时的时间 3 秒
    dio.options.receiveTimeout = 3000;
//    是否开启网络请求日志
    dio.interceptors.add(LogInterceptor(requestBody: APPInfo.isDebug));
    //请求与响应拦截器
    dio.interceptors.add(OnReqResInterceptors());
    //  异常拦截器
    dio.interceptors.add(OnErrorInterceptors());
    //  证书本地不做证书校验
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        print('证书不做校验');
        return true;
      };
    };
  }

//  get请求
  Future get({@required String url, Map<String, dynamic> params, bool isNew = false}) async {
    // if (Global.getIsOpenDelegate()) {
    //   print('开启代理-get请求');
    //   _charlesDelegate();
    // }
    return await _requestHttp(url, method: Method.get, params: params);
  }

//  post请求
  Future post({@required String url, Map<String, dynamic> params, ContentType type = ContentType.applicationJson, bool isNew = false}) async {
    // if (Global.getIsOpenDelegate()) {
    //   print('开启代理-post请求');
    //   _charlesDelegate();
    // }
    return await _requestHttp(url, method: Method.post, params: params ?? {}, type: type);
  }

//  put请求
  Future put({@required String url, Map<String, dynamic> params, bool isNew = false}) async {
    // if (Global.isDebug) {
    //   print('开启代理-put请求');
    //   _charlesDelegate();
    // }
    return await _requestHttp(url, method: Method.put, params: params);
  }

  //  delete请求
  Future delete({@required String url, Map<String, dynamic> params, bool isNew = false}) async {
    // if (Global.isDebug) {
    //   print('开启代理-delete请求');
    //   _charlesDelegate();
    // }
    return await _requestHttp(url, method: Method.delete, params: params);
  }

//  charles 监听网络代理
//   _charlesDelegate() {
//     (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
//       client.findProxy = (Uri uri) {
//         String ipAddress = Global.ipAddress ?? "";
//         if (ipAddress.length > 0) {
//           print('开启代理-设置ip == ' + ipAddress);
//           return "PROXY " + ipAddress + ":8888";
//         } else {
//           print('开启代理-默认设置ip == ' + ipAddress);
//           //不设置代理
//           return 'DIRECT'; //"PROXY 192.169.253.193:8888";
//         }
//         // return "PROXY 192.168.253.194:8888";dy
//         // return "PROXY 192.168.2.8:8888";
//       };
//     };
//   }

//  请求网络
  Future _requestHttp(String url, {Method method = Method.get, Map<String, dynamic> params, ContentType type = ContentType.applicationJson}) async {
    dio.options.baseUrl = APPInfo.BASE_URL;
    dio.options.headers = APPInfo.getNewRequestnomalparams('1.0.0');
    if (params == null) {
      params = {};
    }
    const methodValues = {Method.get: 'get', Method.post: 'post', Method.delete: 'delete', Method.put: 'put'};
    Map<String, dynamic> param = {};
    params.addAll(param);
    try {
      Response response;
      switch (method) {
        case Method.get:
          if (params != null && params.isNotEmpty) {
            response = await dio.get(url, queryParameters: params);
          } else {
            response = await dio.get(url);
          }
          break;
        default:
          response = await dio.request(url, data: params, options: Options(method: methodValues[method]));
      }
      //后台返回的数据类型不统一所以做了处理
      Map<String, dynamic> dataMap;
      if (response.data is String) {
        dataMap = json.decode(response.data);
      } else {
        String dataStr = json.encode(response.data);
        dataMap = json.decode(dataStr);
      }
      print("返回结果 =====  \n");
      print(dataMap);

      var baseModel = BaseModel.fromJson(dataMap);
      if (baseModel.errMsg != '' && baseModel.errMsg != null ) {}
      //返回请求结果
      return baseModel;
    } on DioError catch (error) {
      return null;
    }
  }
}

class OnInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);
  }
}

// 请求与响应拦截器
class OnReqResInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest

    if (APPInfo.isDebug) {
      print('请求url: ' + options.baseUrl + options.path);
      print('请求头: ' + options.headers.toString());
      if (options.data != null) {
        print('请求参数: ' + options.data.toString());
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    super.onResponse(response, handler);

    Response res = response;
    if (response != null) {
      if (APPInfo.isDebug) {
        print('响应：${response.toString()}');
      }
    }
    if (response.statusCode == 200) {
      int errCode;
      String msg = "";
      //这块做特殊处理主要是后台接口的返回数据不统一所以暂时先这样处理
      if (response.data is String) {
        Map<String, dynamic> errorMap = json.decode(response.data);
        errCode = errorMap['code'];
        if ((errorMap['message'] != null || errorMap['msg'] != null) &&
            (errorMap['message'].toString().length > 0 || errorMap['msg'].toString().length > 0)) {
          if (errorMap['message'].toString().length > 0) {
            msg = errorMap['message'];
          } else {
            msg = errorMap['msg'];
          }
        }
      } else {
        errCode = response.data['code'];
        if ((response.data['message'] != null || response.data['msg'] != null)) {
          if (response.data['message'] != null) {
            msg = response.data['message'];
          } else {
            msg = response.data['msg'];
          }
        }
      }

      //成功
      if (errCode == ResultCode.SUCCESS) {
        res = response;
      } else {
        //修改提示信息，msg为空不显示 修改msg类型报错

        // 处理自定义错误,后续有新的错误码可以在这继续添加
        switch (errCode) {
          case ResultCode.ERROR_BANNED_CODE:
          case ResultCode.LOGIN_OTHER:
          case ResultCode.ERROR_INVALID_TOKEN_CODE:
          case ResultCode.ERROR_LACK_TOKEN_CODE:
            ToastOk.show(msg: '登录异常,请重新登录');

            /// 跳转到登录页
            res = response;
            // RepairEvent.event.fire(JumpToLoginEvent());
            break;
          case ResultCode.ERROR_PASSWORD:
            if (msg.length > 0) {
              ToastOk.show(msg: msg);
            }
            res = response;
            break;
          case ResultCode.CONNECT_TIMEOUT:
            if (msg.length > 0) {
              ToastOk.show(msg: msg);
            }
            res = response;
            break;
          default:
            if (msg.length > 0) {
              ToastOk.show(msg: msg);
            }
            res = response;
            break;
        }
      }
    }
  }
}

// OnError 拦截器
class OnErrorInterceptors extends InterceptorsWrapper {
  //  异常拦截
  // @override
  // Future onError(DioError err) {
  //   // TODO: implement onError
  //   // if (Global.isDebug) {
  //   print('请求异常：${err.toString()}');
  //   print('请求异常信息: ${err.response?.toString() ?? ""}');
  //   String errorMsg = err.error.toString() ??
  //       err.response?.toString() ??
  //       err.toString() ??
  //       "";
  //
  //   ToastOk.show(msg: errorMsg);
  //
  //   return super.onError(err);
  // }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);

    // if (Global.isDebug) {
    print('请求异常：${err.toString()}');
    print('请求异常信息: ${err.response?.toString() ?? ""}');
    String errorMsg = err.error.toString() ?? err.response?.toString() ?? err.toString() ?? "";

    ToastOk.show(msg: errorMsg);
  }
}
