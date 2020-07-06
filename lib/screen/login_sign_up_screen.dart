import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/image/splash_image_1.dart';
import 'package:zoomclone/atoms/image/splash_image_2.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/login_signup/login_signup.dart';
import 'package:zoomclone/buttons/shape_button_big_fill_icon.dart';
import 'package:zoomclone/icons/icon_facebook_logo.dart';
import 'package:zoomclone/icons/icon_google_logo.dart';
import 'package:zoomclone/molecule/splash_item.dart';
import 'package:zoomclone/screen/home_screen.dart';
import 'package:zoomclone/screen/sigin_with_other_screen.dart';
import 'package:zoomclone/screen/welcome_screen.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/widgets/splash_crausal.dart';

class LoginSignUpScreen extends StatelessWidget {
  final LoginSignupBloc loginSignupBloc = LoginSignupBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: loginSignupBloc,
        listener: (context, state) {
          if (state is LoginSignupLoaded) {
            if (state.userDetail['isNew']) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }
          }
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SplashCarousel(
                  height: MediaQuery.of(context).size.height * 0.7,
                  widgets: <Widget>[
                    SplashItem(
                      title: 'Start a Meeting',
                      text: 'Start or join a video meeting on the go',
                      image: SplashImage1(),
                    ),
                    SplashItem(
                      title: 'Share your Content',
                      text: 'They see what you see',
                      image: SplashImage2(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Container(),),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ShapeButtonBigFillIcon(
                    text: 'Google',
                    icon: IconGoogleLogo(),
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      loginSignupBloc
                          .add(LoadLoginSignup(type: Constants.GOOGLE));
//                      Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => WelcomeScreen()),
//                      );
                    },
                  ),
                  SizedBox(
                    width: 16.0,
                  ),
                  ShapeButtonBigFillIcon(
                    text: 'Facebook',
                    icon: IconFacebookLogo(),
                    textColor: Colors.white,
                    color: Color(0xFF4A65A1),
                    onPressed: () {
                      loginSignupBloc
                          .add(LoadLoginSignup(type: Constants.FACEBOOK));
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SigninWithOtherScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Container(
                  color: Colors.transparent,
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextSmallTitle(
                    'Sign in with Mobile Number',
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
