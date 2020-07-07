import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/bloc/login_signup/login_signup.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/screen/welcome_screen.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';

import 'home_screen.dart';

class VerficationScreen extends StatelessWidget {
  final String text;
  final SignInType type;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController otpEditingController = TextEditingController();
  final LoginSignupBloc loginSignupBloc = LoginSignupBloc();
  String verificationIdReceived;

  VerficationScreen({this.type, this.text}) {
    if (type == SignInType.MOBILE) {
      sendCodeToPhoneNumber();
    }
  }

  sendCodeToPhoneNumber() async {
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: (AuthCredential user) {},
          verificationFailed: (AuthException authException) {
            return null;
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            verificationIdReceived = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            return null;
          });
    } catch (error, stackTrace) {
      print(error);
    }
  }

  void verifyOtp(context) async {
    loginSignupBloc.add(LoadLoadingState());
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationIdReceived,
        smsCode: otpEditingController.text);
    await _firebaseAuth
        .signInWithCredential(authCredential)
        .then((AuthResult authResult) async {
      final FirebaseUser currentUser = await _firebaseAuth.currentUser();
      if (authResult.user.uid == currentUser.uid) {
        loginSignupBloc.add(LoadLoginSignUpWithMobile(contactNumber: text));
      } else {
        Toast.show(
          Strings.OTP_IS_INVALID,
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_LONG,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: loginSignupBloc,
        listener: (context, state) {
          if (state is LoginSignupLoaded) {
            if (state.userDetail['isNew']) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomeScreen()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false);
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0),
                      child: TextHero(
                        'Enter OTP',
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: TextInput(
                        keyboardType: TextInputType.number,
                        hintText: Strings.ENTER_OTP,
                        maxLength: 6,
                        maxLines: 1,
                        controller: otpEditingController,
                      ),
                    ),
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextBody1(
                          Strings.CHECK_YOUR_SMS_TO_FIND_THE_CODE,
                          color: Colors.black,
                          shadowEnabled: false,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            sendCodeToPhoneNumber();
                          },
                          child: TextBody2(
                            Strings.RESEND,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: BlocBuilder(
                        bloc: loginSignupBloc,
                        builder: (context, state) {
                          if (state is LoginSignupInit) {
                            return WaveLoader.spinKit(size: 20);
                          } else {
                            return RoundedShapeButton(
                              text: Strings.CONTINUE,
                              onPressed: () {
                                verifyOtp(context);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
