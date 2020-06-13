import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/meeting_detail/meeting_detail_event.dart';
import 'package:zoomclone/bloc/meeting_detail/meeting_detail_state.dart';
import 'package:zoomclone/utils/constants.dart';
import 'package:zoomclone/utils/util.dart';

class MeetingDetailBloc extends Bloc<MeetingDetailEvent, MeetingDetailState> {
  Api _api = Api();
  @override
  MeetingDetailState get initialState => MeetingDetailLoading();

  @override
  Stream<MeetingDetailState> mapEventToState(
    MeetingDetailEvent event,
  ) async* {
    if (event is LoadMeetingDetail) {
      yield* _mapLoadMeetingDetailToState(_api, event.sessionId);
    } else if (event is StartMeeting) {
      yield* _mapStartMeetingDetailToState(_api, event.sessionId, state);
    } else if (event is DeleteMeeting) {
      yield* _mapDeleteMeetingDetailToState(_api, event.sessionId, state);
    }
  }

  Stream<MeetingDetailState> _mapDeleteMeetingDetailToState(
      Api api, String sessionId, currentState) async* {
    try {
      yield MeetingDetailDeleting();
      await api.deleteSession(sessionId: sessionId);
      yield MeetingDetailDeleted();
    } catch (error) {
      yield MeetingDetailNotLoaded();
    }
  }

  Stream<MeetingDetailState> _mapStartMeetingDetailToState(
      Api api, String sessionId, currentState) async* {
    try {
      yield MeetingDetailStarting();
      await api.updateSessionStatus(sessionId: sessionId, status: 'live');
      yield MeetingDetailStarted();
    } catch (error) {
      yield MeetingDetailNotLoaded();
    }
  }

  Stream<MeetingDetailState> _mapLoadMeetingDetailToState(
      Api api, String sessionId) async* {
    try {
      Map response = await api.getSessionInfoById(sessionId: sessionId);
      String currentUserId = await Util.getCurrentUserId();
      if (response['hostUser']['userId'] == currentUserId) {
        response['userRole'] = Constants.HOST;
      } else {
        if (Util.isValidList(response['speakerUsers'])) {
          for (int i = 0; i < response['speakerUsers'].length; i++) {
            if (response['speakerUsers'][i]['userId'] == currentUserId) {
              response['userRole'] = Constants.SPEAKER;
              break;
            }
          }
          if (!Util.isStringNotNull(response['userRole'])) {
            response['userRole'] = Constants.VIEWER;
          }
        } else {
          response['userRole'] = Constants.VIEWER;
        }
      }

      yield MeetingDetailLoaded(sessionInfo: response);
    } catch (error) {
      yield MeetingDetailNotLoaded();
    }
  }
}
