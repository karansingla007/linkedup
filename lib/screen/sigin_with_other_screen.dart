import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          Align(
              alignment: Alignment.center,
              child: Padding(
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
              )),
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
