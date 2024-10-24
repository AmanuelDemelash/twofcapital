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
      bottomNavigationBar:Obx(() =>Container(
        margin: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
          child: NavigationBar(
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
          ]),
        ),
      ),),
      body:PageView(
        controller:pageController,
        physics:const NeverScrollableScrollPhysics(),
        children:const [
             TodoView(),
          ChatView(),
          // ProfileView()
        ],
      )
    );
  }
}
