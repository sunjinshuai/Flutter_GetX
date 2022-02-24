import 'package:flutter_app/pages/stateMixin/controller.dart';
import 'package:get/get.dart';

class PersonalStateMixinBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PersonalMixinController>(
      () => PersonalMixinController(userId: '1521379823060024'),
    );
  }
}
