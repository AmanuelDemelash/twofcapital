import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ChatController extends GetxController {
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
  late DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');
  final DatabaseReference groupsRef = FirebaseDatabase.instance.ref().child('groups');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  TextEditingController groupNameController=TextEditingController();

  RxString imageUrl="".obs;
  RxString audioUrl="".obs;
  RxBool isUploadingImage=false.obs;
  RxBool isRecordingAudio = false.obs;
  RxBool isCreateGroup = false.obs;
  RxBool isMember = false.obs;
  RxString isPlayingAudio ="".obs;

  final ImagePicker _picker = ImagePicker();
  final AudioRecorder audioRecorder=AudioRecorder();
  final AudioPlayer audioPlayer=AudioPlayer();

  late User user;
  @override
  void onInit() async{
    super.onInit();
    final currentUser = FirebaseAuth.instance.currentUser;
    user=currentUser!;
  }

  Future<void> sendMessage(String chatRoomId,{String? message, String? image,String? audio})async{
    final newMessageRef =chatsRef.child(chatRoomId).push();
    newMessageRef.set({
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'text': message??"",
      'image':image??"",
      "audio":audio??"",
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  Future<String> getChatRoomId(String user1, String user2)async{
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
  }
  Future<void> pickImage(String chatRoomId,{bool? isGroup}) async {
    final  XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = basename(file.path);
      try {
        isUploadingImage.value=true;
        var reference =_storage.ref().child("images/$fileName");
        //Upload the file to firebase
        var uploadTask = reference.putFile(file);
        String url = await uploadTask.then((p0) => p0.ref.getDownloadURL());
        imageUrl.value=url;
        isUploadingImage.value=false;
        if(isGroup!){
          await sendGroupMessage(chatRoomId,image: imageUrl.value);
        }else{
          await sendGroupMessage(chatRoomId,image:imageUrl.value);
        }
      } catch (e) {
        isUploadingImage.value=false;
      }
    }
  }
  Future<void> startRecording(String chatRoomId,{bool? isGroup}) async {
    if(isRecordingAudio.value){
     String? filePath= await audioRecorder.stop();
     if(filePath!=null){
       isRecordingAudio.value=false;
       File file=File(filePath);
       String fileName=basename(file.path);
       try{
         isUploadingImage.value=true;
         var reference=_storage.ref().child("audio/$fileName");
         var uploadTask=reference.putFile(file);
         String url= await uploadTask.then((p0) => p0.ref.getDownloadURL(),);
         audioUrl.value=url;
         isUploadingImage.value=false;
         if(isGroup!){
           await sendGroupMessage(chatRoomId,audio: audioUrl.value);
         }else{
           await sendGroupMessage(chatRoomId,audio: audioUrl.value);
         }
         filePath=null;

       }catch(e){
         isUploadingImage.value=false;
       }
     }
    }else{
      if(await audioRecorder.hasPermission()){
        isRecordingAudio.value=true;
        final Directory appDocumentDir= await getApplicationDocumentsDirectory();
        final String filePath= join(appDocumentDir.path,'recording.wav');
        await audioRecorder.start(const RecordConfig(), path: filePath);
      }
    }

  }
  Future<void> playAudio(String audioUrl,String id) async {
    if(audioPlayer.playing){
      audioPlayer.stop();
      isPlayingAudio.value='';
    }else{
      audioPlayer.setUrl(audioUrl);
      audioPlayer.setLoopMode(LoopMode.all);
      audioPlayer.play();
      isPlayingAudio.value=id;
    }
  }

  Future<void> createGroup() async {
    if (groupNameController.text.isNotEmpty) {
      isCreateGroup.value=true;
      final newGroupRef =groupsRef.push();
      await newGroupRef.set({
        'name':groupNameController.text,
        'members': {
          'user_id_1': user.uid,  // Replace with the current user ID
        },
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });
      isCreateGroup.value=false;
      groupNameController.clear();
      Get.back();
    }
  }
  Future<void> sendGroupMessage(String groupId,{String? message, String? image,String? audio})async{
    final newMessageRef =groupsRef.child('$groupId/messages').push();
    newMessageRef.set({
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'senderName':FirebaseAuth.instance.currentUser!.displayName,
      'text': message??"",
      'image':image??"",
      "audio":audio??"",
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  Future<void> checkMembership(String chatRoomId) async {
    final snapshot = await groupsRef.child('$chatRoomId/members/${user.uid}').get();
    if (snapshot.exists) {
      isMember.value = true;
    } else {
      isMember.value = false;
    }
  }
  Future<void> joinGroup(String groupId) async {
    await groupsRef.child('$groupId/members/${user.uid}').set(true);
    checkMembership(groupId);
  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
   audioPlayer.dispose();
    super.onClose();
  }

}
