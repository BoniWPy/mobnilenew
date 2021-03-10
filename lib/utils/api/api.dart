import 'dart:convert';

import 'package:http/http.dart' as http;

class CallApi {
  final String _urlLogin = 'https://api.payright.dev/v1/auth/';
  final String _urlApi = 'https://api.payright.dev/v1/apiMobile/';
  final String _urlNotif = "https://api.payright.dev/v1/auth/";

  postDataLogin(data, apiUrl) async {
    var fullUrl = _urlLogin + apiUrl;
    print(fullUrl);
    return await http.post(
      fullUrl,
      headers: _setHeaders(),
      body: jsonEncode(data),
    );
  }

  postData(data, apiUrl) async {
    var fullUrl = _urlApi + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _urlApi + apiUrl;
    print(fullUrl);
    return await http.get(fullUrl, headers: _setHeaders());
  }

  //add post data for update fcm token
  postUpdateFcm(data, apiUrl) async {
    var fullUrl = _urlApi + apiUrl;
    print(fullUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  //add get data for get absence history
  getHistoryAbsence(data, apiUrl) async {
    var fullUrl = _urlApi + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  //get detail notification
  getDetailNotification(data, apiUrl) async {
    var fullUrl = _urlNotif + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  _setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
}
