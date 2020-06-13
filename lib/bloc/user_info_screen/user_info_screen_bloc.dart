import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/user_info_screen/user_info_screen_event.dart';
import 'package:zoomclone/bloc/user_info_screen/user_info_screen_state.dart';

class UserInfoScreenBloc
    extends Bloc<UserInfoScreenEvent, UserInfoScreenState> {
  Api _api = Api();
  @override
  UserInfoScreenState get initialState => UserInfoScreenLoading();

  @override
  Stream<UserInfoScreenState> mapEventToState(
    UserInfoScreenEvent event,
  ) async* {
    if (event is LoadUserInfoScreen) {
      yield* _mapLoadUserInfoScreenToState(_api, event.body);
    }
  }

  Stream<UserInfoScreenState> _mapLoadUserInfoScreenToState(
      api, Map body) async* {
    try {
      yield UserInfoScreenLoaded();
    } catch (error) {
      yield UserInfoScreenNotLoaded();
    }
  }
}
