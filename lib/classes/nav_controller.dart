import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavController extends GetxController {

  late PageController pageController;

  RxInt currentPage = 0.obs;

  navPage(int page){
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

}