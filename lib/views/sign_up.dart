import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/utils/services.dart';
import 'package:kafundisha/views/home.dart';
import 'package:kafundisha/views/sign_in.dart';
import 'package:loading_btn/loading_btn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;
  TextEditingController nameField = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  height: 70,
                  width: 260,
                  child: Image.asset(
                    "assets/logo.png"
                  ),
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.darkBackground,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameField,
                          decoration:  InputDecoration(
                            labelText: 'full name',
                            labelStyle: TextStyle(
                                color: AppColors.darkBackground.withAlpha(180)
                            ),
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: emailField,
                          decoration: InputDecoration(
                            labelText: 'email',
                            labelStyle: TextStyle(
                                color: AppColors.darkBackground.withAlpha(180)
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: passwordField,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'password',
                            labelStyle: TextStyle(
                                color: AppColors.darkBackground.withAlpha(180)
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12))
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Checkbox(value: rememberMe, activeColor: AppColors.darkBackground, onChanged: (value){
                      if(rememberMe) {
                        setState(() {
                          rememberMe = false;
                        });
                      } else {
                        setState(() {
                          rememberMe = true;
                        });
                      }
                    }),
                    const Text(
                      "Remember me?",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkBackground
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.maxFinite,
                  height: 50,
                  child: LoadingBtn(
                    height: 48,
                    borderRadius: 12,
                    animate: true,
                    color: Colors.orange,
                    width: 200,
                    loader: Container(
                      padding: const EdgeInsets.all(10),
                      width: 40,
                      height: 40,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    child: const Text(
                        "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                      ),
                    ),
                    onTap: (startLoading, stopLoading, btnState) async {
                      if (_formKey.currentState!.validate()) {
                        startLoading();
                        try {
                          var value = await Services().signUpUser(
                            emailField.text,
                            passwordField.text,
                            nameField.text,
                            context
                          );
                          stopLoading();
                          if (value.uid != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sign up successful'))
                            );
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen(uid: value.uid.toString(),)));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sign up failed ${value.message}'))
                            );
                          }
                        } catch (error) {
                          stopLoading();
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('An error occurred: $error'))
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const SignIn()));
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Already have an account? Sign In.",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.darkBackground.withAlpha(180),
                        color: AppColors.darkBackground.withAlpha(180)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
