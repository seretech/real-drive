import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realdrive/classes/app_color.dart';
import 'package:realdrive/classes/rides.dart';
import 'package:realdrive/classes/api_connect.dart';

import '../classes/main_class.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _State();
}

class _State extends State<History> {

  List<Rides> rides = [];

  var isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    getRides();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: MainClass.padA(16),
          child: Obx(
                  () => isLoading.value
                  ? const Center(child:  CircularProgressIndicator())
                  : ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: rides.length,
                itemBuilder: (ctx, i) {
                  final Rides r = rides[i];
                  return Container(
                    margin: MainClass.padS(12, 0),
                    width: double.infinity,
                    decoration: MainClass.conDecor(8, AppColor.colorApp, 0, Colors.blueGrey.withValues(alpha: 0.05)),
                    child: Padding(
                      padding: MainClass.padS(4, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MainClass.txtN6('Ride Info', 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Pick Up : ', 14),
                              Expanded(child: MainClass.txtN5(r.pickUp, 14),)
                            ],
                          ),
                          MainClass.bH(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Drop 0ff : ', 14),
                              Expanded(child: MainClass.txtN5(r.dropOff, 14),)
                            ],
                          ),
                          MainClass.bH(6),
                          Container(
                            color: Colors.blueGrey.withValues(alpha: 0.4),
                            height: 1,
                            width: double.infinity,
                          ),
                          MainClass.bH(6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Driver Name : ', 14),
                              Expanded(child: MainClass.txtN5(r.driverName, 14),)
                            ],
                          ),
                          MainClass.bH(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Car Type : ', 14),
                              Expanded(child: MainClass.txtN5(r.carInfo, 14),)
                            ],
                          ),
                          MainClass.bH(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Car Reg : ', 14),
                              Expanded(child: MainClass.txtN5(r.carReg, 14),)
                            ],
                          ),
                          MainClass.bH(6),
                          Container(
                            color: Colors.blueGrey.withValues(alpha: 0.4),
                            height: 1,
                            width: double.infinity,
                          ),
                          MainClass.bH(6),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Date/Time : ', 14),
                              Expanded(child: MainClass.txtN5('${r.dt} | ${r.tm}', 14),)
                            ],
                          ),
                          MainClass.bH(4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainClass.txtN6('Status : ', 14),
                              Expanded(child: MainClass.txtN5(r.stat, 14),)
                            ],
                          ),
                          MainClass.bH(2),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<List<Rides>> getRides() async{
    var js =  await ApiConnect().allRides();
    if(js != null){
      if(js['status'] == 'ok'){
        final data = js['data'];
        for(int i = 0; i < data.length;i++){
          Rides r = Rides(
              data[i]['ride_id'] ?? '',
              data[i]['pick_up'].toString(),
              data[i]['drop_off'].toString(),
              data[i]['driver_id'].toString(),
              data[i]['driver_name'].toString(),
              data[i]['car_info'],
              data[i]['car_reg'],
              data[i]['date_time'].toString().split(' ')[0],
              data[i]['date_time'].toString().split(' ')[1],
              data[i]['status']);
          rides.add(r);

        }
      }
    }
    isLoading.value = false;
    return rides;
  }

}
