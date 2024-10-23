import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:twofcapital/app/modules/auth/views/sign_up_view.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';
import 'package:twofcapital/app/utils/validation.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
   AuthView({super.key});

   final _formKey=GlobalKey<FormState>();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return
              SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                    height: 100,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "Sign In",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            hintStyle: TextStyle(color:Colors.black),
                            fillColor:ColorConstant.textFieldFillColor,
                            prefixIcon: Icon(Icons.email,color: ColorConstant.primaryColor,),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                           style:const TextStyle(color: Colors.black),
                          validator: (value) {
                            if(!Validation.validateEmail(value!)){
                              return "enter valid email";
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: true,
                            controller: _passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              hintStyle: TextStyle(color:Colors.black),
                              fillColor:ColorConstant.textFieldFillColor,
                              prefixIcon: Icon(Icons.key_outlined,color: ColorConstant.primaryColor,),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            style:const TextStyle(color: Colors.black),
                            validator: (value) {
                              if(!Validation.validatePassword(value!)){
                                return "enter password";
                              }
                              return null;
                            },
                          ),
                        ),
                        Obx(() =>ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            if(_formKey.currentState!.validate()){
                              controller.signIn(_emailController.text, _passwordController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding:const EdgeInsets.all(20),
                            backgroundColor:ColorConstant.primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child:controller.isSignIn.value?const AuthLoading(): const Text("Sign in"),
                        ),),
                        const SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.FORGOT);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.SIGNUP);
                          },
                          child: Text.rich(
                            const TextSpan(
                              text: "Don’t have an account? ",
                              children: [
                                TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(color: Color(0xFF00BF6D)),
                                ),
                              ],
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.64),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


