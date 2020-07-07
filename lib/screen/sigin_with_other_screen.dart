import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zoomclone/atoms/hero_text.dart';
import 'package:zoomclone/atoms/text_body_1.dart';
import 'package:zoomclone/atoms/text_body_2.dart';
import 'package:zoomclone/atoms/text_input.dart';
import 'package:zoomclone/buttons/rounded_shape_button.dart';
import 'package:zoomclone/molecule/drop_down_country_code.dart';
import 'package:zoomclone/screen/verification_screen.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/strings.dart';

class SigninWithOtherScreen extends StatelessWidget {
  final TextEditingController phoneEmailController = TextEditingController();
  String selectedCountryCode = "+91";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: TextHero(
                      'Enter Phone Number',
                      color: Colors.black,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  children: <Widget>[
                    DropDownCountryCode(
                      onChanged: (value) {
                        return selectedCountryCode = value;
                      },
                    ),
                    Expanded(
                      child: TextInput(
                        keyboardType: TextInputType.phone,
                        controller: phoneEmailController,
                        maxLines: 1,
                        hintText: Strings.PHONE_NUMBER,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: RoundedShapeButton(
                text: Strings.SEND_OTP,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VerficationScreen(
                              type: SignInType.MOBILE,
                              text: selectedCountryCode +
                                  phoneEmailController.text,
                            )),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
