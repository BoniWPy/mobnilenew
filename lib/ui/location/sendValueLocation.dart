import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//@imammtq create class for get response from RESTAPI
class SendingLocation {
  final String status;
  final String message;

  SendingLocation({this.status, this.message});

  factory SendingLocation.fromJson(Map<String, dynamic> json) {
    return SendingLocation(
      // status: json['status'],
      status: "Guds!!!",
      message: json['message'],
    );
  }
}
//@imammtq END

//@imammtq handling response
Future<SendingLocation> post(String url, var body) async {
  return await http.post(Uri.encodeFull(url),
      body: body,
      headers: {"Accept": "application/json"}).then((http.Response response) {
    final int statusCode = response.statusCode;

    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    return SendingLocation.fromJson(json.decode(response.body));
  });
}
//@imamtmq END handling response
