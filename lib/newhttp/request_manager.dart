import 'package:flutter_app_videolist/actions/appinfo.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/newhttp/api_urls.dart';
import 'package:flutter_app_videolist/newhttp/request.dart';
import 'package:flutter_app_videolist/model/basemodel.dart';


class RequestManager {
  ///登录接口
  static Future enterpriseLogin(String phone, String password) async {
    var params = APPInfo.getRequestnomalparams(APPInfo.getFirstHeader()[APPInfo.ApiVersionKey]);
    Map<String,dynamic>dict = {
      'userName':phone,
      'loginType':'0',
      'password':APPInfo.generateMd5(password)
    };
    params.addAll(dict);
    BaseModel response = await Request.getInstance().post(url: ApiUrls.REQUEST_URL_LOGIN, params: params);
    if (response == null) {
      return null;
    }
    return response;
  }

/// 获取视频列表数据
  static Future<VideoListDataModel> getVideoListData(Map<String,dynamic> params) async {
    BaseModel response = await Request.getInstance().post(url: ApiUrls.REQUEST_GET_VIDEO_LIST, params: params);
    if (response == null) {
      return null;
    }
    return VideoListDataModel.fromJson(response.data);
  }


}
