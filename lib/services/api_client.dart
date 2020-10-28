import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

APIClient api_client;

class APIClient implements http.Client {

  APIClient(this.client);

  final endpoint = 'https://us-central1-cfcalc.cloudfunctions.net/api';
  // final endpoint = 'http://10.0.2.2:5001/cfcalc/us-central1/api';
  http.Client client;

  @override
  void close() {
    client.close();
  }

  @override
  Future<http.Response> delete(url, {Map<String, String> headers}) {
    return client.delete(endpoint + url, headers: headers);
  }

  @override
  Future<http.Response> get(url, {Map<String, String> headers}) {
    return client.get(endpoint + url, headers: headers);
  }

  @override
  Future<http.Response> head(url, {Map<String, String> headers}) {
    return client.head(endpoint + url, headers: headers);
  }

  @override
  Future<http.Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
    return client.patch(endpoint + url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    return client.post(endpoint + url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<http.Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
    return client.put(endpoint + url, headers: headers, body: body, encoding: encoding);
  }

  @override
  Future<String> read(url, {Map<String, String> headers}) {
    return client.read(endpoint + url, headers: headers);
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
    return client.readBytes(endpoint + url, headers: headers);
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return client.send(request);
  }

}