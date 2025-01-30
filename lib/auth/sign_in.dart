import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:realdrive/auth/sign_up.dart';
import 'package:realdrive/classes/main_class.dart';
import 'package:realdrive/widgets/edt.dart';
import 'package:realdrive/widgets/edt_pass.dart';

import '../classes/api_connect.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _State();
}

class _State extends State<SignIn> {
  TextEditingController emController = TextEditingController();
  TextEditingController paController = TextEditingController();

  FocusNode emFocus = FocusNode();
  FocusNode paFocus = FocusNode();

  bool isVis = true;

  var sending = false.obs;

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MainClass.boardChk(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (b, v) {
        if (!b) {
          MoveToBackground.moveTaskToBack();
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(
          () => AbsorbPointer(
            absorbing: sending.value,
            child: Padding(
              padding: MainClass.padA(16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height / 8,
                          ),
                          Image.asset('assets/logo.jpg', width: Get.height / 8),
                          MainClass.bH(24),
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
                          MainClass.bH(24),
                          if (!sending.value)
                            ElevatedButton(
                                style: MainClass.btnSty(),
                                onPressed: () => chkPermission(),
                                child: MainClass.txtW5('Sign In', 14)),
                          if (sending.value) MainClass.loadingBtn(),
                        ],
                      ),
                    ),
                  ),
                  if(!isKeyboardOpen)
                  InkWell(
                    onTap: () => Get.to(() => SignUp()),
                    child: MainClass.txtN4('NOT REGISTERED? SIGN UP', 14),
                  )
                ],
              ),
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

  validateInputs()  async {
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

    sending.value = true;

    await ApiConnect().loginUser(emController.text.trim(), paController.text.trim());

    sending.value = false;
  }



}
