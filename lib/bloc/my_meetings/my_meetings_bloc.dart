import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/my_meetings/my_meetings_event.dart';
import 'package:zoomclone/bloc/my_meetings/my_meetings_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class MyMeetingsBloc extends Bloc<MyMeetingsEvent, MyMeetingsState> {
  Api _api = Api();
  @override
  MyMeetingsState get initialState => MyMeetingsLoading();

  @override
  Stream<MyMeetingsState> mapEventToState(
    MyMeetingsEvent event,
  ) async* {
    if (event is LoadMyMeetings) {
      yield* _mapLoadMyMeetingsToState(
        _api,
      );
    }
  }

  Stream<MyMeetingsState> _mapLoadMyMeetingsToState(
    Api api,
  ) async* {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      List response = await api.getAllSessionOfUser(userId: userId);
      yield MyMeetingsLoaded(
        response: response,
      );
    } catch (error) {
      yield MyMeetingsNotLoaded();
    }
  }
}
