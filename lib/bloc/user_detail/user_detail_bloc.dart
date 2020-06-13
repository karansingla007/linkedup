import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zoomclone/api/api.dart';
import 'package:zoomclone/bloc/user_detail/user_detail_event.dart';
import 'package:zoomclone/bloc/user_detail/user_detail_state.dart';
import 'package:zoomclone/utils/util.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  Api _api = Api();
  @override
  UserDetailState get initialState => UserDetailLoading();

  @override
  Stream<UserDetailState> mapEventToState(
    UserDetailEvent event,
  ) async* {
    if (event is LoadIsCurrentUser) {
      yield* _mapLoadIsCurrentUserToState(_api, event.userId);
    } else if (event is LoadCurrentUserInfo) {
      yield* _mapLoadCurrentUserInfoToState();
    } else if (event is LoadUserInfo) {
      yield* _mapLoadUserInfoToState(_api, event.userId);
    } else if (event is UpdateUserDetail) {
      yield* _mapUpdateUserInfoToState(_api, event.userInfo);
    } else if (event is UploadProfilePhoto) {
      yield* _mapUpdateProfilePhotoToState(_api, event.imageFile);
    }
  }

  Stream<UserDetailState> _mapUpdateProfilePhotoToState(
      Api api, File imageFile) async* {
    try {
      yield UserProfilePhotoUpdating();

      String userId = await Util.getCurrentUserId();
      Map result = await api.uploadProfilePic(userId, imageFile);
      yield UserProfilePhotoUpdated(data: result);
    } catch (error) {
      yield UserProfilePhotoNotUpdate();
    }
  }

  Stream<UserDetailState> _mapUpdateUserInfoToState(
      Api api, Map userInfo) async* {
    try {
      yield UserDetailUpdating();
      userInfo['userId'] = await Util.getCurrentUserId();
      Map result = await api.updateUserInfo(userInfo: userInfo);
      yield UserDetailUpdated(data: result);
    } catch (error) {
      yield UserDetailNotUpdate();
    }
  }

  Stream<UserDetailState> _mapLoadUserInfoToState(
      Api api, String userId) async* {
    try {
      if (!Util.isStringNotNull(userId)) {
        userId = await Util.getCurrentUserId();
      }
      Map result = await api.getUserDetail(userId: userId);
      yield UserDetailLoaded(data: result);
    } catch (error) {
      yield UserDetailNotLoaded();
    }
  }

  Stream<UserDetailState> _mapLoadCurrentUserInfoToState() async* {
    try {
      Map result = await Util.getCurrentUserInfo();
      yield UserDetailLoaded(data: result);
    } catch (error) {
      yield UserDetailNotLoaded();
    }
  }

  Stream<UserDetailState> _mapLoadIsCurrentUserToState(
      api, String userId) async* {
    try {
      bool result = await Util.isCurrentUser(userId);
      Map body = Map();
      body['isCurrentUser'] = result;
      yield UserDetailLoaded(data: body);
    } catch (error) {
      yield UserDetailNotLoaded();
    }
  }
}
