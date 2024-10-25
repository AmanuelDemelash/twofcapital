import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
  late DatabaseReference chatsRef = FirebaseDatabase.instance.ref('chats');
  DatabaseReference groupRef = FirebaseDatabase.instance.ref('groups');
  late User user;
  @override
  void onInit() async{
    super.onInit();
    final currentUser = FirebaseAuth.instance.currentUser;
    user=currentUser!;
    getGroup();
    getUsers();
  }

  Future<void> sendMessage(String chatRoomId,String message)async{
    final newMessageRef =chatsRef.child(chatRoomId).push();
    newMessageRef.set({
      'senderId':FirebaseAuth.instance.currentUser!.uid,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
  Future<void> getGroup()async{
    groupRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
    });
  }
  Future<void> getUsers()async{
    userRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
    });
  }

 Future<String> getChatRoomId(String user1, String user2)async{
    return user1.hashCode <= user2.hashCode
        ? '${user1}_$user2'
        : '${user2}_$user1';
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
