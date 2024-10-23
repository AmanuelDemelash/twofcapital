import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:twofcapital/app/controllers/app_authentication_controller.dart';
import 'package:twofcapital/app/theme/themeData.dart';
import 'package:twofcapital/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then((value) => Get.put(AppAuthenticationController()),);
  runApp(
    Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
        title: "Application",
        initialRoute:Get.find<AppAuthenticationController>().isLogin.value?AppPages.INITIAL:AppPages.SIGNIN,
        theme: lightTheme,
        getPages: AppPages.routes,
      ),
    ),
  );
}
