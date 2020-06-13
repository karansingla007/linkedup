import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/atoms/large_title.dart';
import 'package:zoomclone/atoms/text_small_title.dart';
import 'package:zoomclone/bloc/welcome_screen/welcome_screen.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/screen/home_screen.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/time_util.dart';
import 'package:zoomclone/utils/util.dart';

class UserInfoAgeScreen extends StatefulWidget {
  @override
  _UserInfoAgeScreenState createState() => _UserInfoAgeScreenState();
}

class _UserInfoAgeScreenState extends State<UserInfoAgeScreen> {
  int selectedDateTimeEpoch;
  final WelcomeScreenBloc welcomeScreenBloc = WelcomeScreenBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: welcomeScreenBloc,
        listener: (context, state) {
          if (state is UpdateUserInfoWelcomeLoaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: LargeTitle(
                  'Add Your birthday',
                  textAlign: TextAlign.center,
                  shadowEnabled: true,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.center,
                child: TextSmallTitle(
                  'This won\'t be part of your public profile',
                  textAlign: TextAlign.center,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(color: Colors.black12, width: 1)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            await Util.showDOBDatePickerBottomSheet(
                                context, onSelectDate);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 24.0, left: 8, right: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color: Colors.blueAccent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 12.0, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Icon(
                                      Icons.date_range,
                                      color: Colors.white70,
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    TextSmallTitle(
                                      selectedDateTimeEpoch != null
                                          ? TimeUtil.getDate(
                                              selectedDateTimeEpoch)
                                          : Strings.PICK_DATE_AND_TIME,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RoundedShapeButton(
                    text: 'SKIP',
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BlocBuilder(
                    bloc: welcomeScreenBloc,
                    builder: (context, state) {
                      if (state is UpdateUserInfoWelcomeLoading) {
                        return WaveLoader.spinKit(size: 20);
                      } else {
                        return RoundedShapeButton(
                          text: Strings.CONTINUE,
                          onPressed: () {
                            Map body = Map();
                            body['dateOfBirth'] =
                                selectedDateTimeEpoch.toString();
                            welcomeScreenBloc
                                .add(SendUserDataAge(userInfo: body));
                          },
                          color: Colors.blue,
                          textColor: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSelectDate(int date) {
    setState(() {
      selectedDateTimeEpoch = date;
    });
  }
}
