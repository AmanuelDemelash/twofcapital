import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:twofcapital/app/modules/chat/controllers/chat_controller.dart';

import '../../../utils/colorConstant.dart';
import '../../auth/views/sign_up_view.dart';

class GroupChatDetailView extends GetView<ChatController> {
   GroupChatDetailView({super.key});
  final group=Get.arguments;
   final TextEditingController messageController = TextEditingController();
   final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    controller.checkMembership(group['id']);
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: CircleAvatar(
            radius: 20,
            child: Text(group['name'].toString().substring(0, 2)),
          ),
          subtitle: Text("${group['members'].length} Members"),
          title: Text(group['name']),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [];
            },
          )
        ],
      ),
      body:SafeArea(child: LayoutBuilder(builder:(context, constraints) {
        return Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:controller.groupsRef.child('${group['id']}/messages').orderByChild('timestamp').onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child:AuthLoading());
                  }
                  if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  final messages = (snapshot.data!.snapshot.value as Map).entries
                      .map((entry) => {
                    'id': entry.key,
                    ...entry.value as Map<dynamic, dynamic>,
                  }).toList()
                    ..sort((a, b) =>
                        a['timestamp'].compareTo(b['timestamp']));

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final isCurrentUser = msg['senderId'] ==controller.user.uid;
                      return
                        Row(mainAxisAlignment:!isCurrentUser
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isCurrentUser? const SizedBox()
                                : CircleAvatar(
                              child: Text(msg['senderName']
                                  .toString()
                                  .substring(0, 1)),
                            ),
                            ChatBubble(
                              clipper:isCurrentUser
                                  ? ChatBubbleClipper1(
                                  type: BubbleType.sendBubble)
                                  : ChatBubbleClipper1(
                                  type: BubbleType.receiverBubble),
                              alignment:isCurrentUser
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 20),
                              backGroundColor:!isCurrentUser
                                  ? ColorConstant.primaryColor
                                  : ColorConstant.primaryColor
                                  .withOpacity(0.2),
                              elevation: 0,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    if (msg['image'] != '')
                                      CachedNetworkImage(
                                        imageUrl: msg
                                        ['image'],
                                        placeholder: (context, url) =>
                                        const Icon(Icons.image),
                                        errorWidget:
                                            (context, url, error) =>
                                        const Icon(Icons.error),
                                      ),
                                    if (msg['text'] != '')
                                      Text(
                                        msg['text'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    if (msg['audio'] != '')
                                      Obx(() => IconButton(
                                          onPressed: () {
                                            controller.playAudio(
                                                msg['audio'],
                                                msg['id']);
                                          },
                                          icon: controller.isPlayingAudio
                                              .value ==
                                              msg['id']
                                              ? AvatarGlow(
                                            startDelay:
                                            const Duration(
                                                milliseconds:
                                                1000),
                                            glowColor: ColorConstant
                                                .primaryColor,
                                            glowShape:
                                            BoxShape.circle,
                                            curve:
                                            Curves.bounceInOut,
                                            child: const Material(
                                                elevation: 10,
                                                shape:
                                                CircleBorder(),
                                                color: Colors
                                                    .transparent,
                                                child: Icon(
                                                  Icons.stop_circle,
                                                  color: ColorConstant
                                                      .primaryColor,
                                                )),
                                          )
                                              : const Icon(
                                              Icons.play_circle))),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      DateFormat("mm:ss a").format(
                                          DateTime(messages[index]
                                          ['timestamp'])),
                                      style:
                                      const TextStyle(fontSize: 11),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                    },
                  );
                },
              ),
            ),
            Obx(() => SizedBox(
                  child: controller.isUploadingImage.value
                      ? const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AuthLoading(),
                      Text(
                        "sending..",
                        style: TextStyle(fontSize: 11),
                      )
                    ],
                  )
                      : const SizedBox()),
            ),
          Obx(() => Container(
              width: Get.width,
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: CardTheme.of(context).color?.withOpacity(0.4),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: controller.isMember.value?
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                       controller.pickImage(group['id'],isGroup: true);
                      },
                      icon: const Icon(
                        Icons.attach_file,
                        color: ColorConstant.primaryColor,
                      )),
                  Expanded(
                    child: TextFormField(
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'write a message..',
                        suffixIcon: Obx(() => GestureDetector(
                            onTap: () {
                             controller.startRecording(group['id'],isGroup: true);
                            },
                            child: controller.isRecordingAudio.value
                                ? AvatarGlow(
                              startDelay:
                              const Duration(milliseconds: 1000),
                              glowColor: ColorConstant.primaryColor,
                              glowShape: BoxShape.circle,
                              curve: Curves.bounceInOut,
                              child: const Material(
                                  elevation: 10,
                                  shape: CircleBorder(),
                                  color: Colors.transparent,
                                  child: Icon(
                                    Icons.stop_circle,
                                    color: ColorConstant.primaryColor,
                                  )),
                            )
                                : const Icon(
                              Icons.keyboard_voice_rounded,
                              color: ColorConstant.primaryColor,
                            ))),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        if (messageController.text.isNotEmpty) {
                          controller.sendGroupMessage(group['id'], message: messageController.text);
                          messageController.clear();
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: ColorConstant.primaryColor,
                      ))
                ],):Center(child:TextButton(child:const Text("Join Group"),onPressed: () {
                    controller.joinGroup(group['id']);
                },))
              ),
            )
          ],
        );
      },))
    );
  }
}
