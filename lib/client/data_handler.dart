import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';
import 'package:Proxcontrol/client/objects/auth_realm.dart';
import 'package:Proxcontrol/client/objects/node.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:Proxcontrol/client/objects/auth_details.dart';


class DataHandler {
  static SharedPreferences _preferences;
  static FlutterSecureStorage _secureStorage;
  static bool _hasBeenSetup;
  static var _ticket;
  static var _token;
  static var _baseUrl;
  static List<AuthRealm> _authRealms = new List<AuthRealm>();
  static List<Node> _nodes = new List<Node>();
  static List<VM> _vms = new List<VM>();
  static List<VM> _containers = new List<VM>();

  /// Initialize the DataHandler system
  static Future init() async {
    // Create a connection to the devices secure storage
    _secureStorage = new FlutterSecureStorage();

    // Create a SharedPreferences to handle data storage
    _preferences = await SharedPreferences.getInstance();

    // Check if the app has all ready gone through the setup
    _hasBeenSetup = await (_preferences.get('hasBeenSetup') ?? false);
    print("Setup Value $_hasBeenSetup");

    if (_hasBeenSetup) {
      _ticket = await _secureStorage.read(key: 'ticket');
      _token = await _secureStorage.read(key: 'token');
      _baseUrl = await _secureStorage.read(key: 'baseUrl');
    }
  }

  static void clearAllData() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
  }

  /// Get the current instance of the SharedPreferences
  static SharedPreferences getSharedPreferences() {
    return _preferences;
  }

  /// Get the current instance of the FlutterSecureStorage
  static FlutterSecureStorage getSecureStorage() {
    return _secureStorage;
  }

  /// Get the base URL of the cluster
  static String getBaseUrl(String endpoint) {
    return "$_baseUrl$endpoint";
  }

  static void setBaseUrl(String _fqdn, String _port) async {
    _baseUrl = "https://$_fqdn:$_port/api2/json";
    await _secureStorage.write(key: 'baseUrl', value: _baseUrl);
  }

  static bool hasBeenSetup() {
    return _hasBeenSetup;
  }

  static Future setHasBeenSetup(bool status) async {
    _hasBeenSetup = status;
    await _preferences.setBool('hasBeenSetup', status);
  }

  static String getTicket() {
    return _ticket;
  }

  static void setTicket(String _newTicket) async {
    _ticket = _newTicket;
    await _secureStorage.write(key: "ticket", value: _newTicket);
  }

  static String getToken() {
    return _token;
  }

  static void setToken(String _newToken) async {
    _token = _newToken;
    await _secureStorage.write(key: 'token', value: _newToken);
  }

  static Future<String> getUsername() async {
    return _secureStorage.read(key: 'username');
  }

  static void setUsername(String _username) async {
    await _secureStorage.write(key: 'username', value: _username);
  }

  static Future<String> getRealm() {
    return _secureStorage.read(key: 'realm');
  }

  static void setRealm(String _realm) async {
    await _secureStorage.write(key: 'realm', value: _realm);
  }

  static Future<String> getPassword() async {
    return _secureStorage.read(key: 'password');
  }

  static void setPassword(String _password) async {
    await _secureStorage.write(key: 'password', value: _password);
  }

  static List<AuthRealm> getAuthRealms() {
    return _authRealms;
  }

  static void setAuthRealms(List<AuthRealm> _realms) {
    _authRealms = _realms;
  }

  static List<VM> getVMList() {
    return _vms;
  }

  static void setVMList(List<VM> _list) {
    _vms = _list;
  }

  static List<VM> getContainerList() {
    return _containers;
  }

  static void setContainerList(List<VM> _list) {
    _containers = _list;
  }

  static List<Node> getNodeList() {
    return _nodes;
  }

  static void setNodesList(List<Node> _list) {
    _nodes = _list;
  }
}

class Client extends DataHandler {

  static Future<int> login() async {
    return new Future.sync(() async {
      int _status;

      Map<String, dynamic> body = {'username': "${await DataHandler.getUsername()}@${await DataHandler.getRealm()}", 'password': await DataHandler.getPassword()};

      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(client);

      String url = DataHandler.getBaseUrl("/access/ticket");
      final response = await ioClient.post(url,
          headers: {"Accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"},
          body: body,
          encoding: Encoding.getByName("utf-8")).timeout(Duration(seconds: 10));
      ioClient.close();

      if (response.statusCode == 401) {
        _status = 401;
      } else if (response.statusCode == 200) {
        _status = 200;
        var data = json.decode(response.body);
        AuthDetails details = AuthDetails.fromJson(data['data']);

        DataHandler.setTicket(details.ticket);
        DataHandler.setToken(details.csrfprevetionToken);
      } else {
        _status = -1;
      }

      return _status;
    });
  }

  static Future<bool> requestAuthRealms() async {
    return new Future.sync(() async {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(client);

      var response = await ioClient.get(DataHandler.getBaseUrl("/access/domains")).timeout(Duration(seconds: 10));
      ioClient.close();

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        DataHandler.setAuthRealms(data['data'].map<AuthRealm>((j) => AuthRealm.fromJson(j)).toList());
        return true;
      } else return false;
    });
  }

  static Future<Response> _get(String endpoint) async {
    return new Future.sync(() async {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(client);

      final response = await ioClient.get(
          DataHandler.getBaseUrl(endpoint),
          headers: {"Accept": "application/json", "Cookie" : "PVEAuthCookie=" + DataHandler.getTicket(), "CSRFPreventionToken": DataHandler.getToken()});
      ioClient.close();

      return response;
    });
  }

  static Future<bool> requestVMS() {
    return new Future.sync(() async {
      await _get("/cluster/resources?type=vm").then((response) {
        List<VM> responseList = new List<VM>();
        List<VM> qemu = new List<VM>();
        List<VM> lxc = new List<VM>();

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          responseList = data['data'].map<VM>((j) => VM.fromJson(j)).toList();

          for (int i = 0; i < responseList.length; i++) {
            if ((responseList[i].type).contains("qemu")) {
              qemu.add(responseList[i]);
            } else if ((responseList[i].type).contains("lxc")) {
              lxc.add(responseList[i]);
            }
          }

          DataHandler.setVMList(qemu);
          DataHandler.setContainerList(lxc);
          return true;
        } else return false;
      }).catchError((e) {
        print(e.toString());
      });
    });
  }

  static Future<bool> requestNodes() {
    return new Future.sync(() async {
      await _get("/cluster/resources?type=node").then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          DataHandler.setNodesList(data['data'].map<Node>((j) => Node.fromJson(j)).toList());
          return true;
        } else return false;
      }).catchError((e) {
        print(e.toString());
      });
    });
  }
}