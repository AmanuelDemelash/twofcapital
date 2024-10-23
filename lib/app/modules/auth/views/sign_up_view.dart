import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:twofcapital/app/modules/auth/controllers/auth_controller.dart';
import 'package:twofcapital/app/routes/app_pages.dart';
import 'package:twofcapital/app/utils/colorConstant.dart';

import '../../../utils/validation.dart';

class SignUpView extends GetView<AuthController> {
   SignUpView({super.key});

  final _formKey=GlobalKey<FormState>();
  final TextEditingController _nameController=TextEditingController();
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _phoneController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.08),
                Image.network(
                  "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                  height: 100,
                ),
                SizedBox(height: constraints.maxHeight * 0.08),
                Text(
                  "Sign Up",
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
                          hintText: 'Full name',
                          filled: true,
                          hintStyle: TextStyle(color:Colors.black),
                          fillColor:ColorConstant.textFieldFillColor,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        style:const TextStyle(color: Colors.black),
                        validator: (value) {
                          if(!Validation.validateName(value!)){
                            return "enter valid name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 6.0),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Phone',
                          filled: true,
                          hintStyle: TextStyle(color:Colors.black),
                          fillColor:ColorConstant.textFieldFillColor,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0 * 1.5, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                        style:const TextStyle(color: Colors.black),
                        validator: (value) {
                          if(!Validation.phoneNumberValidation(value!)){
                            return "enter valid phone";
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical:6.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            hintStyle: TextStyle(color:Colors.black),
                            fillColor:ColorConstant.textFieldFillColor,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style:const TextStyle(color: Colors.black),
                          validator: (value) {
                            if(!Validation.validateEmail(value!)){
                              return "enter valid email";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            hintStyle: TextStyle(color:Colors.black),
                            fillColor:ColorConstant.textFieldFillColor,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          obscureText: true,
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          style:const TextStyle(color: Colors.black),
                          validator: (value) {
                            if(!Validation.validatePassword(value!)){
                              return "enter valid password";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child:Obx(() =>ElevatedButton(
                          onPressed: () {
                            _formKey.currentState!.save();
                            if (_formKey.currentState!.validate()) {
                              controller.signUp(_emailController.text, _passwordController.text, _nameController.text, _phoneController.text);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding:const EdgeInsets.all(18),
                            backgroundColor: ColorConstant.primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                            shape: const StadiumBorder(),
                          ),
                          child:controller.isSignUp.value?const AuthLoading() :const Text("Sign Up"),
                        ),)
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.AUTH);
                        },
                        child: Text.rich(
                          const TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign in",
                                style: TextStyle(color: Color(0xFF00BF6D)),
                              ),
                            ],
                          ),
                          style:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
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
        }),
      ),
    );
  }
}

class AuthLoading extends StatelessWidget {
  const AuthLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SpinKitCircle(
      color: Colors.white,
      size:26.0,
    );
  }
}


// only for demo
List<DropdownMenuItem<String>>? countries = [
  "Bangladesh",
  "Switzerland",
  'Canada',
  'Japan',
  'Germany',
  'Australia',
  'Sweden',
].map<DropdownMenuItem<String>>((String value) {
  return DropdownMenuItem<String>(value: value, child: Text(value));
}).toList();

