import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/controllers/app_authentication_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body:SafeArea(
    child: LayoutBuilder(
    builder: (context, constraints) {
      return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
              children: [
                Container(
                  margin:const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.3))
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      child: Text(controller.user.displayName!.substring(0,1)??""),),
                     title: Text(controller.user.displayName??"",),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.user.email??""),
                        Text(controller.user.phoneNumber??""),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: Get.width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding:const EdgeInsets.all(15)
                    ),
                      onPressed:() {
                    Get.find<AppAuthenticationController>().logout();
                  }, child:const Text("LogOut",style: TextStyle(color: Colors.white),)),
                  )
              ]
          )
      );
    }
    )
    )
    );
  }
}
