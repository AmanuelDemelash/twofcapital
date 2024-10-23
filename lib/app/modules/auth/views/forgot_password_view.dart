import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:twofcapital/app/modules/auth/controllers/auth_controller.dart';
import 'package:twofcapital/app/modules/auth/views/sign_up_view.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';

import '../../../utils/validation.dart';

class ForgotPasswordView extends GetView<AuthController>{
   ForgotPasswordView({super.key});
  final _formKey=GlobalKey<FormState>();
  final TextEditingController _emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
       body:  SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Image.network(
                    "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                    height: 100,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.1,
                    width: double.infinity,
                  ),
                  Text(
                    'Forgot Password',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                        "enter your email address to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.5,
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.64),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              fillColor:ColorConstant.textFieldFillColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            validator: (value) {
                              if(!Validation.validateEmail(value!)){
                                return "enter valid email";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                     Obx(() =>ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                           controller.resetPassword(_emailController.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF00BF6D),
                          padding:const EdgeInsets.all(17),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: const StadiumBorder(),
                        ),
                        child:controller.resetPass.value?const AuthLoading(): const Text("Next"),
                      ),)
                    ],
                  )
                ],
              ),
            );
          }),
        )
    );
  }
}
