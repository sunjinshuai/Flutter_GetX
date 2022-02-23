import 'package:flutter/material.dart';
import 'package:flutter_app/pages/list_detail/index.dart';
import 'package:get/get.dart';

class ListIndexView extends StatelessWidget {
  const ListIndexView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("列表页"),
      ),
      body: ListView(
        children: [
          // 路由&导航
          Divider(),
          ListTile(
            title: Text("导航-命名路由 list > detail"),
            subtitle: Text('Get.off(DetailView())'),
            onTap: () {
              Get.off(DetailView());
            },
          ),
        ],
      ),
    );
  }
}
