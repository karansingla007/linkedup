import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/api/auth_api.dart';
import 'package:zoomclone/bloc/login_signup/login_signup_event.dart';
import 'package:zoomclone/bloc/login_signup/login_signup_state.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class LoginSignupBloc extends Bloc<LoginSignupEvent, LoginSignupState> {
  @override
  LoginSignupState get initialState => LoginSignupLoading();
  Api mainRepo = Api();
  @override
  Stream<LoginSignupState> mapEventToState(
    LoginSignupEvent event,
  ) async* {
    if (event is LoadLoginSignup) {
      yield* _mapLoadLoginSignupToState(event.type, mainRepo);
    } else if (event is LoadLoginSignUpWithMobile) {
      yield* _mapLoadLoginSignupMobileToState(event.contactNumber, mainRepo);
    } else if (event is LoadLoadingState) {
      yield LoginSignupLoading();
    }
  }

  Stream<LoginSignupState> _mapLoadLoginSignupMobileToState(
      contactNumber, Api mainRepo) async* {
    try {
      yield LoginSignupInit();
      Map data = Map();
      data['userName'] = 'user';
      data['mobileNumber'] = contactNumber;
      data['profilePicUrl'] =
          'https://api.adorable.io/avatars/48/abott@adorable.png';
      Map result = await mainRepo.loginSignUpApi(userInfo: data);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          SharedPreferenceConstant.CURRENT_USER_NAME, result['userName']);
      await prefs.setString(SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC,
          result['profilePicUrl']);
      await prefs.setString(
          SharedPreferenceConstant.CURRENT_USER_EMAIL, result['email']);
      await prefs.setString(
          SharedPreferenceConstant.CURRENT_USER_ID, result['userId']);

      if (!result['isNew']) {
        await prefs.setBool(SharedPreferenceConstant.IS_LOAD_WELCOME, true);
      }
      await prefs.setString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME,
          result['firstName']);
      await prefs.setString(
          SharedPreferenceConstant.CURRENT_USER_LAST_NAME, result['lastName']);
      yield LoginSignupLoaded(userDetail: result);
    } catch (error) {
      yield LoginSignupNotLoaded();
    }
  }

  Stream<LoginSignupState> _mapLoadLoginSignupToState(
      type, Api mainRepo) async* {
    try {
      Map userDetail = Map();
      if (type == Constants.GOOGLE) {
        userDetail = await AuthApiClient().signInWithGoogle();
      } else {
        userDetail = await AuthApiClient().getDataFromFacebook();
      }
      if (userDetail != null) {
        Map result = await mainRepo.loginSignUpApi(userInfo: userDetail);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            SharedPreferenceConstant.CURRENT_USER_NAME, result['userName']);
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC,
            result['profilePicUrl']);
        await prefs.setString(
            SharedPreferenceConstant.CURRENT_USER_EMAIL, result['email']);
        await prefs.setString(
            SharedPreferenceConstant.CURRENT_USER_ID, result['userId']);
        if (!result['isNew']) {
          await prefs.setBool(SharedPreferenceConstant.IS_LOAD_WELCOME, true);
        }
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME,
            result['firstName']);
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_LAST_NAME,
            result['lastName']);
        yield LoginSignupLoaded(userDetail: result);
      } else {
        yield LoginSignupNotLoaded();
      }
    } catch (error) {
      yield LoginSignupNotLoaded();
    }
  }
}
