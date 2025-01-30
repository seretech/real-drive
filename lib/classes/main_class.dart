import 'package:flutter/material.dart';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app_color.dart';

class MainClass {

  static bH(sz) {
    double a1 = sz.toDouble();
    return SizedBox(height: a1);
  }

  static bW(sz) {
    double a1 = sz.toDouble();
    return SizedBox(width: a1);
  }

  static txtW4(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtW4I(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtW5(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w500));
  }

  static txtW6(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        style: TextStyle(color: Colors.white, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w600));
  }

  static txtN4(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        softWrap: true,
        style: TextStyle(color: AppColor.colorApp, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w400));
  }

  static txtN5(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        softWrap: true,
        style: TextStyle(color: AppColor.colorApp, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w500));
  }

  static txtN6(txt, sz) {
    double a1 = sz.toDouble();
    return Text(txt,
        softWrap: true,
        style: TextStyle(color: AppColor.colorApp, fontSize: a1, fontFamily: 'Satoshi', fontWeight: FontWeight.w600));
  }

  static txtStyle() {
    return const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Satoshi');
  }

  static hintStyle() {
    return TextStyle(color: AppColor.colorAppGray, fontSize: 14);
  }

  static btnSty() {
    return ElevatedButton.styleFrom(
      splashFactory: NoSplash.splashFactory,
      backgroundColor: AppColor.colorApp,
      minimumSize: const Size.fromHeight(60),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static conDecor(r, c, b, col) {
    double r1 = r.toDouble();
    double b1 = b.toDouble();
    return BoxDecoration(
      color: col,
      borderRadius: BorderRadius.circular(r1),
      border: Border.all(
        color: c,
        width: b1,
      ),
    );
  }

  static padA(i) {
    double a = i.toDouble();
    return EdgeInsets.all(a);
  }

  static padS(t, l) {
    double ver = t.toDouble();
    double hor = l.toDouble();
    return EdgeInsets.only(top: ver, bottom: ver, left: hor, right: hor);
  }

  static loadingBtn() {
    return ElevatedButton(
      onPressed: () {},
      style: btnSty(),
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 1.5,
      ),
    );
  }

  static boardChk(ctx) {
    return MediaQuery.of(ctx).viewInsets.bottom != 0;
  }

  static err(msg) {
    return Get.snackbar(
      'Error',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      padding: MainClass.padS(4, 8),
    );
  }

  static sus(msg) {
    return Get.snackbar(
      'Success',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      padding: MainClass.padS(4, 8),
    );
  }

  static getRatings(double aa){
    return Column(
      children: [
        if(aa == 0)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
            ],
          ),
        if(aa == 1)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
            ],
          ),
        if(aa == 2)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
            ],
          ),
        if(aa == 3)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
            ],
          ),
        if(aa == 4)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorAppGray.withValues(alpha: 0.5), size: 20),
            ],
          ),
        if(aa == 5)
          Row(
            children: [
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
              Icon(Icons.star, color: AppColor.colorApp, size: 20),
            ],
          ),
      ],
    );
  }

  static divide() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MainClass.bH(8),
        Container(
          color: Colors.blueGrey.withValues(alpha: 0.4),
          height: 1,
          width: double.infinity,
        ),
        MainClass.bH(8),
      ],
    );
  }

  static editIC() {
    return Padding(
      padding: padS(2, 8),
      child: Row(
        children: [
          MainClass.txtN5('Edit', 14),
          MainClass.bW(2),
          Icon(Icons.edit, size: 16),
        ],
      ),
    );
  }

  static getData(String s) {
    GetStorage box = GetStorage();
    var js = box.read('user');
    String res = '';
    if(js != null){
      if(s == 'firstname'){
        res = js['firstname'].toString();
      } else if(s == 'lastname'){
        res = js['lastname'].toString();
      } else if(s == 'phone'){
        res = js['phone'].toString();
      } else if(s == 'email'){
        res = js['email'].toString();
      }
    }


    return res;
  }

  static getToken() {
    GetStorage box = GetStorage();
    return 'Bearer ${box.read('token')}';
  }

  static getAddress(double myLat, double myLong) async {
    String add = 'Lagos';

    await placemarkFromCoordinates(myLat, myLong)
        .then((place) {
      if (place.isNotEmpty) {
        String na = place[0].name.toString();
        String str = place[0].street.toString();
        String subAdmin = place[0].subAdministrativeArea.toString();
        String admin = place[0].administrativeArea.toString();
        String subLocal = place[0].subLocality.toString();
        String local = place[0].locality.toString();

        if (str.contains(na)) {
          add = str;
        } else {
          add = '$na, $str';
        }

        if(subAdmin != '' && admin != ''){
          add = '$add, $subAdmin, $admin';
        } else {
          if(subLocal != '' && local != ''){
            add = '$add , $subLocal, $local';
          }
          else {
            if(local != ''){
              add = '$add , $local';
            } else {
              if(subLocal != ''){
                add = '$add , $local';
              }
            }
          }
        }
      } else{
        add = 'Location unavailable';
      }
    });

    return add;

  }

}
