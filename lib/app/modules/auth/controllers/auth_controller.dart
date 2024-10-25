import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
 // final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  RxBool isSignUp=false.obs;
  RxBool isSignIn=false.obs;
  RxBool resetPass=false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> signIn(String email,String password)async{
    try {
      isSignIn.value=true;
      final credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      isSignIn.value=false;
      Get.offAllNamed(Routes.HOME);

    } on FirebaseAuthException catch (e) {
      isSignIn.value=false;
      Get.rawSnackbar(title: "error",message:e.code.toString(),margin:const EdgeInsets.all(15),backgroundColor:Colors.redAccent,borderRadius: 10);

    } catch (e) {
      isSignIn.value=false;
    }

  }

  Future<void> signUp(String email,String password,String name,String phone,)async{
    try {
      isSignUp.value=true;
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password
      );
      // Get the user's ID
      String userId = credential.user!.uid;
      final user=_auth.currentUser;
      await user?.updateDisplayName(name);
      if(userId.isNotEmpty){
        DatabaseReference ref = FirebaseDatabase.instance.ref("users/$userId");
        await ref.set({
          "uid":userId,
          "name":name,
          "email":email,
          "phone":phone,
          "online":true,
          'lastOnline': DateTime.now().millisecondsSinceEpoch
        });
        isSignUp.value=false;
        Get.rawSnackbar(title: "registration",message: "signup successfully",margin:const EdgeInsets.all(15),backgroundColor:ColorConstant.primaryColor,borderRadius:10);
        Get.offAllNamed(Routes.HOME);
      }else{
        isSignUp.value=false;
      }
    } on FirebaseAuthException catch (e) {
      isSignUp.value=false;
      Get.rawSnackbar(title: "error",message:e.code.toString(),margin:const EdgeInsets.all(15),backgroundColor:Colors.redAccent,borderRadius: 10);

    } catch (e) {
      isSignUp.value=false;
    }

  }
 Future<void> resetPassword(String email)async{
    resetPass.value=true;
   await _auth.sendPasswordResetEmail(email:email);
    resetPass.value=false;
    Get.rawSnackbar(title: "reset",message: "check your email to reset your password",margin:const EdgeInsets.all(15),backgroundColor:ColorConstant.primaryColor,borderRadius: 10);



 }

}
