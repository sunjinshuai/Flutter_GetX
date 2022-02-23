import 'package:flutter_app/common/middleware/router_auth.dart';
import 'package:flutter_app/pages/home/index.dart';
import 'package:flutter_app/pages/list/index.dart';
import 'package:flutter_app/pages/list_detail/index.dart';
import 'package:flutter_app/pages/login/index.dart';
import 'package:flutter_app/pages/my/index.dart';
import 'package:flutter_app/pages/notfound/index.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Home;

  static final routes = [
    // 白名单
    GetPage(
      name: AppRoutes.Login,
      page: () => LoginView(),
    ),

    // 我的，需要认证
    GetPage(
      name: AppRoutes.My,
      page: () => MyView(),
      middlewares: [
        RouteAuthMiddleware(priority: 1),
      ],
    ),

    GetPage(
      name: AppRoutes.Home,
      page: () => HomeView(),
      children: [
        GetPage(
          name: AppRoutes.List,
          page: () => ListIndexView(),
          children: [
            GetPage(
              name: AppRoutes.Detail,
              page: () => DetailView(),
            ),
            GetPage(
              name: AppRoutes.Detail_ID,
              page: () => DetailView(),
              transition: Transition.downToUp,
            ),
          ],
        ),
      ],
    ),
  ];

  static final unknownRoute = GetPage(
    name: AppRoutes.NotFound,
    page: () => NotfoundView(),
  );
}
