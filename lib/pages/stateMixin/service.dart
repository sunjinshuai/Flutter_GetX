import 'package:flutter_app/common/utils/http_util.dart';
import 'package:flutter_app/pages/stateMixin/model.dart';

class JuejinService {
  Future<PersonalEntity?> getPersonalProfile(String userId) async {
    var response = await HttpUtil.getDioInstance()
        .get('https://api.juejin.cn/user_api/v1/user/get?user_id=$userId');
    if (response.statusCode == 200) {
      if (response.data['err_no'] == 0) {
        return PersonalEntity.fromJson(response.data['data']);
      }
    }
    return null;
  }
}
