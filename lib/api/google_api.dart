import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:zoomclone/utils/constants.dart';

class GoogleApiClient {
  static const baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=' +
          Constants.PLACE_CREDENTIAL +
          '&types=(cities)&location=latitude,longitude&input=';

  final http.Client httpClient = http.Client();

//  GoogleApiClient() : assert(httpClient != null);

  Future<List> getWaveLikeList(String input) async {
    String url = Uri.encodeFull(baseUrl + input);
    final response = await this.httpClient.get(url);
    final placesJson = jsonDecode(response.body);

    return placesJson["predictions"] as List;
  }
}
