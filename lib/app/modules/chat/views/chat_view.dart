import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twofcapital/app/modules/todo/controllers/todo_controller.dart';
import 'package:twofcapital/app/modules/todo/views/todo_view.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';
import '../../auth/views/sign_up_view.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
   ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chat'),
          centerTitle: true,
          actions: [
            PopupMenuButton(itemBuilder: (context) => [
              PopupMenuItem(child:const Text("Contacts"),onTap: () {
                Get.toNamed(Routes.CONTACTS);
              },),
              PopupMenuItem(child:const Text("Create Group"),onTap: () {
                Get.defaultDialog(title: "Create Group",
                    contentPadding:const  EdgeInsets.all(10),
                    content: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'enter group name',
                        label: Text("Group name"),
                        hintStyle: TextStyle(color:Colors.white),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                      
                      ),
                      keyboardType: TextInputType.text,
                      controller:controller.groupNameController,
                      style:const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15,),
                    SizedBox(
                      width: Get.width,
                      child:Obx(()=>ElevatedButton(onPressed: () {
                        if(controller.groupNameController.text.isNotEmpty){
                          controller.createGroup();
                        }
                      },
                          child:controller.isCreateGroup.value?const AuthLoading():const Text("create")),
                    ))

                  ],
                ));
              },),
            ],)
          ],
          bottom: const TabBar(tabs: [
            Tab(icon: Icon(Icons.person),text: "Personal",),
            Tab(icon: Icon(Icons.group),text: "Group",),
          ]),
        ),
        drawer: AppDrawer(controller: Get.find<TodoController>()),
        body:SafeArea(child:
            TabBarView(children: [
              //personal
              LayoutBuilder(builder: (context, constraints) {
              return StreamBuilder(stream: controller.userRef.onValue, builder:(context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child:AuthLoading());
                }
                // Check for errors
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}')); // Show error message
                }
                // Check if data is available
                if (!snapshot.hasData || snapshot.data==null || snapshot.data!.snapshot.value==null) {
                  return const Center(child: Text('No chat found.')); // Show no data message
                }
                List<Map<dynamic, dynamic>> users;
                if (snapshot.data != null && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  users = data.entries
                      .map((entry) => {
                    'id': entry.key,
                    ...entry.value as Map<dynamic, dynamic>,
                  }).toList()??[];
                  users.removeWhere((element) => element['id']==controller.user.uid,);
                }else{
                  users=[];
                }
                if(users.isEmpty){
                  return const Center(child: Text('No chat found.')); // Show no data message
                }
                return  ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                  return ListTile(contentPadding: const EdgeInsets.all(10),
                    onTap: ()async{
                      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                      final chatRoomId =await controller.getChatRoomId(currentUserId,users[index]['id']);
                      Get.toNamed(Routes.CHATDETAIL,arguments:{
                        "user":users[index],
                        "chatRoom":chatRoomId
                      }
                      ,);
                    },
                    leading:Badge(
                      padding:const EdgeInsets.only(right: 20),
                      alignment: AlignmentDirectional.bottomEnd,
                      smallSize:14,
                      backgroundColor: ColorConstant.primaryColor,
                      isLabelVisible: users[index]['online']?true:false,
                      child:CircleAvatar(
                        radius: 30,
                        child: Text(users[index]['name'].toString().substring(0,1)),
                      ),
                    ),
                    title: Text(users[index]['name']),
                    subtitle:!users[index]['online']?Text("last seen ${DateFormat("mm:ss a").format(DateTime(users[index]['lastOnline']))}",style:TextStyle(fontSize:11,color: Colors.white.withOpacity(0.5)),):const Text("online",style: TextStyle(color: ColorConstant.primaryColor,fontSize: 11),)
                  );
                },);

              },);
            },),
              // group
              LayoutBuilder(builder: (context, constraints) {
                return StreamBuilder(stream: controller.groupsRef.onValue, builder:(context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child:AuthLoading());
                  }
                  // Check for errors
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}')); // Show error message
                  }
                  // Check if data is available
                  if (!snapshot.hasData || snapshot.data==null || snapshot.data!.snapshot.value==null) {
                    return  const Center(child:
                        Text('No group found.you can create your group'),
                    ); // Show no data message
                  }
                  List<Map<dynamic, dynamic>> groups;
                  if (snapshot.data != null && snapshot.data!.snapshot.value != null) {
                    Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                    groups = data.entries
                        .map((entry) => {
                      'id': entry.key,
                      ...entry.value as Map<dynamic, dynamic>,
                    }).toList()??[];
                  }else{
                    groups=[];
                  }
                  return  ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Get.toNamed(Routes.GROUPCHATDETAIL,arguments: groups[index]),
                      leading:CircleAvatar(
                          radius: 30,
                        child:  Text(groups[index]['name'].toString().substring(0,2)),
                        ),
                      subtitle: Text(DateFormat("mm:ss a").format(
                      DateTime( groups[index]['createdAt'])
                      ) ,style:  TextStyle(color: Colors.white.withOpacity(0.5)),),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                         const Icon(Icons.group,size: 17,),const SizedBox(width: 8,),
                          Text(groups[index]['name']),
                        ],
                      ),
                    );
                  },);

                },);
              },),

            ]),

        )
      ),
    );
  }
}
