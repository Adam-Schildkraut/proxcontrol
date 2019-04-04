import 'dart:async';
import 'package:http/http.dart' as http;

class Client {
  String baseUrl;

  Client(String url, int port) {
    baseUrl = "https://" + url + ":" + port.toString() +  "/api2/json/";
  }

  Future getAuthRealms() {
    return http.get(baseUrl + "access/domains");
  }
}