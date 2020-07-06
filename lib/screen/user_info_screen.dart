import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toast/toast.dart';
import 'package:zoomclone/atoms/large_title.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/bloc/welcome_screen/welcome_screen.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/custom/radio_light.dart';
import 'package:zoomclone/custom/wave_loader.dart';
import 'package:zoomclone/screen/user_info_age_screen.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';
import 'package:zoomclone/utils/util.dart';

class UserInfoScreen extends StatelessWidget {
  final TextEditingController designationEditingController =
      TextEditingController();
  final TextEditingController companyEditingController =
      TextEditingController();
  final WelcomeScreenBloc welcomeScreenBloc = WelcomeScreenBloc();
  String userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: welcomeScreenBloc,
        listener: (context, state) {
          if (state is UpdateUserInfoWelcomeLoaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserInfoAgeScreen()),
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
                  'Designation',
                  textAlign: TextAlign.center,
                  shadowEnabled: true,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
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
                        Theme(
                          data: ThemeData.light(),
                          child: RadioLight(
                            labels: <String>[
                              Strings.STUDENT,
                              Strings.PROFESSIONAL,
                            ],
                            width: 150,
                            activeColor: Colors.blue,
                            orientation: RadioGroupedButtonsOrientation.WRAP,
                            onSelected: (String value) {
                              userType = value;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 32),
                          child: TextInput(
                            controller: companyEditingController,
                            hintText: 'College / Company',
                            label: 'College / Company',
                            onChanged: (value) {},
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 20, bottom: 8),
                          child: TextInput(
                            controller: designationEditingController,
                            hintText: 'Studying / Designation',
                            label: 'Studying / Designation',
                            onChanged: (value) {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 32,
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
                        if(Util.isStringNotNull(designationEditingController.text) && Util.isStringNotNull(companyEditingController.text)) {
                          Map body = Map();
                          body['userType'] = userType;
                          body['designation'] = designationEditingController.text;
                          body['company'] = companyEditingController.text;
                          welcomeScreenBloc
                              .add(SendUserDataDesignation(userInfo: body));
                        } else {
                          Toast.show(
                            Strings.PLEASE_ENTER_VALID_DATA,
                            context,
                            gravity: Toast.CENTER,
                            duration: Toast.LENGTH_LONG,
                          );
                        }

                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
