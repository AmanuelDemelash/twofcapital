import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/modules/chat/views/chat_view.dart';
import 'package:twofcapital/app/modules/todo/views/todo_view.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
   HomeView({super.key});
 final PageController pageController=PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Scaffold(
      bottomNavigationBar:Obx(() => NavigationBar(
            indicatorColor: ColorConstant.primaryColor,
              selectedIndex:controller.index.value,
              onDestinationSelected: (value){
              controller.index.value=value;
              pageController.jumpToPage(value);
              },
            labelBehavior:NavigationDestinationLabelBehavior.alwaysShow,
              destinations:const [
            NavigationDestination(icon:Icon(Icons.next_plan), label:'Todo',),
            NavigationDestination(icon:Icon(Icons.chat), label:'Chat'),
            // NavigationDestination(icon:Icon(Icons.person), label:'Profile'),
          ])
      ,),
      body:PageView(
        controller:pageController,
        physics:const NeverScrollableScrollPhysics(),
        children: [
          TodoView(),
          ChatView(),
          // ProfileView()
        ],
      )
    );
  }
}
