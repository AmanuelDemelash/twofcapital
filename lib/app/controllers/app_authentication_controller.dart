import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/routes/app_pages.dart';

class AppAuthenticationController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final DatabaseReference _userRef;

  RxBool isLogin=false.obs;

  @override
  void onInit()async{
    super.onInit();
    _auth.authStateChanges()
        .listen((User? user)async {
      if (user == null) {
        isLogin.value=false;
      } else {
        _userRef = FirebaseDatabase.instance.ref('users/${_auth.currentUser!.uid}');
        isLogin.value=true;
        await online();


      }
    });
  }
  Future<void> logout()async{
   await offline();
    await _auth.signOut();
    Get.offAllNamed(Routes.AUTH);
  }
  Future<void> online()async {
   await _userRef.update({'online': true,
      'lastOnline': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<void> offline()async {
  await  _userRef.update({'online': false,
      'lastOnline': DateTime.now().millisecondsSinceEpoch
    });
  }
}
