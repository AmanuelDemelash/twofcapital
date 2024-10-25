import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ChatController extends GetxController {
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
  late DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');
  DatabaseReference groupRef = FirebaseDatabase.instance.ref('groups');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  RxString imageUrl="".obs;
  RxString audioUrl="".obs;

  final ImagePicker _picker = ImagePicker();
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

  Future<void> pickImage(String chatRoomId) async {
    final  XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String fileName = basename(file.path);
      try {
        var reference =_storage.ref().child("images/$fileName");
        //Upload the file to firebase
        var uploadTask = reference.putFile(file);
        String url = await uploadTask.then((p0) => p0.ref.getDownloadURL());
        imageUrl.value=url;
        await sendMessage(chatRoomId,image:imageUrl.value);
      } catch (e) {
      }
    }
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
