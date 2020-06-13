import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/create_session_screen/create_session_screen_event.dart';
import 'package:zoomclone/bloc/create_session_screen/create_session_screen_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';
import 'package:zoomclone/utils/util.dart';

class CreateSessionScreenBloc
    extends Bloc<CreateSessionScreenEvent, CreateSessionScreenState> {
  Api _api = Api();
  @override
  CreateSessionScreenState get initialState => CreateSessionScreenLoading();

  @override
  Stream<CreateSessionScreenState> mapEventToState(
    CreateSessionScreenEvent event,
  ) async* {
    if (event is LoadCreateSessionScreen) {
      yield* _mapLoadCreateSessionScreenToState(_api, event.sessionInfo);
    } else if (event is LoadSpeakerList) {
      yield* _mapLoadSpeakerListToState(event.userList);
    } else if (event is AddSpeakerInList) {
      yield* _mapAddSpeakerListToState(event.user, state);
    } else if (event is RemoveSpeakerInList) {
      yield* _mapRemoveSpeakerListToState(event.user, state);
    } else if (event is LoadUpdateSessionScreen) {
      yield* _mapLoadUpdateSessionScreenToState(_api, event.sessionInfo);
    }
  }

  Stream<CreateSessionScreenState> _mapLoadUpdateSessionScreenToState(
      Api api, Map sessionInfo) async* {
    try {
      yield CreateSessionScreenInit();
      final prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      sessionInfo['hostUserId'] = userId;
      final response = await api.updateSession(sessionInfo: sessionInfo);
      yield CreateSessionScreenLoaded(
        response: response,
      );
    } catch (error) {
      yield CreateSessionScreenNotLoaded();
    }
  }

  Stream<CreateSessionScreenState> _mapLoadCreateSessionScreenToState(
      Api api, Map sessionInfo) async* {
    try {
      yield CreateSessionScreenInit();
      final prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      sessionInfo['hostUserId'] = userId;
      final response = await api.createSession(sessionInfo: sessionInfo);
      await api.insertNetworkList(
          userList: sessionInfo['speakerUsers'],
          networkUserId: sessionInfo['hostUserId']);
      yield CreateSessionScreenLoaded(
        response: response,
      );
    } catch (error) {
      yield CreateSessionScreenNotLoaded();
    }
  }

  Stream<CreateSessionScreenState> _mapLoadSpeakerListToState(
      List userList) async* {
    try {
      yield SpeakerListLoaded(
        response: userList,
      );
    } catch (error) {
      yield SpeakerListNotLoaded();
    }
  }

  Stream<CreateSessionScreenState> _mapAddSpeakerListToState(
      Map user, currentState) async* {
    try {
      if (currentState is SpeakerListLoaded) {
        List existingList = currentState.response;
        if (!Util.isValidList(existingList)) {
          existingList = [];
        }
        existingList.add(user);
        yield SpeakerListLoaded(
          response: existingList,
        );
      }
    } catch (error) {
      yield SpeakerListNotLoaded();
    }
  }

  Stream<CreateSessionScreenState> _mapRemoveSpeakerListToState(
      Map user, currentState) async* {
    try {
      if (currentState is SpeakerListLoaded) {
        List existingList = currentState.response;
        existingList.remove(user);
        yield SpeakerListLoaded(
          response: existingList,
        );
      }
    } catch (error) {
      yield SpeakerListNotLoaded();
    }
  }
}
