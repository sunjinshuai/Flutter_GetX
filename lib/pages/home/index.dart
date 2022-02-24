import 'package:flutter/material.dart';
import 'package:flutter_app/common/routes/app_pages.dart';
import 'package:flutter_app/pages/list_detail/index.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  _showSnackbar(Map? result) {
    if (result != null) {
      Get.snackbar("返回值", "success -> " + result["success"].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("首页"),
      ),
      body: ListView(
        children: [
          // 路由&导航
          Divider(),
          ListTile(
            title: Text("导航-命名路由 home > list"),
            subtitle: Text('Get.toNamed("/home/list")'),
            onTap: () => Get.toNamed("/home/list"),
          ),
          ListTile(
            title: Text("导航-命名路由 home > list > detail"),
            subtitle: Text('Get.toNamed("/home/list/detail")'),
            onTap: () => Get.toNamed("/home/list/detail"),
          ),
          ListTile(
            title: Text("导航-类对象"),
            subtitle: Text("Get.to(DetailView())"),
            onTap: () => Get.to(DetailView()),
          ),
          ListTile(
            title: Text("导航-清除上一个"),
            subtitle: Text("Get.off(DetailView())"),
            onTap: () => Get.off(DetailView()),
          ),
          ListTile(
            title: Text("导航-清除所有"),
            subtitle: Text("Get.offAll(DetailView())"),
            onTap: () => Get.offAll(DetailView()),
          ),
          ListTile(
            title: Text("导航-arguments传值+返回值"),
            subtitle: Text(
                'Get.toNamed("/home/list/detail", arguments: {"id": 999})'),
            onTap: () async {
              var result = await Get.toNamed("/home/list/detail",
                  arguments: {"id": 999});
              _showSnackbar(result);
            },
          ),
          ListTile(
            title: Text("导航-parameters传值+返回值"),
            subtitle: Text('Get.toNamed("/home/list/detail?id=666")'),
            onTap: () async {
              var result = await Get.toNamed("/home/list/detail?id=666");
              _showSnackbar(result);
            },
          ),
          ListTile(
            title: Text("导航-参数传值+返回值"),
            subtitle: Text('Get.toNamed("/home/list/detail/777")'),
            onTap: () async {
              var result = await Get.toNamed("/home/list/detail/777");
              _showSnackbar(result);
            },
          ),
          ListTile(
            title: Text("导航-not found"),
            subtitle: Text('Get.toNamed("/aaa/bbb/ccc")'),
            onTap: () => Get.toNamed("/aaa/bbb/ccc"),
          ),
          ListTile(
            title: Text("导航-中间件-认证Auth"),
            subtitle: Text('Get.toNamed("/my")'),
            onTap: () => Get.toNamed('/my'),
          ),
          Divider(),
          // state 状态
          ListTile(
            title: Text("State-Obx"),
            subtitle: Text('Get.toNamed(AppRoutes.Obx)'),
            onTap: () => Get.toNamed(AppRoutes.State + AppRoutes.Obx),
          ),
        ],
      ),
    );
  }
}
