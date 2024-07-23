import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kafundisha/colors.dart';
import 'package:kafundisha/views/sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool rememberMe = false;

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
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Processing Data')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Reduced border radius
                      ),
                      minimumSize: const Size(double.infinity, 48), // Button width set to max width
                    ),
                    child: const Text(
                        'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignIn()),
                    );
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
