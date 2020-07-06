import 'dart:io';

import 'package:zoomclone/api/api_client.dart';
import 'package:zoomclone/utils/util.dart';

class Api {
  String baseUrl = 'https://live-up.herokuapp.com';
  ApiClient _apiClient = new ApiClient();

  Future<Map> loginSignUpApi({Map userInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/loginSignUp';

    final response = await _apiClient.post(unreadAmaCountUrl, body: userInfo);
    return response as Map;
  }

  Future<Map> sendUserInfoWelcome({Map userInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/updateInfoWelcome';

    final response = await _apiClient.put(unreadAmaCountUrl, body: userInfo);
    return response as Map;
  }

  Future<Map> sendUserInfoDesignation({Map userInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/updateInfoDesignation';

    final response = await _apiClient.put(unreadAmaCountUrl, body: userInfo);
    return response as Map;
  }

  Future<Map> sendUserInfoAge({Map userInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/updateInfoAge';

    final response = await _apiClient.put(unreadAmaCountUrl, body: userInfo);
    return response as Map;
  }

  Future<Map> createSession({Map sessionInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/createSession';

    final response =
        await _apiClient.post(unreadAmaCountUrl, body: sessionInfo);
    return response as Map;
  }

  Future<Map> insertNetworkList({List userList, String networkUserId}) async {
    final unreadAmaCountUrl = '$baseUrl/insertNetworkList';

    Map body = Map();
    body['networkUserId'] = networkUserId;
    body['userList'] = userList;
    final response = await _apiClient.post(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<List> getNetworkById({String networkUserId}) async {
    final unreadAmaCountUrl = '$baseUrl/getNetworkById/$networkUserId';

    final response = await _apiClient.get(unreadAmaCountUrl);
    return response as List;
  }

  Future<Map> updateSession({Map sessionInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/updateSessionDetail';

    final response = await _apiClient.put(unreadAmaCountUrl, body: sessionInfo);
    return response as Map;
  }

  Future<List> getUserDetailByPattern({String pattern}) async {
    String userId = await Util.getCurrentUserId();
    final unreadAmaCountUrl =
        '$baseUrl/getUserDetailByPattern/$pattern/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<Map> getUserDetail({String userId}) async {
    final unreadAmaCountUrl = '$baseUrl/UserDetailById/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as Map;
  }

  Future<Map> updateUserInfo({Map userInfo}) async {
    final unreadAmaCountUrl = '$baseUrl/updateUserInfo';

    final response = await _apiClient.put(unreadAmaCountUrl, body: userInfo);
    return response as Map;
  }

  Future<Map> updateUserProfilePic({String profilePicUrl}) async {
    final unreadAmaCountUrl = '$baseUrl/updateUserInfoProficPicUrl';

    Map body = Map();
    body['profilePicUrl'] = profilePicUrl;

    final response = await _apiClient.put(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<Map> getSessionInfoById({String sessionId}) async {
    final unreadAmaCountUrl = '$baseUrl/getSessionInfo/$sessionId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as Map;
  }

  Future<List> getAllSessionOfUser({String userId}) async {
    final unreadAmaCountUrl = '$baseUrl/getAllSessionOfUser/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<List> getEndedSessionListOfUser({String userId}) async {
    final unreadAmaCountUrl = '$baseUrl/getEndedSessionListOfUser/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<List> getScheduleSessionListOfUser({String userId}) async {
    final unreadAmaCountUrl = '$baseUrl/getScheduleSessionListOfUser/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<List> getLiveSessionListOfUser({String userId}) async {
    final unreadAmaCountUrl = '$baseUrl/getLiveSessionListOfUser/$userId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<List> getSessionCommentList({String sessionId}) async {
    final unreadAmaCountUrl = '$baseUrl/getCommentListBySessionId/$sessionId';

    final response = await _apiClient.get(
      unreadAmaCountUrl,
    );
    return response as List;
  }

  Future<Map> postCommentInSession({Map comment}) async {
    final unreadAmaCountUrl = '$baseUrl/insertCommentInList';

    final response = await _apiClient.post(unreadAmaCountUrl, body: comment);
    return response as Map;
  }

  Future<Map> updateFcmToken({String fcmToken}) async {
    final unreadAmaCountUrl = '$baseUrl/updateFcmToken';
    final userId = await Util.getCurrentUserId();
    Map body = Map();
    body['userId'] = userId;
    body['fcmToken'] = fcmToken;
    final response = await _apiClient.put(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<Map> updateSessionStatus({String sessionId, String status}) async {
    final unreadAmaCountUrl = '$baseUrl/updateSessionStatus';

    Map body = Map();
    body['sessionId'] = sessionId;
    body['status'] = status;
    final response = await _apiClient.put(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<Map> endSessionStatus({
    String sessionId,
  }) async {
    final unreadAmaCountUrl = '$baseUrl/endSessionStatus';

    Map body = Map();
    body['sessionId'] = sessionId;
    final response = await _apiClient.put(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<Map> createFeedback({
    Map deviceInfo,
  }) async {
    final unreadAmaCountUrl = '$baseUrl/insertFeedback';

    final response = await _apiClient.post(unreadAmaCountUrl, body: deviceInfo);
    return response as Map;
  }

  Future<Map> deleteSession({
    String sessionId,
  }) async {
    final unreadAmaCountUrl = '$baseUrl/deleteSession';

    Map body = Map();
    body['sessionId'] = sessionId;
    final response = await _apiClient.delete(unreadAmaCountUrl, body: body);
    return response as Map;
  }

  Future<Map> uploadProfilePic(String userId, File imageFile) async {
    final editProfileUrl = '$baseUrl/uploadImage/$userId';
    FileInfo fileInfo = FileInfo(imageFile, 'myfile.png', 'myfile');

    Map<String, String> headers = Map();
    if (Platform.isAndroid) {
      headers[HttpHeaders.contentTypeHeader] = 'multipart/form-data';
    }

    var postOpinionResponse = await _apiClient.uploadFile(
      editProfileUrl,
      fileInfo,
      headers: headers,
    );
    return postOpinionResponse as Map;
  }
}
