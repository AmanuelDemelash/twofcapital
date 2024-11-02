import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/controllers/app_authentication_controller.dart';
import 'package:twofcapital/app/theme/themeData.dart';
import 'package:twofcapital/firebase_options.dart';
import 'package:workmanager/workmanager.dart';
import 'app/routes/app_pages.dart';
import 'app/service/localNotificationService.dart';

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
  // Listen for new chat messages added to the "chats" reference
  database.onChildAdded.listen((event) {
    if (event.snapshot.exists) {
      final newMessage = event.snapshot.value as Map<dynamic, dynamic>;
      final messageText = newMessage['message'] ?? 'You have a new message!';

      // Show a notification for the new message
      LocalNotificationService.showNotification(
        title: "New Message",
        body: messageText,
      );
      print("New message received: $messageText");
    }
  });
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
    frequency: const Duration(minutes:2),
  );
  // Initialize the local notification service
  LocalNotificationService.initialize();

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
