import 'package:flutter/material.dart';

import 'package:get/get.dart';

class StateObxView extends StatelessWidget {
  StateObxView({Key? key}) : super(key: key);

  final count1 = 0.obs;
  final count2 = 0.obs;
  final count3 = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Obx(...)"),
      ),
      body: Center(
        child: Column(
          children: [
            Obx(() => Text("count1 -> " + count1.toString())),
            Obx(() => Text("count2 -> " + count2.toString())),
            Obx(() => Text("count3 -> " + count3.toString())),
            Divider(),
            ElevatedButton(
              onPressed: () {
                count1.value++;
                count3.value++;
              },
              child: Text('add'),
            ),
          ],
        ),
      ),
    );
  }
}
