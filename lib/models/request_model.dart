import 'dart:convert';
import 'dart:io';

import 'package:coneg/models/auth_model.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class RequestConeg {
  static final String route = 'http://localhost:5000';

  Uri _generateUri(String end) {
    return Uri.parse('$route$end');
  }

  Map<String, String> _generateHeaders({String contentType, bool isAuth}) {
    if (isAuth) {
      AuthModel authentication = GetIt.I<AuthModel>();
      return {
        HttpHeaders.authorizationHeader: authentication.toAuth(),
        HttpHeaders.contentTypeHeader: contentType
      };
    } else {
      return {HttpHeaders.contentTypeHeader: contentType};
    }
  }

  Future<Map> getJsonAuth({String endpoint}) async {
    var res = await http.get(
      _generateUri(endpoint),
      headers: _generateHeaders(contentType: 'application/json', isAuth: true),
    );
    return jsonDecode(res.body);
  }

  Future<http.Response> postJsonAuth(
      {String endpoint, Map<String, String> data}) async {
    var req = await http.post(
      _generateUri(endpoint),
      headers: _generateHeaders(contentType: 'application/json', isAuth: true),
      body: jsonEncode(data),
    );
    print(req.request);
    return req;
  }

  Future<http.Response> postForm(
      {String endpoint, Map<String, String> data}) async {
    return http.post(
      _generateUri(endpoint),
      headers: _generateHeaders(
          contentType: 'application/x-www-form-urlencoded', isAuth: false),
      //body: jsonEncode(<String, String>{'username': user, 'password': pass}),
      body: data,
    );
  }

  Future<http.Response> postFormAuth(
      {String endpoint, Map<String, String> data}) async {
    return http.post(
      _generateUri(endpoint),
      headers: _generateHeaders(
          contentType: 'application/x-www-form-urlencoded', isAuth: true),
      body: data,
    );
  }

  // // /upload
  // Future<http.StreamedResponse> postMultipartAuth({String endpoint, Map<String, String> data}) async {
  //   AuthModel authentication = GetIt.I<AuthModel>();
  //   http.MultipartRequest req = http.MultipartRequest(
  //       "POST", Uri.parse('$route$endpoint'));
  //   req.headers.addAll(_generateHeaders(
  //         contentType: 'multipart/form-data', isAuth: true));
  //   req.files.add(await http.MultipartFile.fromBytes('file_rec', _selectedZip,
  //       contentType: MediaType('multipart', 'form-data'),
  //       filename: 'uploaded_file.zip'));

  //   req.send()

  //   return http.post(
  //     Uri.parse('$route$endpoint'),
  //     headers: _generateHeaders(
  //         contentType: 'application/x-www-form-urlencoded', isAuth: true),
  //     body: data,
  //   );
  // }

}
