import 'package:flutter_app/pages/stateMixin/model.dart';
import 'package:flutter_app/pages/stateMixin/service.dart';
import 'package:get/get.dart';

class PersonalMixinController extends GetxController
    with StateMixin<PersonalEntity> {
  final String userId;
  PersonalMixinController({required this.userId});
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getPersonalProfile(userId);
  }

  void getPersonalProfile(String userId) async {
    change(null, status: RxStatus.loading());
    var personalProfile = await JuejinService().getPersonalProfile(userId);
    if (personalProfile != null) {
      change(personalProfile, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.error('获取个人信息失败'));
    }
  }
}
