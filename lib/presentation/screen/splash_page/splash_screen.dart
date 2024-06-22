import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/homepage.dart';
import '../on_board/login_in_page.dart';
import '../on_board/verification_codePage.dart';

class Splash_Page extends StatefulWidget {
  const Splash_Page({super.key});

  @override
  State<Splash_Page> createState() => _Splash_PageState();
}

class _Splash_PageState extends State<Splash_Page> {
  @override
  void initState() {
    super.initState();
    checkLogInStatus();
  }

  void checkLogInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString(LoginPage.PREF_USER_ID);


    SharedPreferences prefss = await SharedPreferences.getInstance();
    String? uuid = prefss.getString(VerficationCodePage.PREF_USER_ID);


    // Simulating a short delay to display the splash screen
    await Future.delayed(Duration(seconds: 2));

    if (uid != null) {
      // User is logged in, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );

      if(uuid!=null){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );

      }
    } else {
      // User is not logged in, navigate to LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(),
            SizedBox(height: 11),
            Text(
              'Classico',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
