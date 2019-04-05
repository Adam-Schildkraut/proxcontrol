import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Proxcontrol/Client/Objects/auth_realms.dart';
import 'package:http/http.dart' as http;

class Client {
  String baseUrl;

  Client(String url, String port) {
    baseUrl = "https://" + url + ":" + port +  "/api2/json/";
  }
}

class API {
  static Future<List<AuthRealm>> getAuthRealms(String url, String port) async {
    List<AuthRealm> realms;
    try {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      http.IOClient ioClient = new http.IOClient(client);
      final response = await ioClient.get("https://" + url + ":" + port + "/api2/json/access/domains");
      final data = await json.decode(response.body);
      realms = await data['data'].map<AuthRealm>((j) => AuthRealm.fromJson(j)).toList();
    } catch (e) {
      print(e.toString());
    }
    return realms;
  }
}