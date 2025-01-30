import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:realdrive/classes/main_class.dart';

import '../nav/home_main.dart';

class ApiConnect extends GetConnect {

  String setBaseUrl = 'https://bilgiesmok.com/tech/api/v1/';

  GetStorage box = GetStorage();

  createUser(em, pa, fn, ln, ph) async {
    final response = await post('${setBaseUrl}auth/create-user',
      jsonEncode(<String, String>{
        'email': em,
        'password': pa,
        'firstname': fn,
        'lastname': ln,
        'phone': ph,
      }),
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        box.write('user', js['user']);
        box.write('token', js['token']);
        MainClass.sus(js['message']);
        Get.to(() => HomeMain());
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  updateUser(fn, ln, ph) async {
    final response = await post('${setBaseUrl}auth/update-user',
      jsonEncode(<String, String>{
        'firstname': fn,
        'lastname': ln,
        'phone': ph,
      }),
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        MainClass.sus(js['message']);
        box.write('user', js['user']);
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  updatePassword(currentPass, newPass) async {
    final response = await post('${setBaseUrl}auth/update-password',
      jsonEncode(<String, String>{
        'current_password': currentPass,
        'new_password': newPass,
      }),
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        MainClass.sus(js['message']);
        box.write('user', js['user']);
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  loginUser(em, pa) async {
    final response = await post('${setBaseUrl}auth/login',
      jsonEncode(<String, String>{
        'email': em,
        'password': pa
      }),
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        box.write('token', js['token']);
        box.write('user', js['user']);
        if(js['ride-in-progress']['ride_id'] != null && js['ride-in-progress']['ride_id'] != ''){
          box.write('in-progress', js['ride-in-progress']);
        } else{
          box.write('in-progress', '');
        }
        Get.to(() => HomeMain());
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  createRide(driverId, pickUp, dropOff) async {
    final response = await post('${setBaseUrl}ride/create-ride',
      jsonEncode(<String, String>{
        'driver_id': driverId,
        'pick_up': pickUp,
        'drop_off': dropOff,
      }),
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        if(js['ride-in-progress'] != null){
          box.write('in-progress', js['ride-in-progress']);
        }
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  updateRide() async {
    var js = box.read('in-progress');
    String rideId = '';

    if(js != ''){
      rideId = js['ride_id'];
    }

    final response = await post('${setBaseUrl}ride/update-ride',
      jsonEncode(<String, String>{
        'ride_id':  rideId,
      }),
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {
      var res = response.body;
      if(res['status'] == 'ok'){
        box.write('in-progress', '');
        return response.body;
      } else {
        MainClass.err(res['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return response.body;
    }
  }

  allRides() async {
    final response = await get('${setBaseUrl}ride/rides',
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return '';
    }
  }

  getRides() async {
    final response = await get('${setBaseUrl}ride/get-ride',
      contentType: "application/json",
      headers: {
        'Authorization': MainClass.getToken(),
      },
    );

    if (response.statusCode == 200) {

      var js = response.body;

      if(js['status'] == 'ok'){
        return response.body;
      } else {
        MainClass.err(js['message']);
        return response.body;
      }

    } else {
      MainClass.err('Unknown Error');
      return '';
    }
  }


}