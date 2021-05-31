import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_videolist/actions/sputil.dart';
import 'package:flutter_app_videolist/image_operation/OperationImage.dart';
import 'package:flutter_app_videolist/list_pull/listpull.dart';
import 'package:flutter_app_videolist/list_pull/listpull2.dart';
import 'package:flutter_app_videolist/video/video_list_page.dart';
import 'package:flutter_app_videolist/video/video_player_page.dart';
import 'package:flutter_app_videolist/view/memory_usage_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
/// 监视页面切换(RouteObserver & RouteAware)
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SpUtil.getInstance().then((value) {
    runApp(MyApp());
  });
}
RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder:() => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            // 主题色
            primarySwatch: Colors.blue,
          ),
          builder: (BuildContext c, Widget w){
            //重写修改widget，在视图上添加一个浮动视图
            w = Stack(
              children: <Widget>[
                Positioned.fill(child: w),
                MemoryUsageView()

              ],
            );
            // if (!kIsWeb) {
            //   final MediaQueryData data = MediaQuery.of(c);
            //   w = MediaQuery(
            //     data: data.copyWith(textScaleFactor: 1.0),
            //     child: w,
            //   );
            // }
            return w;
          },
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver], //添加路由观察者
          home: OperationImagePage()
          // MultipleVideoPlayerPage(dynamicResourcesId: "0",),
        )
    );
  }
}
