import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realdrive/classes/main_class.dart';
import 'package:realdrive/widgets/edt.dart';
import 'package:realdrive/widgets/edt_pass.dart';

import '../classes/api_connect.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _State();
}

class _State extends State<SignUp> {
  TextEditingController fnController = TextEditingController();
  TextEditingController lnController = TextEditingController();
  TextEditingController emController = TextEditingController();
  TextEditingController phController = TextEditingController();
  TextEditingController paController = TextEditingController();
  TextEditingController ppController = TextEditingController();

  FocusNode fnFocus = FocusNode();
  FocusNode lnFocus = FocusNode();
  FocusNode emFocus = FocusNode();
  FocusNode phFocus = FocusNode();
  FocusNode paFocus = FocusNode();
  FocusNode ppFocus = FocusNode();

  bool isVis = true, isVis2 = true;

  var sending = false.obs;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MainClass.boardChk(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => AbsorbPointer(
          absorbing: sending.value,
          child: Padding(
            padding: MainClass.padA(16),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 8,
                ),
                Image.asset('assets/logo.jpg', width: Get.height / 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MainClass.bH(24),
                        Edt(
                          focusNode: fnFocus,
                          textController: fnController,
                          hint: 'Enter First Name',
                        ),
                        MainClass.bH(16),
                        Edt(
                          focusNode: lnFocus,
                          textController: lnController,
                          hint: 'Enter Last Name',
                        ),
                        MainClass.bH(16),
                        Edt(
                          focusNode: phFocus,
                          textController: phController,
                          textInputType: TextInputType.number,
                          max: 11,
                          hint: 'Enter Phone Number',
                        ),
                        MainClass.bH(16),
                        Edt(
                          focusNode: emFocus,
                          textController: emController,
                          textInputType: TextInputType.emailAddress,
                          hint: 'Enter Email',
                        ),

                        MainClass.bH(16),
                        EdtPass(
                          focusNode: paFocus,
                          textController: paController,
                          hint: 'Enter Password',
                          onPress: () {
                            setState(() {
                              if (isVis) {
                                isVis = false;
                              } else {
                                isVis = true;
                              }
                            });
                          },
                          chk: isVis,
                        ),
                        MainClass.bH(16),
                        EdtPass(
                          focusNode: ppFocus,
                          textController: ppController,
                          hint: 'Confirm Password',
                          onPress: () {
                            setState(() {
                              if (isVis2) {
                                isVis2 = false;
                              } else {
                                isVis2 = true;
                              }
                            });
                          },
                          chk: isVis2,
                        ),
                        MainClass.bH(24),
                        if(!sending.value)
                        ElevatedButton(
                            style: MainClass.btnSty(),
                            onPressed: () => chkPermission(),
                            child: MainClass.txtW5('Sign Up', 14)),
                        if (sending.value) MainClass.loadingBtn(),
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardOpen)
                  InkWell(
                    onTap: () => Get.back(),
                    child: MainClass.txtN4('ALREADY REGISTERED? SIGN IN', 14),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  chkPermission() async {
    var per = await Permission.location.status;
    if (per.isGranted) {
      Location location = Location();
      bool serviceEnabled = false;

      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          MainClass.err('Location service must be enabled');
          return;
        }
      } else {
        validateInputs();
      }
    } else if (per.isDenied) {
      await Permission.location.request();
      MainClass.err('Location permission must be allowed, Go to app setting to enable permission');
      return;
    } else {
      await Permission.location.request();
    }
  }

  validateInputs() async {
    if(fnController.text.isEmpty){
      MainClass.err('First name is Required');
      return;
    }
    if(lnController.text.isEmpty){
      MainClass.err('Last name is Required');
      return;
    }
    if(fnController.text.length < 2){
      MainClass.err('Complete First name is Required');
      return;
    }
    if(lnController.text.length < 2){
      MainClass.err('Complete Last name is Required');
      return;
    }
    if(phController.text.isEmpty){
      MainClass.err('Phone is Required');
      return;
    }
    if(phController.text.length != 11){
      MainClass.err('Phone number is Invalid');
      return;
    }
    if(emController.text.isEmpty){
      MainClass.err('Email is Required');
      return;
    }
    if(!GetUtils.isEmail(emController.text)){
      MainClass.err('Email is invalid');
      return;
    }
    if(paController.text.isEmpty){
      MainClass.err('Password is Required');
      return;
    }
    if(ppController.text.isEmpty){
      MainClass.err('Confirm Password is Required');
      return;
    }
    if(paController.text != ppController.text){
      MainClass.err('Password mix-matched');
      return;
    }

    if(paController.text.length < 6){
      MainClass.err('Password must be greater than 5 characters');
      return;
    }

    if(ppController.text.length < 6){
      MainClass.err('Confirm password must be greater than 5 characters');
      return;
    }

    sending.value = true;

    await ApiConnect().createUser(emController.text.trim(), paController.text.trim(), fnController.text.trim(), lnController.text.trim(), phController.text.trim());

    sending.value = false;

  }

}
