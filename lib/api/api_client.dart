import 'dart:io';

import 'package:dio/dio.dart';

class ApiClient {
  static ApiClient _instance = new ApiClient.internal();
  static Dio _dio;

  ApiClient.internal() {
    _dio = Dio(BaseOptions(connectTimeout: 20000));
  }

  factory ApiClient() => _instance;

  Future<dynamic> get(
    String url, {
    Map<String, String> headers,
  }) async {
    Response response;
    try {
      response = await _dio.get(url, options: Options(headers: headers));
      final data = response.data;
      return data['data'];
    } catch (error) {
      response = error.response;
    }
  }

  Future<dynamic> getForFacebook(
    String url, {
    Map<String, String> headers,
  }) async {
    Response response;
    try {
      response = await _dio.get(url, options: Options(headers: headers));
      return response.data;
    } catch (error) {
      response = error.response;
    }
  }

  Future<dynamic> post(
    String url, {
    Map<String, String> headers,
    body,
  }) async {
    Response response;
    try {
      response =
          await _dio.post(url, data: body, options: Options(headers: headers));
      final data = response.data;
      return data['data'];
    } catch (error) {
      response = error.response;
    }
  }

  Future<dynamic> delete(String url,
      {Map<String, String> headers, body}) async {
    Response response;
    try {
      response = await _dio.delete(url,
          options: Options(headers: headers), data: body);
      final data = response.data;
      return data['data'];
    } catch (error) {
      response = error.response;
    }
  }

  Future<dynamic> put(
    String url, {
    Map<String, String> headers,
    body,
  }) async {
    Response response;
    try {
      response =
          await _dio.put(url, options: Options(headers: headers), data: body);
      final data = response.data;
      return data['data'];
    } catch (error) {
      response = error.response;
    }
  }

  Future<dynamic> uploadFile(String url, FileInfo fileInfo,
      {Map<String, dynamic> headers,
      Map<String, dynamic> bodyParams,
      List exceptionList}) async {
    Map<String, dynamic> fileData = {
      fileInfo.fieldName: await MultipartFile.fromFile(
        fileInfo.file.path,
        filename: fileInfo.fileName,
      )
    };

    if (bodyParams != null) fileData.addAll(bodyParams);
    FormData formData = FormData.fromMap(fileData);

    Options options = Options(headers: headers);
    Response response;

    try {
      response = await _dio.post(
        url,
        data: formData,
        options: options,
        onSendProgress: (int sent, int total) {
          print(sent.toString());
          print(' ' + total.toString());
        },
      );
      final data = response.data;
      return data['body'];
    } catch (error) {
      response = error.response;
    }
  }
}

/// Describes the info of file to upload.
class FileInfo {
  FileInfo(this.file, this.fileName, this.fieldName);

  /// The file to upload.
  final File file;

  /// The file name which the server will receive.
  final String fileName;

  /// This field name will be used in the params for this file
  final String fieldName;
}
