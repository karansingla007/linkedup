import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/history_discussion_screen/history_discussion_screen_event.dart';
import 'package:zoomclone/bloc/history_discussion_screen/history_discussion_screen_state.dart';
import 'package:zoomclone/utils/util.dart';

class HistoryDiscussionScreenBloc
    extends Bloc<HistoryDiscussionScreenEvent, HistoryDiscussionScreenState> {
  Api _api = Api();
  @override
  HistoryDiscussionScreenState get initialState =>
      HistoryDiscussionScreenLoading();

  @override
  Stream<HistoryDiscussionScreenState> mapEventToState(
    HistoryDiscussionScreenEvent event,
  ) async* {
    if (event is LoadHistoryDiscussionScreen) {
      yield* _mapLoadHistoryDiscussionScreenToState(
        _api,
      );
    }
  }

  Stream<HistoryDiscussionScreenState> _mapLoadHistoryDiscussionScreenToState(
    Api api,
  ) async* {
    try {
      yield HistoryDiscussionScreenLoading();
      final userId = await Util.getCurrentUserId();
      List response = await api.getEndedSessionListOfUser(userId: userId);
      yield HistoryDiscussionScreenLoaded(
        historySessionList: response,
      );
    } catch (error) {
      yield HistoryDiscussionScreenNotLoaded();
    }
  }
}
