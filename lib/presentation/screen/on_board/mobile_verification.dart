import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../app_widgets/app_custom_Button.dart';
import '../../../app_widgets/app_custom_Text_Field.dart';
import 'verification_codePage.dart';

class MobileVerificationPage extends StatefulWidget {
  static TextEditingController mobileController = TextEditingController();
  static String? mverificationId;

  @override
  State<MobileVerificationPage> createState() => _MobileVerificationPageState();
}

class _MobileVerificationPageState extends State<MobileVerificationPage> {
  Timer? _timer;
  int _start = 30;

  void startTimer() {
    _start = 30; // Reset to 30 seconds
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 90.0,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                  child: Image.asset(
                    'assets/icons/mobile_otp.png',
                    height: 150.0,
                  )),
              const SizedBox(
                height: 30.0,
              ),
              const Text(
                'Ease on your head',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0),
              ),
              const Text(
                'We are here to remember!!',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: AppCustomTextField(
                  mPreffixIcon: Icons.phone,
                  keyboardType: TextInputType.number,
                  mController: MobileVerificationPage.mobileController,
                  mText: "Mobile number",
                  mBorderRadius: 20.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              AppCustomtBtn(
                mTitle: "Get Otp",
                mBgcolor: const Color.fromRGBO(226, 203, 90, 1),
                TextColor: Colors.black,
                onTap: () async {
                  startTimer();
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber:
                    '+91${MobileVerificationPage.mobileController.text}',
                    verificationCompleted: (PhoneAuthCredential credential) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Verification completed')));
                    },
                    verificationFailed: (FirebaseAuthException e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Verification failed')));
                    },
                    codeSent: (String verificationId, int? resendToken) {
                      MobileVerificationPage.mverificationId = verificationId;
                      setState(() {});

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return VerficationCodePage(start: _start);
                        },
                      ));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
