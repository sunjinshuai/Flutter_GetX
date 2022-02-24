import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/stateMixin/controller.dart';
import 'package:flutter_app/pages/stateMixin/model.dart';
import 'package:get/get.dart';

class PersonalHomePageMixin extends GetView<PersonalMixinController> {
  PersonalHomePageMixin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (personalEntity) => _PersonalHomePage(personalProfile: personalEntity!),
      onLoading: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      ),
      onError: (error) => Center(
        child: Text(error!),
      ),
      onEmpty: Center(
        child: Text('暂无数据'),
      ),
    );
  }
}

class _PersonalHomePage extends StatelessWidget {
  final PersonalEntity personalProfile;
  const _PersonalHomePage({Key? key, required this.personalProfile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("stateMixin"),
      ),
      body: CustomScrollView(
        slivers: [
          _getBannerWithAvatar(context, personalProfile),
          _getPersonalProfile(personalProfile),
          _getPersonalStatistic(personalProfile),
        ],
      ),
    );
  }

  Widget _getBannerWithAvatar(
      BuildContext context, PersonalEntity personalProfile) {
    const double bannerHeight = 230;
    const double imageHeight = 180;
    const double avatarRadius = 45;
    const double avatarBorderSize = 4;
    return SliverToBoxAdapter(
      child: Container(
        height: bannerHeight,
        color: Colors.white70,
        alignment: Alignment.topLeft,
        child: Stack(
          children: [
            Container(
              height: bannerHeight,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: CachedNetworkImage(
                imageUrl:
                    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=688497718,308119011&fm=26&gp=0.jpg',
                height: imageHeight,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              left: 20,
              top: imageHeight - avatarRadius - avatarBorderSize,
              child: _getAvatar(
                personalProfile.avatar,
                avatarRadius * 2,
                avatarBorderSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAvatar(String avatarUrl, double size, double borderSize) {
    print('build Avatar');
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: size + borderSize * 2,
        height: size + borderSize * 2,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size / 2 + borderSize),
        ),
      ),
      Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(size / 2),
        ),
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          height: size,
          width: size,
          fit: BoxFit.fill,
        ),
      ),
    ]);
  }

  Widget _getPersonalProfile(PersonalEntity personalProfile) {
    print('build PersonalProfile');
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
        color: Colors.white70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  personalProfile.userName,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  width: 3,
                ),
                _getLevel(personalProfile.level),
              ],
            ),
            SizedBox(height: 2),
            Text(
              personalProfile.jobDescription,
              style: TextStyle(fontSize: 15.0, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Text(
              personalProfile.description,
              style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLevel(String level) {
    return Container(
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      child: Text(
        level,
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _getPersonalStatistic(PersonalEntity personalProfile) {
    print('build PersonalStatistic');

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white70,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getStatisticDesc('关注', personalProfile.followeeCount),
            SizedBox(
              width: 20,
            ),
            _getStatisticDesc('关注者', personalProfile.followerCount),
            SizedBox(
              width: 20,
            ),
            _getStatisticDesc('掘力值', personalProfile.power),
          ],
        ),
      ),
    );
  }

  Widget _getStatisticDesc(String itemName, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          itemName,
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
