import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/controllers/app_authentication_controller.dart';
import 'package:twofcapital/app/theme/themeData.dart';
import 'package:twofcapital/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'app/routes/app_pages.dart';

const checkNewMessagesTask = "checkNewMessagesTask"; // Task name

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(); // Initialize Firebase in background task
    await checkForNewMessages();    // Call the function to check messages
    return Future.value(true);      // Return true if the task completes
  });
}

Future<void> checkForNewMessages() async {
  final database = FirebaseDatabase.instance.ref("chats");
  // Query for unread messages (modify based on your data structure)
  final snapshot = await database.orderByChild('isRead').equalTo(false).get();

  if (snapshot.exists) {
    // LocalNotificationService.showNotification(
    //   title: "New Message",
    //   body: "You have a new message!",
    // );
  } else {
    print("No new messages found.");
  }
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  ).then((value) => Get.put(AppAuthenticationController()),);
  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Register periodic task (runs every 15 minutes)
  Workmanager().registerPeriodicTask(
    "1", // Unique task name
    checkNewMessagesTask,
    frequency: const Duration(minutes:1),
  );
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
