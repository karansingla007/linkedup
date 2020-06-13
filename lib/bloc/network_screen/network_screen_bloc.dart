import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/network_screen/network_screen_event.dart';
import 'package:zoomclone/bloc/network_screen/network_screen_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class NetworkScreenBloc extends Bloc<NetworkScreenEvent, NetworkScreenState> {
  Api _api = Api();
  @override
  NetworkScreenState get initialState => NetworkScreenLoading();

  @override
  Stream<NetworkScreenState> mapEventToState(
    NetworkScreenEvent event,
  ) async* {
    if (event is LoadNetworkScreen) {
      yield* _mapLoadNetworkScreenToState(
        _api,
      );
    }
  }

  Stream<NetworkScreenState> _mapLoadNetworkScreenToState(
    Api api,
  ) async* {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      final response = await api.getNetworkById(networkUserId: userId);
      yield NetworkScreenLoaded(
        myNetworkList: response,
      );
    } catch (error) {
      yield NetworkScreenNotLoaded();
    }
  }
}
