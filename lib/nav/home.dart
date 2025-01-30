import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realdrive/classes/api_connect.dart';
import 'package:realdrive/classes/app_color.dart';
import 'package:realdrive/classes/main_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _State();
}

class _State extends State<Home> {
  final Completer<GoogleMapController> mapController = Completer<GoogleMapController>();

  static const CameraPosition lagosLoc = CameraPosition(
    target: LatLng(6.5244, 3.3792),
    zoom: 12,
  );

  RxDouble myLong = 6.5244.obs;
  RxDouble myLat = 3.3792.obs;
  RxDouble myLong0 = 6.5244.obs;
  RxDouble myLat0 = 3.3792.obs;

  String driverId = '', driverName = '', carType = '', carReg = '', carColor = '';
  double driverRating = 0;

  RxString pickUp = ''.obs, dropOff = ''.obs, btnTitle = 'Confirm Pick Up'.obs;
  RxBool inProgress = false.obs, confirmPickUp = false.obs, confirmDropOff = false.obs;

  RxInt c = 15.obs;
  late Timer timer;

  RxList<dynamic> setMarker = [].obs;

  @override
  void initState() {
    pickUp.value = 'Getting Location Please wait...';
    chkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: lagosLoc,
                onMapCreated: (GoogleMapController controller) {
                  mapController.complete(controller);
                },
                onTap: (pos) async {
                  setMarker.value = [];
                  setMarker.add(
                    Marker(
                      markerId: MarkerId('select_location'),
                      position: LatLng(pos.latitude, pos.longitude),
                      icon: BitmapDescriptor.defaultMarkerWithHue(!confirmPickUp.value ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueRose),
                    )
                  );

                  if(!confirmPickUp.value){
                    pickUp.value = 'getting address, please wait...';
                    pickUp.value = await MainClass.getAddress(pos.latitude, pos.longitude);
                  } else {
                    dropOff.value = 'getting address, please wait...';
                    dropOff.value = await MainClass.getAddress(pos.latitude, pos.longitude);
                  }


                },
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer(),),
                },
                markers: Set.from(setMarker),
              ),
              if (inProgress.value)
                Padding(
                  padding: MainClass.padA(16),
                  child: Container(
                    padding: MainClass.padA(8),
                    decoration: MainClass.conDecor(6, AppColor.colorApp, 1, AppColor.colorApp),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainClass.txtW6('Pick Up : ', 14),
                            Expanded(
                              child: MainClass.txtW5(pickUp.value, 14),
                            )
                          ],
                        ),
                        MainClass.bH(4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MainClass.txtW6('Drop 0ff : ', 14),
                            Expanded(
                              child: MainClass.txtW5(dropOff.value, 14),
                            )
                          ],
                        ),
                        MainClass.bH(8),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: MainClass.padA(6),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                                  ),
                                  MainClass.bW(4),
                                  MainClass.txtW5('In-Progress', 12),
                                ],
                              ),
                            ),
                            MainClass.bW(8),
                            InkWell(
                              onTap: () async {
                                rideProgress('Completing Ride');
                                var js = await ApiConnect().updateRide();
                                if (js['message'] == 'success') {
                                  inProgress.value = false;
                                  resetSelections();
                                }
                                Get.back();
                              },
                              child: Container(
                                decoration: MainClass.conDecor(4, Colors.white, 1, Colors.white),
                                padding: MainClass.padS(4, 6),
                                child: MainClass.txtN5('Complete Ride', 14),
                              ),
                            ),
                          ],
                        ),
                        MainClass.bH(4),
                      ],
                    ),
                  ),
                ),
              if (!inProgress.value)
                Padding(
                  padding: MainClass.padA(16),
                  child: Container(
                    padding: MainClass.padA(8),
                    decoration: MainClass.conDecor(6, AppColor.colorApp, 1, AppColor.colorApp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MainClass.txtW4I('Tap anywhere on the map to set ${!confirmPickUp.value ? 'pick up' : 'drop off'} location ', 10),
                        MainClass.bH(4),
                        MainClass.txtW6('Pick Up : ', 14),
                        Container(
                          width: double.infinity,
                          padding: MainClass.padS(8, 2),
                          decoration: MainClass.conDecor(4, Colors.white, 1, Colors.white),
                          child: MainClass.txtN5(pickUp.value, 14),
                        ),
                        MainClass.bH(12),
                        if(confirmPickUp.value)
                        MainClass.txtW6('Drop Off: ', 14),
                        if(confirmPickUp.value)
                        Container(
                          width: double.infinity,
                          padding: MainClass.padS(8, 2),
                          decoration: MainClass.conDecor(4, Colors.white, 1, Colors.white),
                          child: MainClass.txtN5(dropOff.value, 14),
                        ),
                      ],
                    ),
                  ),
                ),
              if(pickUp.value != 'Getting Location Please wait...' && pickUp.value != '' && !inProgress.value)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: MainClass.padA(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: MainClass.btnSty(),
                          onPressed: () {
                            if(pickUp.value != 'getting address please wait..' && pickUp.value != '' && btnTitle.value == 'Confirm Pick Up'){
                              confirmPickUp.value = true;
                              btnTitle.value = 'Confirm DropOff';
                            }

                            if(dropOff.value != 'getting address please wait..' && dropOff.value != '' && btnTitle.value == 'Confirm DropOff'){
                              confirmDropOff.value = true;
                              btnTitle.value = 'Confirm Ride';
                            }

                            if(confirmPickUp.value && confirmDropOff.value){
                              confirmRide();
                            }

                          },
                          child: MainClass.txtW5(btnTitle.value, 14))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  confirmRide() {
    Get.bottomSheet(BottomSheet(
        onClosing: onClosingModal,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MainClass.txtN5('Pick Up\n$pickUp', 14),
                  MainClass.bH(12),
                  MainClass.txtN5('Drop Off\n$dropOff', 14),
                  MainClass.bH(12),
                  MainClass.txtN5('Price\n10,000', 14),
                  MainClass.bH(24),
                  ElevatedButton(
                      style: MainClass.btnSty(),
                      onPressed: () {
                        Get.back();
                        rideProgress('Searching');
                      },
                      child: MainClass.txtW4('Get Ride', 14)),
                  MainClass.bH(16),
                  ElevatedButton(
                      style: MainClass.btnSty(),
                      onPressed: () {
                        Get.back();
                        resetSelections();
                      },
                      child: MainClass.txtW4('Cancel', 14))
                ],
              ),
            );
          });
        }));
  }

  emptyDriver() {
    Get.bottomSheet(BottomSheet(
        onClosing: onClosingModal,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Wrap(
                runSpacing: 16,
                children: [
                  Center(
                    child: MainClass.txtN5('No Driver Found', 16),
                  ),
                  MainClass.bH(24),
                  ElevatedButton(
                      style: MainClass.btnSty(),
                      onPressed: () {
                        Get.back();
                        rideProgress('Searching');
                        getDriver();
                      },
                      child: MainClass.txtW4('Retry', 14)),
                  MainClass.bH(16),
                  ElevatedButton(
                      style: MainClass.btnSty(),
                      onPressed: () {
                        Get.back();
                        resetSelections();
                      },
                      child: MainClass.txtW4('Cancel', 14))
                ],
              ),
            );
          });
        }));
  }

  foundDriver() {
    showNotification();
    Get.bottomSheet(BottomSheet(
        onClosing: onClosingModal,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainClass.txtN6('🚕 Driver Found', 16),
                  MainClass.bH(24),
                  MainClass.txtN5('Driver Name : $driverName', 14),
                  MainClass.bH(12),
                  MainClass.txtN5('Car Type: $carType', 14),
                  MainClass.bH(12),
                  MainClass.txtN5('Car Color: $carColor', 14),
                  MainClass.bH(12),
                  MainClass.txtN5('Car Registration No.: $carReg', 14),
                  MainClass.bH(12),
                  Row(
                    children: [
                      MainClass.txtN5('Driver Rating: ', 14),
                      MainClass.getRatings(3),
                    ],
                  ),
                  MainClass.bH(24),
                  ElevatedButton(
                      style: MainClass.btnSty(),
                      onPressed: () async {
                        Get.back();
                        rideProgress('Confirming Ride');
                        var js = await ApiConnect().createRide(driverId, pickUp.value, dropOff.value);
                        if (js['message'] == 'success') {
                          inProgress.value = true;
                        }
                        Get.back();
                      },
                      child: MainClass.txtW4('Confirm Ride', 14))
                ],
              ),
            );
          });
        }));
  }

  rideProgress(type) async {
    if (type == 'Searching') {
      c.value = 15;
      startCount();
    }
    Get.bottomSheet(BottomSheet(
        onClosing: onClosingModal,
        builder: (ctx) {
          return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 1,
                    color: AppColor.colorApp,
                  ),
                  MainClass.bH(24),
                  MainClass.txtN4('$type, Please Wait..', 14)
                ],
              ),
            );
          });
        }));
  }

  chkPermission() async {
    var per = await Permission.location.status;
    if (per.isGranted) {
      chkProgress();
    } else if (per.isDenied) {
      await Permission.location.request();
    } else {
      await Permission.location.request();
    }
  }

  Future<void> goToCurrentPosition() async {
    CameraPosition myCurrentPosition = CameraPosition(bearing: 0, target: LatLng(myLat.value, myLong.value), tilt: 0, zoom: 20);

    setMarker.add(
        Marker(
          markerId: MarkerId('select_location'),
          position: LatLng(myLat.value, myLong.value),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ));

    final GoogleMapController controller = await mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(myCurrentPosition));

    pickUp.value = await MainClass.getAddress(myLat.value, myLong.value);

  }

  Future<void> showNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('drawable/ic_launcher');
    final darwinInitializationSettings = DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_1',
      'channel_tech',
      importance: Importance.max,
      priority: Priority.high,
      channelDescription: 'channel_tech_notifier',
    );

    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Driver Found',
      '$driverName \n$carType ($carColor) \n$carReg',
      platformChannelSpecifics,
      payload: carReg,
    );
  }

  getLocation() async{
    Location location = Location();

    bool serviceEnabled = false;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        MainClass.err('Location service is not enabled');
        return;
      }
    } else {
      LocationData locationData;
      locationData = await location.getLocation();

      myLong.value = locationData.longitude ?? 6.5244;
      myLat.value = locationData.latitude ?? 3.3792;

      myLong0.value = locationData.longitude ?? 6.5244;
      myLat0.value = locationData.latitude ?? 3.3792;

      goToCurrentPosition();

    }
  }

  chkProgress() {
    GetStorage box = GetStorage();

    var js = box.read('in-progress');

    if (js != null && js != '') {
      pickUp.value = js['pick_up'];
      dropOff.value = js['drop_off'];
      inProgress.value = true;
    } else {
      inProgress.value = false;
      getLocation();
    }

  }

  startCount() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (c.value > 0) {
          setState(() {
            c.value--;
          });
          if (driverId != '') {
            timer.cancel();
            Get.back();
            foundDriver();
          }
        } else {
          timer.cancel();
          Get.back();
          emptyDriver();
        }
      });
    });
  }

  onClosingModal() {}

  getDriver() async {
    var js = await ApiConnect().getRides();
    if (js != null && js != '') {
      driverId = js['data']['driver_id'];
      driverName = js['data']['driver_name'];
      carType = js['data']['car_type'];
      carReg = js['data']['car_reg'];
      carColor = js['data']['car_color'];
      driverRating = double.parse(js['data']['ratings']);
    }
  }

  resetSelections(){
    confirmPickUp.value = false;
    confirmDropOff.value = false;
    pickUp.value = '';
    dropOff.value = '';
    btnTitle.value = 'Confirm Pick Up';
  }

}
