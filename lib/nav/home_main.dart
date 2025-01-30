import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:realdrive/classes/nav_controller.dart';
import 'package:realdrive/nav/history.dart';
import 'package:realdrive/nav/profile.dart';

import '../classes/app_color.dart';
import 'home.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _State();
}

class _State extends State<HomeMain> {

  int pageIndex = 0;

  var screens = [
    const Home(),
    const History(),
    const Profile(),
  ];

  final NavController controller = Get.put(NavController());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, v) {
        if (!b) {
          MoveToBackground.moveTaskToBack();
          return;
        }
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: controller.pageController,
            children: screens,
          ),
          bottomNavigationBar: Obx(
            () =>
            BottomNavigationBar(
              enableFeedback: false,
              elevation: 0,
              backgroundColor: Colors.white,
              selectedItemColor: AppColor.colorApp,
              unselectedItemColor: AppColor.colorAppGray,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(color: AppColor.colorApp),
              unselectedLabelStyle: TextStyle(color: Colors.grey),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: pageIndex,
              onTap: (index) {
                controller.navPage(index);
                pageIndex = controller.currentPage.value;
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded, color: controller.currentPage.value == 0 ? AppColor.colorApp : Colors.grey),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded, color: controller.currentPage.value == 1 ? AppColor.colorApp : Colors.grey),
                  label: 'History',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_rounded, color: controller.currentPage.value == 2 ? AppColor.colorApp : Colors.grey),
                  label: 'Account',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
