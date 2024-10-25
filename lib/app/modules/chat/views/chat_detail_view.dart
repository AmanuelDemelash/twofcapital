import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twofcapital/app/modules/chat/controllers/chat_controller.dart';
import '../../../utils/colorConstant.dart';
import '../../auth/views/sign_up_view.dart';

class ChatDetailView extends GetView<ChatController> {
   ChatDetailView({super.key});
     final user=Get.arguments;
     final TextEditingController messageController=TextEditingController();
  @override
  Widget build(BuildContext context) {
     Get.put(ChatController());
    return Scaffold(
      appBar: AppBar(
        title:ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Text(user['user']['name'].toString().substring(0,1)),
          ),
          subtitle:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              user['user']['online']?
              const Text("online",style:  TextStyle(color: ColorConstant.primaryColor),):
              Text("last seen ${DateFormat("mm:ss a").format(DateTime(user['user']['lastOnline']))}",style:TextStyle(fontSize:11,color: Colors.white.withOpacity(0.5)),)
            ],
          ),
          title: Text(user['user']['name']),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
           return [];
          },)
        ],
      ),
      body:SafeArea(child: LayoutBuilder(builder:(context, constraints) {
        return Column(
          children: [
            Expanded(child: StreamBuilder(stream:controller.chatsRef.child(user['chatRoom']).orderByChild('timestamp').onValue,
              builder: (context, snapshot) {
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
                List<Map<dynamic, dynamic>> messages;
                if (snapshot.data != null && snapshot.data!.snapshot.value != null) {
                  Map<dynamic, dynamic> data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  messages = data.entries
                      .map((entry) => {
                    'id': entry.key,
                    ...entry.value as Map<dynamic, dynamic>,
                  }).toList()..sort((a, b) => a['timestamp'].compareTo(b['timestamp']));
                }else{
                  messages=[];
                }
                return  ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) =>
                        Row(mainAxisAlignment:messages[index]['senderId']!=controller.user.uid
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            messages[index]['senderId']==controller.user.uid?
                            const SizedBox():CircleAvatar(child: Text(user['user']['name'].toString().substring(0,1)),),
                            ChatBubble(clipper:messages[index]['senderId']==controller.user.uid?ChatBubbleClipper1(type: BubbleType.sendBubble):ChatBubbleClipper1(type: BubbleType.receiverBubble),
                              alignment:messages[index]['senderId']==controller.user.uid?Alignment.topRight:Alignment.topLeft,
                              margin:const EdgeInsets.only(top: 20),
                              backGroundColor:messages[index]['senderId']!=controller.user.uid?ColorConstant.primaryColor:ColorConstant.primaryColor.withOpacity(0.2),
                              elevation: 0,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(messages[index]['text'],
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    const SizedBox(height: 10,),
                                 //   Text(DateFormat("mm:ss a").format(DateTime(messages[index]['timestamp'])),style: const TextStyle(fontSize:11),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ));
              },),),
            Container(
              width: Get.width,
              padding:const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CardTheme.of(context).color?.withOpacity(0.4),
                borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      maxLines:null,
                      decoration: const InputDecoration(
                        hintText: 'write a message..',
                        prefixIcon: Icon(Icons.attach_file,color: ColorConstant.primaryColor,),
                        suffixIcon: Icon(Icons.keyboard_voice_rounded,color: ColorConstant.primaryColor,),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: messageController,
                      style:const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(onPressed: ()async {
                    if(messageController.text.isNotEmpty){
                      controller.sendMessage(user['chatRoom'],messageController.text);
                      messageController.clear();
                    }
                  }, icon:const Icon(Icons.send,color: ColorConstant.primaryColor,))
                ],
              ),
            )

          ],
        );
      },))

    );
  }
}
