import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/routes/app_pages.dart';

class AppAuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLogin=false.obs;

  @override
  void onInit() {
    super.onInit();
    _auth.authStateChanges()
        .listen((User? user) {
      if (user == null) {
        isLogin.value=false;
      } else {
        isLogin.value=true;
      }
    });
  }
  Future<void> logout()async{
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);


  }
}
