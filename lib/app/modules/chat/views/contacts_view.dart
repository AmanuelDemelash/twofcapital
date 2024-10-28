import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twofcapital/app/modules/chat/controllers/chat_controller.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';
import '../../auth/views/sign_up_view.dart';

class ContactsView extends GetView<ChatController> {
  const ContactsView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        centerTitle: true,
      ),
      body: SafeArea(child:
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
            return const Center(child: Text('No user found.')); // Show no data message
          }
          List<Map<dynamic, dynamic>> chats;
          if (snapshot.data != null && snapshot.data!.snapshot.value != null) {
            Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            chats = data.entries
                .map((entry) => {
              'id': entry.key,
              ...entry.value as Map<dynamic, dynamic>,
            }).toList()??[];
          }else{
            chats=[];
          }
          return  ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: (){
                  Get.defaultDialog(title: "Invitation message",
                    contentPadding: const EdgeInsets.all(15),
                    content:const Text("Do you want to send invitation message ?",),
                    cancel: TextButton(onPressed:() => Get.back(), child:const Text("Cancel")),
                    confirm: TextButton(onPressed:(){
                    }, child:const Text("Send")),
                  );
                },
                leading: Badge(
                  padding:const EdgeInsets.only(right: 20),
                  alignment: AlignmentDirectional.bottomEnd,
                  isLabelVisible:chats[index]['online']?true: false,
                  backgroundColor: ColorConstant.primaryColor,
                  smallSize:14,
                  child: CircleAvatar(
                    radius: 30,
                    child: Text(chats[index]['name'].toString().substring(0,1)),
                  ),
                ),
                subtitle:!chats[index]['online']? Text("last seen ${DateFormat("mm:ss a").format(DateTime(chats[index]['lastOnline']))}",style:TextStyle(fontSize:11,color: Colors.white.withOpacity(0.5)),):
                const Text("online",style: TextStyle(color: ColorConstant.primaryColor),),
                title:Text(chats[index]['name']),

              );
            },);

        },);
      },),
      )
    );
  }
}
