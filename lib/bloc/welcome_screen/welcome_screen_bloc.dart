import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/welcome_screen/welcome_screen_event.dart';
import 'package:zoomclone/bloc/welcome_screen/welcome_screen_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class WelcomeScreenBloc extends Bloc<WelcomeScreenEvent, WelcomeScreenState> {
  Api _api = Api();
  @override
  WelcomeScreenState get initialState => WelcomeScreenLoading();

  @override
  Stream<WelcomeScreenState> mapEventToState(
    WelcomeScreenEvent event,
  ) async* {
    if (event is LoadWelcomeScreen) {
      yield* _mapLoadWelcomeScreenToState(
        _api,
      );
    } else if (event is SendUserData) {
      yield* _mapSendUserDataToState(_api, event.userInfo);
    } else if (event is SendUserDataDesignation) {
      yield* _mapSendUserDataDesignationToState(_api, event.userInfo);
    } else if (event is SendUserDataAge) {
      yield* _mapSendUserDataAgeToState(_api, event.userInfo);
    }
  }

  Stream<WelcomeScreenState> _mapSendUserDataAgeToState(
      Api api, Map userInfo) async* {
    try {
      yield UpdateUserInfoWelcomeLoading();
      final prefs = await SharedPreferences.getInstance();
      userInfo['userId'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      final response = await api.sendUserInfoAge(userInfo: userInfo);

      yield UpdateUserInfoWelcomeLoaded(response);
    } catch (error) {
      yield UpdateUserInfoWelcomeNotLoaded();
    }
  }

  Stream<WelcomeScreenState> _mapSendUserDataDesignationToState(
      Api api, Map userInfo) async* {
    try {
      yield UpdateUserInfoWelcomeLoading();
      final prefs = await SharedPreferences.getInstance();
      userInfo['userId'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      final response = await api.sendUserInfoDesignation(userInfo: userInfo);

      yield UpdateUserInfoWelcomeLoaded(response);
    } catch (error) {
      yield UpdateUserInfoWelcomeNotLoaded();
    }
  }

  Stream<WelcomeScreenState> _mapSendUserDataToState(
      Api api, Map userInfo) async* {
    try {
      yield UpdateUserInfoWelcomeLoading();
      final prefs = await SharedPreferences.getInstance();
      userInfo['userId'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);

      final response = await api.sendUserInfoWelcome(userInfo: userInfo);

      if (response['isUserNameAvailable'] != null &&
          response['isUserNameAvailable'] == true) {
        await prefs.setBool(SharedPreferenceConstant.IS_LOAD_WELCOME, true);
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME,
            response['firstName']);
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_LAST_NAME,
            response['lastName']);
        await prefs.setString(SharedPreferenceConstant.CURRENT_USER_LOCATION,
            response['loation']);
      }
      yield UpdateUserInfoWelcomeLoaded(response);
    } catch (error) {
      yield UpdateUserInfoWelcomeNotLoaded();
    }
  }

  Stream<WelcomeScreenState> _mapLoadWelcomeScreenToState(api) async* {
    try {
      Map data = Map();
      final prefs = await SharedPreferences.getInstance();
      data['profilePicUrl'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_PROFILE_PIC);
      data['userName'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_NAME);
      data['firstName'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_FIRST_NAME);
      data['lastName'] =
          prefs.getString(SharedPreferenceConstant.CURRENT_USER_LAST_NAME);

      yield WelcomeScreenLoaded(data);
    } catch (error) {
      yield WelcomeScreenNotLoaded();
    }
  }
}
