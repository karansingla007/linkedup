import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/feedback/feedback_event.dart';
import 'package:zoomclone/bloc/feedback/feedback_state.dart';
import 'package:zoomclone/utils/shared_pref_constant.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  Api _api = Api();
  @override
  FeedbackState get initialState => FeedbackLoading();

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is LoadFeedback) {
      yield* _mapLoadFeedbackToState(_api, event.body);
    }
  }

  Stream<FeedbackState> _mapLoadFeedbackToState(Api api, Map body) async* {
    try {
      final prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(SharedPreferenceConstant.CURRENT_USER_ID);
      body['userId'] = userId;
      Map response = await api.createFeedback(deviceInfo: body);
      yield FeedbackLoaded(
        response: response,
      );
    } catch (error) {
      yield FeedbackNotLoaded();
    }
  }
}
