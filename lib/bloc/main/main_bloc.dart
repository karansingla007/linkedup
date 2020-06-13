import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/bloc/main/main_event.dart';
import 'package:zoomclone/bloc/main/main_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  @override
  MainState get initialState => MainLoading();
  @override
  Stream<MainState> mapEventToState(
    MainEvent event,
  ) async* {
    if (event is LoadMain) {
      yield* _mapLoadMainToState(event.meetingId);
    }
  }

  Stream<MainState> _mapLoadMainToState(meetingId) async* {
    try {
      Map userDetail = Map();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      bool isLoadWelcome =
          prefs.getBool(SharedPreferenceConstant.IS_LOAD_WELCOME);
      userDetail['userId'] = userId;
      userDetail['isLoadWelcome'] = isLoadWelcome;
      yield MainLoaded(userDetail: userDetail, meetingId: meetingId);
    } catch (error) {
      yield MainNotLoaded();
    }
  }
}
