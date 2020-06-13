import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zoomclone/api/api_client.dart';

class AuthApiClient {
  Future<Map> signInWithGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: <String>[
          'email',
        ],
      );
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      Map data = Map();
      String abc = googleUser.displayName;
      data['userName'] = abc.split(' ')[0];
      data['email'] = googleUser.email;
      data['profilePicUrl'] = googleUser.photoUrl;
      return data;
    } catch (_) {
      print(_);
      return null;
    }
  }

  Future<Map> getDataFromFacebook() async {
    try {
      FacebookLogin _facebookLogin = FacebookLogin();
      final FacebookLoginResult result =
          await _facebookLogin.logIn(['email', 'public_profile']);
      final token = result.accessToken.token;
      final graphResponse = await ApiClient().getForFacebook(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final profile = json.decode(graphResponse);
      print(profile.toString());

      Map data = Map();
      data['userName'] = profile['name'];
      data['email'] = profile['email'];
      data['firstName'] = profile['first_name'];
      data['lastName'] = profile['last_name'];
      return data;
    } catch (_) {
      print(_);
    }
  }
}
