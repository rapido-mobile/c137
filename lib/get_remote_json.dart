import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> getAndDecodeRemoteJSon(url, {Map<String, String> headers}) async {
  http.Client client = http.Client();
  Map object = {};
  await client.get(url, headers: headers).then((http.Response response) async {
    await _decodeJson(response.body).then((result) {
      object = result;
    });
  }).whenComplete(client.close);
  return object;
}

Future _decodeJson(jsonBody) async {
  Map decoded = json.decode(jsonBody);
  return decoded;
}
