import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twofcapital/app/modules/auth/views/sign_up_view.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import '../../../utils/colorConstant.dart';

class TodoController extends GetxController {
   Rx<Color> dialogSelectColor= const Color(0x00000000).obs;
 late Rx<DateTime> reminderTime=DateTime.now().obs;
  RxBool isGridView=true.obs;
  late User user;
  RxBool isAddingTodo=false.obs;
  RxBool isPinned=false.obs;
  RxBool isTodoPinned=false.obs;
  RxBool isUpdatingTodo=false.obs;
  DatabaseReference todoRef = FirebaseDatabase.instance.ref('todos');
  @override
  void onInit() {
    super.onInit();
    final currentUser = FirebaseAuth.instance.currentUser;
    user=currentUser!;
    getTodos();

  }
 Future<void> addTodo(String title,String desc,bool isPinned,DateTime reminder)async{
    isAddingTodo.value=true;
   DatabaseReference todoListRef = FirebaseDatabase.instance.ref("todos");
   DatabaseReference newTodoRef = todoListRef.push();
   await newTodoRef.set({
     "userId":user.uid,
     "title":title,
     "description":desc,
     "isPinned":isPinned,
     "reminder":reminder!=DateTime.now()? DateFormat("yyyy-MM-dd-hh:mm:ss a").format(reminder):null,
     "color":dialogSelectColor.value.value,
     "createdAt":DateFormat("yyyy-MM-dd-hh:mm:ss a").format(DateTime.now()),
     "editedAt":DateFormat("yyyy-MM-dd-hh:mm:ss a").format(DateTime.now()),
   });
   isAddingTodo.value=false;
   dialogSelectColor.value=const Color(0x00000000);
    Get.back();
    Get.rawSnackbar(title: "todo",message: "todo added successfully",margin:const EdgeInsets.all(15),backgroundColor:ColorConstant.primaryColor,borderRadius:10);
 }
 Future<void> getTodos()async{
   todoRef.onValue.listen((DatabaseEvent event) {
     final data = event.snapshot.value;
   });
 }

 Future<void> updateTodo(Map<dynamic,dynamic> todo,DateTime updatedReminder)async{
   isUpdatingTodo.value=true;
   DatabaseReference ref = FirebaseDatabase.instance.ref("todos/${todo['id']}");
   await ref.update({
     "title":todo['title'],
     "description":todo['description'],
     "isPinned":todo['isPinned'],
     "reminder":DateFormat("yyyy-MM-dd-hh:mm:ss a").format(updatedReminder)==todo['reminder']?null: DateFormat("yyyy-MM-dd-hh:mm:ss a").format(updatedReminder),
     "editedAt":DateFormat("yyyy-MM-dd-hh:mm:ss a").format(DateTime.now()),
   });
   isUpdatingTodo.value=false;
   Get.back();
   Get.rawSnackbar(title: "update",message: "todo updated successfully",margin:const EdgeInsets.all(15),backgroundColor:ColorConstant.primaryColor,borderRadius:10);

 }
 Future<void> deleteTodo(Map<dynamic,dynamic> todo)async{
   DatabaseReference ref = FirebaseDatabase.instance.ref("todos/${todo['id']}");
   Get.dialog(const AlertDialog(title: AuthLoading(),));
   await ref.remove();
    Get.back();
    Get.offAllNamed(Routes.HOME);
 }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

}
