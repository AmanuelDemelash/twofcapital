import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  late User user;
  @override
  void onInit() {
    super.onInit();
    final currentUser = FirebaseAuth.instance.currentUser;
   user=currentUser!;
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
