class PersonalEntity {
  PersonalEntity._privateConstructor();
  late String _userId;
  String get userId => _userId;

  late String _userName;
  String get userName => _userName;

  late String _company;
  late String _job;
  String get jobDescription => _job + ' @ ' + _company;

  late String _description;
  String get description => _description;
  late String _avatar;
  String get avatar => _avatar;

  late int _level;
  String get level => 'Lv$_level';

  late int _power;
  int get power => _power;

  late int _followeeCount;
  int get followeeCount => _followeeCount;
  late int _followerCount;
  int get followerCount => _followerCount;

  static PersonalEntity fromJson(Map<String, dynamic> json) {
    PersonalEntity newPersonal = PersonalEntity._privateConstructor();
    newPersonal._userId = json['user_id'];
    newPersonal._userName = json['user_name'];
    newPersonal._company = json['company'];
    newPersonal._job = json['job_title'];
    newPersonal._description = json['description'];
    newPersonal._avatar = json['avatar_large'];
    newPersonal._level = json['level'];
    newPersonal._power = json['power'];
    newPersonal._followeeCount = json['followee_count'];
    newPersonal._followerCount = json['follower_count'];

    return newPersonal;
  }
}
