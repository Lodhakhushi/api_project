import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../app_widgets/app_custom_Button.dart';
import '../../../app_widgets/app_custom_Text_Field.dart';
import '../../../model/user_model.dart';
import 'login_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _obscureText = true;

  FirebaseAuth fireAuth = FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(212, 201, 186, 1),
      body: SingleChildScrollView(
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
                mController: nameController,
                mText: "Name",
                mPreffixIcon: Icons.person),
            const SizedBox(
              height: 10,
            ),
            AppCustomTextField(
              mController: emailController,
              mText: "Email",
              mPreffixIcon: Icons.email,
            ),
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
              height: 30,
            ),
            AppCustomtBtn(
              mTitle: "Sign Up",
              mBgcolor: Color.fromRGBO(
                226,
                203,
                90,
                1,
              ),
              TextColor: Colors.black,
              onTap: () async {
                String name = nameController.text.trim();
                String email = emailController.text.trim();
                String password = passwordController.text.trim();

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                  return;
                }
                try {
                  UserCredential cred =
                      await fireAuth.createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);

                  print("${cred.user!.uid}");

                  var newUser = UserModel(
                      name: nameController.text.toString(),
                      email: emailController.text.toString(),
                      password: passwordController.text.toString());

                  await firebaseFirestore
                      .collection('users')
                      .doc(cred.user!.uid)
                      .set(newUser.toDoc());

                  print('New user added');

                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print("error is: $e");
                }

                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ));
              },
            )
          ],
        ),
      ),
    );
  }
}
