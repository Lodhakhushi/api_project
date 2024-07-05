import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app_widgets/app_custom_Button.dart';
import '../home/homepage.dart';
import 'mobile_verification.dart';

class VerficationCodePage extends StatefulWidget {
  static const String PREF_USER_ID = "uid";
  final int start;

  VerficationCodePage({required this.start});

  @override
  State<VerficationCodePage> createState() => _VerficationCodePageState();
}

class _VerficationCodePageState extends State<VerficationCodePage> {
  TextEditingController otpController1 = TextEditingController();
  TextEditingController otpController2 = TextEditingController();
  TextEditingController otpController3 = TextEditingController();
  TextEditingController otpController4 = TextEditingController();
  TextEditingController otpController5 = TextEditingController();
  TextEditingController otpController6 = TextEditingController();

  Timer? _timer;
  late int _start;

  @override
  void initState() {
    super.initState();
    _start = widget.start;
    startTimer();
  }

  void startTimer() {
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
    MobileVerificationPage.mobileController.clear();
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
              SizedBox(height: 90.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'OTP Verification',
                  style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10.0),
              Image.asset('assets/images/Verify_sms.png', height: 170.0),
              SizedBox(height: 20.0),
              Text(
                'Enter OTP',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              SizedBox(height: 20.0),
              Text(
                'Enter OTP sent to your +91: ${MobileVerificationPage.mobileController.text}',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  mTextField(isfocus: true, mController: otpController1),
                  mTextField(isfocus: true, mController: otpController2),
                  mTextField(isfocus: true, mController: otpController3),
                  mTextField(isfocus: true, mController: otpController4),
                  mTextField(isfocus: true, mController: otpController5),
                  mTextField(
                    isfocus: true,
                    mController: otpController6,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).unfocus();
                        verifyOtp();
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              AppCustomtBtn(
                mTitle: "Verify",
                mBgcolor: Color.fromRGBO(226, 203, 90, 1),
                TextColor: Colors.black,
                onTap: verifyOtp,
              ),
              SizedBox(height: 30.0),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Send OTP again in",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " 00:$_start",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: " sec",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mTextField({
    bool isfocus = false,
    required TextEditingController mController,
    Function(String)? onChanged,
  }) {
    return Container(
      width: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: TextField(
        controller: mController,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        ),
        autofocus: isfocus,
        maxLength: 1,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
            if (onChanged != null) {
              onChanged(value);
            }
          }
        },
      ),
    );
  }

  void verifyOtp() async {
    String smsCode = otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text +
        otpController5.text +
        otpController6.text;

    if (smsCode.length == 6) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: MobileVerificationPage.mverificationId!,
          smsCode: smsCode,
        );

        UserCredential cred = await FirebaseAuth.instance
            .signInWithCredential(credential);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User logged in'))
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(VerficationCodePage.PREF_USER_ID, cred.user!.uid);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to sign in check OTP again'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid 6-digit OTP'))
      );
    }
  }
}
