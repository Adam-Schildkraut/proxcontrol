import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Proxcontrol/Client/Objects/auth_realm.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/Client/Objects/auth_details.dart';
import 'package:Proxcontrol/main.dart';
import 'package:Proxcontrol/Client/Objects/node.dart';
import 'package:Proxcontrol/Client/Objects/vm.dart';

class Client {
  String baseUrl;
  String _username;
  String _ticket;
  String _CSRFPreventionToken;
  SharedPreferences _preferences;

  Client(String url, String port) {
    _preferences = getSharedPreferences();
    bool _seen = (_preferences.get('seen') ?? false);
    if (_seen) {
      _ticket = _preferences.getString('ticket');
      _CSRFPreventionToken = _preferences.get('CSRFPreventionToken');
      _username = _preferences.getString('username');
    } else {
      _preferences.setString('url', url);
      _preferences.setString('port', port);
    }
    baseUrl = "https://" + url + ":" + port +  "/api2/json/";
  }

  Future<Response> get(String endpoint) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);

    final response = await ioClient.get(baseUrl + endpoint, headers: {"Accept": "application/json", "Cookie" : "PVEAuthCookie=" + _ticket, "CSRFPreventionToken": _CSRFPreventionToken});

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception("Error executing get request");
    }
  }

  Future<String> login(String username, String password, String authRealm) async {
    final _sStorage = getSecureStorage();
    Map<String, dynamic> body = {'username': username + "@" + authRealm, 'password': password};

    HttpClient client = new HttpClient();
    client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);

    final response = await ioClient.post(baseUrl + "access/ticket",
        headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
        body: body,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 401) {
      print(response.body);
      return "AUTH_FAIL";
    } else if (response.statusCode == 200){
      var data = json.decode(response.body);
      print(data);
      AuthDetails details = new AuthDetails.fromJson(data);

      await _sStorage.write(key: 'password', value: password);

      _preferences.setString('username', details.data.username);
      _username = details.data.username;
      print("Set Username: ${details.data.username}");

      _preferences.setString('ticket', details.data.ticket);
      _ticket = details.data.ticket;
      print("Set Ticket: ${details.data.ticket}");

      _preferences.setString('CSRFPreventionToken', details.data.csrfprevetionToken);
      _CSRFPreventionToken = details.data.csrfprevetionToken;
      print("Set CSRFPreventionToken: ${details.data.csrfprevetionToken}");

      return "AUTH_SUCCESS";
    } else {
      print(response.body);
      return "UNKNOWN_ERROR";
    }
  }

  Future<bool> getNewTicket() async {
    final _sStorage = getSecureStorage();
    String pass = await _sStorage.read(key: 'password');
    Map<String, dynamic> body = {'username': _username, 'password': pass};

    HttpClient client = new HttpClient();
    client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);

    final response = await ioClient.post(baseUrl + "access/ticket",
        headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
        body: body,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      AuthDetails details = new AuthDetails.fromJson(data);
      //AuthDetails details = data['data'].map<AuthDetails>((j) => AuthDetails.fromJson(j));

      _preferences.setString('username', details.data.username);
      _username = details.data.username;

      _preferences.setString('ticket', details.data.ticket);
      _ticket = details.data.ticket;

      _preferences.setString('CSRFPreventionToken', details.data.csrfprevetionToken);
      _CSRFPreventionToken = details.data.csrfprevetionToken;
      return true;
    } else {
      print(response.body);
      return false;
    }
  }
  
  
  Future<List<Node>> getNodes() async {
    return new Future.sync(() async {
      List<Node> nodes;
      await get("nodes").then((response) {
        print("Nodes RAW: ${response.body}");
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print("Nodes Parsed: $data");
          nodes = data['data'].map<Node>((j) => Node.fromJson(j)).toList();
        }
      });
      return nodes;
    });
  }
  
  Future<List<VM>> getVMsFromNode(String node) async {
    return new Future.sync(() async {
      List<VM> vms;
      await get("nodes/" + node + "/qemu").then((response) {
        print("VMs RAW: ${response.body}");
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print("VMs Parsed: $data");
          vms = data['data'].map<VM>((j) => VM.fromJson(j)).toList();
        }
      });
      return vms;
    });
  }
  
  Future<List<VM>> getAllVMs() async {
    return new Future.sync(() async {
      List<Node> nodes;
      List<VM> vms;
      
      await getNodes().then((response) {
        nodes = response;
      });
      
      for (int i = 0; i < nodes.length; i++) {
        await getVMsFromNode(nodes[i].node).then((response) {
          vms.addAll(response);
        });
      }
      return vms;
    });
  }
}

class API {
  static Future<List<AuthRealm>> getAuthRealms(String url, String port) async {
    return new Future.sync(() async {
      List<AuthRealm> realms;
      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(client);

      var response = await ioClient.get("https://" + url + ":" + port + "/api2/json/access/domains").timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        realms = data['data'].map<AuthRealm>((j) => AuthRealm.fromJson(j)).toList();
        return realms;
      } else {
        throw("Unable to parse data");
      }
    });
  }
}