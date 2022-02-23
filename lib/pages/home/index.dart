import 'package:flutter/material.dart';
import 'package:flutter_app/pages/list_detail/index.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

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
        ],
      ),
    );
  }
}
