import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realdrive/auth/sign_in.dart';
import 'package:realdrive/classes/app_color.dart';
import 'package:realdrive/classes/nav_controller.dart';
import 'package:realdrive/widgets/edt.dart';

import '../classes/api_connect.dart';
import '../classes/main_class.dart';
import '../widgets/edt_pass.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _State();
}

class _State extends State<Profile> {
  
  TextEditingController editingController1 = TextEditingController();
  TextEditingController editingController2 = TextEditingController();

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  bool isVis = true, isVis2 = true;

  final NavController controller = Get.put(NavController());

  RxString fn = ''.obs, ln = ''.obs, ph = ''.obs;

  @override
  void initState() {
    fn.value = MainClass.getData('firstname').toString();
    ln.value = MainClass.getData('lastname').toString();
    ph.value = MainClass.getData('phone').toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: MainClass.padA(16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          padding: MainClass.padA(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.colorApp
                          ),
                          child: MainClass.txtW6('${fn.value.toString().substring(0, 1).toUpperCase()}${ln.value.toString().substring(0, 1).toUpperCase()}', 24),
                        ),
                      ),
                      MainClass.bH(16),
                      MainClass.txtN6('Name', 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: MainClass.txtN5('${fn.value} ${ln.value}', 14)),
                          MainClass.bW(8),
                          InkWell(
                            onTap: () => editModal(true),
                            child: MainClass.editIC(),
                          )
                        ],
                      ),
                      MainClass.divide(),
                      MainClass.txtN6('Phone', 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: MainClass.txtN5(ph.value, 14)),
                          MainClass.bW(8),
                          InkWell(
                            onTap: ()=> editModal(false),
                            child: MainClass.editIC(),
                          )
                        ],
                      ),
                      MainClass.divide(),
                      MainClass.txtN6('Password', 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: MainClass.txtN5('********', 14)),
                          MainClass.bW(8),
                          InkWell(
                            onTap: ()=> editPassword(),
                            child: MainClass.editIC(),
                          )
                        ],
                      ),
                      MainClass.divide(),
                      MainClass.txtN6('Email', 16),
                      MainClass.txtN5(MainClass.getData('email'), 14)
                    ],
                  ),
                ),
              ),
              MainClass.bH(24),
              ElevatedButton(
                  style: MainClass.btnSty(),
                  onPressed: () {
                    Get.deleteAll();
                    MainClass.sus('Sign Out successfully');
                    Get.to(() => SignIn());
                  },
                  child: MainClass.txtW5('Sign Out', 14)),
            ],
          ),
        ),
      ),
    );
  }

  editModal(type){
    if(type){
      editingController1.text = MainClass.getData('firstname');
      editingController2.text = MainClass.getData('lastname');
    } else {
      editingController1.text = MainClass.getData('phone');
    }
    Get.bottomSheet(
        BottomSheet(
            onClosing: onClosingModal,
            builder: (ctx) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Edt(
                              focusNode: focusNode1,
                              textController: editingController1,
                              hint: type == true ? 'First Name' : 'Phone',
                              textInputType: type == true ? TextInputType.text : TextInputType.number,
                              max: type == true ? 256 : 11,
                              auto: true,
                          ),
                          if(type)
                          MainClass.bH(16),
                          if(type)
                          Edt(
                            focusNode: focusNode2,
                            textController: editingController2,
                            hint: 'Last Name',
                          ),
                          MainClass.bH(24),
                          ElevatedButton(
                              style: MainClass.btnSty(),
                              onPressed: (){
                                if(type){
                                  if(editingController1.text.isEmpty){
                                    MainClass.err('First name is required');
                                    return;
                                  }
                                  if(editingController2.text.isEmpty){
                                    MainClass.err('Last name is required');
                                    return;
                                  }
                                  if(editingController1.text.length < 2){
                                    MainClass.err('Invalid First name is required');
                                    return;
                                  }
                                  if(editingController2.text.length < 2){
                                    MainClass.err('Invalid Last name is required');
                                    return;
                                  }
                                } else {
                                  if(editingController1.text.isEmpty){
                                    MainClass.err('Phone number is required');
                                    return;
                                  }
                                  if(editingController1.text.length != 11){
                                    MainClass.err('Invalid Phone number is required');
                                    return;
                                  }
                                }
                                Get.back();
                                updateProgress(type == true ? 'Name' : 'Phone');
                                updateUser(type);
                              },
                              child: MainClass.txtW4('Update ${type == true ? 'Name' : 'Phone'}', 14))
                        ],
                      ),
                    );
                  });
            })
    );
  }

  editPassword(){
    editingController1.text = '';
    editingController2.text = '';

    Get.bottomSheet(
        BottomSheet(
            onClosing: onClosingModal,
            builder: (context) {
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EdtPass(
                            focusNode: focusNode1,
                            textController: editingController1,
                            hint: 'Current Password',
                            onPress: (){
                              setState(() {
                                if(isVis){
                                  isVis = false;
                                } else {
                                  isVis = true;
                                }
                              });
                            },
                            auto: true,
                            chk: isVis,
                          ),
                          MainClass.bH(16),
                          EdtPass(
                            focusNode: focusNode2,
                            textController: editingController2,
                            hint: 'New Password',
                            onPress: (){
                              setState(() {
                                if(isVis2){
                                  isVis2 = false;
                                } else {
                                  isVis2 = true;
                                }
                              });
                            },
                            chk: isVis2,
                          ),
                          MainClass.bH(24),
                          ElevatedButton(
                              style: MainClass.btnSty(),
                              onPressed: (){
                                if(editingController1.text.isEmpty){
                                  MainClass.err('Current password is required');
                                  return;
                                }
                                if(editingController2.text.isEmpty){
                                  MainClass.err('New Password is required');
                                  return;
                                }
                                if(editingController1.text.length < 6){
                                  MainClass.err('Invalid Password is required');
                                  return;
                                }
                                if(editingController2.text.length < 6){
                                  MainClass.err('New password must be greater than 5 characters');
                                  return;
                                }
                                if(editingController1.text == editingController2.text){
                                  MainClass.err('Previous and new password can\'t be the same');
                                  return;
                                }
                                Get.back();
                                updateProgress('Password');
                                updatePassword();
                              },
                              child: MainClass.txtW4('Update Password', 14))
                        ],
                      ),
                    );
                  });
            })
    );
  }

  updateProgress(type) async {
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
                  MainClass.txtN4('Updating $type, Please Wait..', 14)
                ],
              ),
            );
          });
        }));
  }

  updateUser(type) async {
    if(type){
      await ApiConnect().updateUser(editingController1.text.trim(), editingController2.text.trim(), ph.value);
      fn.value = editingController1.text.trim();
      ln.value = editingController2.text.trim();
    } else {
      await ApiConnect().updateUser(fn.value, ln.value, editingController1.text.trim());
      ph.value = editingController1.text.trim();
    }
    updateOk();
  }

  updatePassword() async {
    await ApiConnect().updatePassword(editingController1.text.trim(), editingController2.text.trim());
    updateOk();
  }

  updateOk(){
    setState(() {});
    Navigator.pop(context);
  }

  onClosingModal() {}


}
