import 'package:Todo/presentation/screen/on_board/mobile_verification.dart';
import 'package:Todo/presentation/screen/on_board/sign_up_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app_widgets/app_custom_Button.dart';
import '../../../app_widgets/app_custom_Text_Field.dart';
import '../home/homepage.dart';


class LoginPage extends StatefulWidget {
  static const String PREF_USER_ID = "uid";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool _obscureText = true;

  FirebaseAuth fireAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 201, 186, 1),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 350,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/Login.jpeg'),
                        fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 20,
              ),

              AppCustomTextField(
                  mController: emailController,
                  mText: "Email",
                  mPreffixIcon: Icons.email),

              const SizedBox(
                height: 10,
              ),

              AppCustomTextField(
                mController: passwordController,
                mText: "Password",
                mPreffixIcon: Icons.key,
                mSuffixIcon:
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                onSuffixIconPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                }, // Pass the value of _obscureText here
              ),
              const SizedBox(
                height: 5,
              ),
              // AppCustomTextField(controller: passwordController.text),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Dont Have an account?',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SignUpPage();
                        },
                      ));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          color: Colors.blueGrey.shade900,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              AppCustomtBtn(
                onTap: () async {
                  try {
                    UserCredential cred =
                        await fireAuth.signInWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Logged in')));

                    // print('user logged in: ${cred.user!.uid}');

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(LoginPage.PREF_USER_ID, cred.user!.uid);

                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return HomePage();
                      },
                    ));
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No user found for that email.')));
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong password provided for that user')));
                    }
                  }
                },
                mTitle: "login",
                TextColor: Colors.black,
                mBgcolor: Color.fromRGBO(
                  226,
                  203,
                  90,
                  1,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return MobileVerificationPage();
                      },
                    ));
                  },
                  child: Text(
                    'Login through OTP',
                    style: TextStyle(
                        color: Colors.blueGrey.shade400,
                        fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
