import 'package:flutter_app/pages/home/index.dart';
import 'package:flutter_app/pages/list/index.dart';
import 'package:flutter_app/pages/list_detail/index.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = AppRoutes.Home;

  static final routes = [
    GetPage(
      name: AppRoutes.Home,
      page: () => HomeView(),
      children: [
        GetPage(
          name: AppRoutes.List,
          page: () => ListView(),
          children: [
            GetPage(
              name: AppRoutes.Detail,
              page: () => DetailView(),
            ),
          ],
        ),
      ],
    ),
  ];
}
