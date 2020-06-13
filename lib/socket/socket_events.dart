class SocketEvent {
  /// live emit event
  static const String JOIN_SESSION = "join_session";
  static const String AUDIO_CHANGE = "audio_change";
  static const String REMOVE_SPEAKER = "remove_speaker";
  static const String COMMENT_SEND = "comment_send";
  static const String MEETING_END = "meeting_end";
  static const String INVITE_VIEWER_TO_BECOME_SPEAKER =
      "invite_viewer_to_become_speaker";

  ///listen
  static const String SESSION_JOINED = "session_joined";
  static const String AUDIO_CHANGED = "audio_changed";
  static const String REMOVED_SPEAKER = "removed_speaker";
  static const String COMMENT_RECEIVE = "comment_receive";
  static const String MEETING_ENDED = "meeting_ended";
  static const String VIEWER_GOT_INVITATION = "viewer_got_invitation";
}
