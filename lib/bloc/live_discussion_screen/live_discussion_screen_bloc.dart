import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/live_discussion_screen/live_discussion_screen_event.dart';
import 'package:zoomclone/bloc/live_discussion_screen/live_discussion_screen_state.dart';
import 'package:zoomclone/utils/util.dart';

class LiveDiscussionScreenBloc
    extends Bloc<LiveDiscussionScreenEvent, LiveDiscussionScreenState> {
  Api _api = Api();
  @override
  LiveDiscussionScreenState get initialState => LiveDiscussionScreenLoading();

  @override
  Stream<LiveDiscussionScreenState> mapEventToState(
    LiveDiscussionScreenEvent event,
  ) async* {
    if (event is LoadLiveDiscussionScreen) {
      yield* _mapLoadLiveDiscussionScreenToState(
        _api,
      );
    } else if (event is LoadScheduleDiscussionScreen) {
      yield* _mapLoadScheduleDiscussionScreenToState(
          _api, event.liveDiscussionList);
    }
  }

  Stream<LiveDiscussionScreenState> _mapLoadLiveDiscussionScreenToState(
    Api api,
  ) async* {
    try {
      yield LiveDiscussionScreenLoading();
      final userId = await Util.getCurrentUserId();
      List response = await api.getLiveSessionListOfUser(userId: userId);
      yield LiveDiscussionScreenLoaded(
        liveSessionList: response,
      );
    } catch (error) {
      yield LiveDiscussionScreenNotLoaded();
    }
  }

  Stream<LiveDiscussionScreenState> _mapLoadScheduleDiscussionScreenToState(
    Api api,
    List liveDiscussionList,
  ) async* {
    try {
      yield LiveDiscussionScreenLoading();
      final userId = await Util.getCurrentUserId();
      List response = await api.getScheduleSessionListOfUser(userId: userId);
      yield ScheduleDiscussionScreenLoaded(
          scheduleSessionList: response, liveSessionList: liveDiscussionList);
    } catch (error) {
      yield ScheduleDiscussionScreenNotLoaded();
    }
  }
}
