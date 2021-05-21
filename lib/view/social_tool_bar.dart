import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/model/videolistmodel.dart';
import 'package:flutter_app_videolist/video/video_list_page.dart';
import 'package:lottie/lottie.dart';
// import 'package:gfapp/route/navigator_util.dart';
// import 'package:gfapp/widgets/button/custom_like_button.dart'; //点赞
// import 'package:gfapp/widgets/button/favorite_button.dart'; //收藏
// import 'package:gfapp/widgets/button/share_button.dart'; //分享
// import 'package:gfapp/widgets/image/avatar.dart';

class SocialToolBar extends StatelessWidget {
  /// 视频数据源
  final VideoListSubDataModel video;
  SocialToolBar({Key key, @required this.video})
      : assert(video != null),
        super(key: key);

  static const double ActionWidgetSize = 60.0;
  static const double ActionIconSize = 35.0;
  static const double ShareActionIconSize = 25.0;
  static const double ProfileImageSize = 50.0;
  static const double PlusIconSize = 20.0;
  ValueNotifier<bool> isFavorite = ValueNotifier(false);
  ValueNotifier<bool> isStar = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 100.0,
        right: 5,
      ),
      child: Align(
          alignment: Alignment.bottomRight,
          widthFactor: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _getFollowAction(context),
              SizedBox(height: 10),
              Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: isFavorite, 
                      builder: (context,value,child){
                        return GestureDetector(
                          child: Offstage(
                            offstage: false ,
                            child: value == true ? Lottie.asset('images/favorite.json',width: 35.0,height: 35.0,repeat: false,fit: BoxFit.fill): Icon(Icons.favorite_rounded,
                                size: 35.0, color: Colors.white),
                          ),
                          onTap: (){
                            isFavorite.value = !value;
                          },
                        );
                      }
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text('666',
                        style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  )
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ValueListenableBuilder(
                      valueListenable: isStar,
                      builder: (context,value,child){
                        return GestureDetector(
                          child: Offstage(
                            offstage: false ,
                            child: value == true ? Lottie.asset('images/star.json',width: 35.0,height: 35.0,repeat: false,fit: BoxFit.fill): Icon(Icons.star_rounded,
                                size: 35.0, color: Colors.white),
                          ),
                          onTap: (){
                            isStar.value = !value;
                          },
                        );
                      }
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text('666',
                        style: TextStyle(fontSize: 12.0, color: Colors.white)),
                  )
                ],
              ),
              SizedBox(height: 10),
              _getShareAction(Axis.vertical),
            ],
          )),
    );
  }

  Widget _getFollowAction(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      width: 60.0,
      height: 60.0,
      child: Stack(children: [_getProfilePicture(context)]),
    );
  }

  Widget _getPlusIcon() {
    return Positioned(
      bottom: 0,
      left: ((ActionWidgetSize / 2) - (PlusIconSize / 2)),
      child: Container(
          width: PlusIconSize,
          height: PlusIconSize,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 43, 84),
              borderRadius: BorderRadius.circular(15.0)),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 20.0,
          )),
    );
  }

  Widget _getProfilePicture(BuildContext cxt) {
    return Positioned(
      left: (ActionWidgetSize / 2) - (ProfileImageSize / 2),
      child: GestureDetector(
        onTap: () {
          Navigator.push(cxt, MaterialPageRoute(builder: (context) => VideoListPage()));
        },
        //圆角头像
        child: CircleAvatar(
          child: Image.asset(
              'images/icon_user.png',
            width: ProfileImageSize,
            height: ProfileImageSize,
          ),
          radius: ProfileImageSize/2,
        )
      ),
    );
  }

  Widget _getShareAction(Axis direction) {
    bool horizontal = direction == Axis.horizontal;
    List<Widget> children = [
      Icon(Icons.reply, size: 35.0, color: Colors.white),
      SizedBox(width: horizontal ? 2 : 0, height: horizontal ? 0 : 2),
      Text(
        '分享',
        style: TextStyle(fontSize: 12.0, color: Colors.white),
      ),
    ];
    return Container(
      child: Column(children: children),
      // ShareButton(
      //   child:
      //    水平，垂直
      //       horizontal ? Row(children: children) : Column(children: children),
      //   shareModel: ShareModel(
      //     webPage:
      //         'https://m.kungfualumni.com/newsDetail?id=${video?.dynamicValue?.dynamicId}',
      //     title: '${stringNull(video?.dynamicValue?.memberName)}的【功夫链】动态',
      //     momentsTitle: video?.dynamicValue?.content != null
      //         ? video?.dynamicValue?.content
      //         : '${stringNull(video?.dynamicValue?.memberName)}的【功夫链】动态',
      //     description: video?.dynamicValue?.content,
      //     thumbnailUrl: video?.dynamicResources?.fm ?? '',
      //   ),
      // ),
    );
  }

  String stringNull(String str) {
    if (null == str) {
      return '';
    } else {
      return str;
    }
  }
}
