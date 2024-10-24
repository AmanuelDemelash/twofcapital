import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/modules/todo/controllers/todo_controller.dart';
import 'package:twofcapital/app/modules/todo/views/todo_view.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        centerTitle: true,
      ),
      drawer: AppDrawer(controller: Get.find<TodoController>()),
      body:SafeArea(child:LayoutBuilder(builder: (context, constraints) {
        return Text("chat");
      },))
    );
  }
}
