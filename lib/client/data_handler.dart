import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:Proxcontrol/client/objects/auth_realm.dart';
import 'package:Proxcontrol/client/objects/node.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:Proxcontrol/client/objects/vm_stat.dart';

class DataHandler {
  static SharedPreferences _preferences;
  static FlutterSecureStorage _secureStorage;
  static List<AuthRealm> _authRealms = new List<AuthRealm>();
  static List<Node> _nodes = new List<Node>();
  static List<VM> _vms = new List<VM>();
  static List<VM> _containers = new List<VM>();
  static List<VMStat> _vmStatsList = new List<VMStat>();

  /// Initialize the DataHandler system.
  static Future init() async {
    // Create a connection to the devices secure storage
    _secureStorage = new FlutterSecureStorage();

    // Create a SharedPreferences to handle data storage
    _preferences = await SharedPreferences.getInstance();
    print("DataHandler Initialized.");
  }

  /// A method for debugging. Clears all setting and security info.
  static void clearAllData() async {
    await _preferences.clear();
    await _secureStorage.deleteAll();
  }

  /// Set all user configurable preferences to their defaults.
  static Future setDefaults() async {
    await setShowTemplates(false);
  }

  /// Get the current instance of the SharedPreferences.
  static SharedPreferences getSharedPreferences() {
    return _preferences;
  }

  /// Get the current instance of the FlutterSecureStorage.
  static FlutterSecureStorage getSecureStorage() {
    return _secureStorage;
  }

  /// Get the base URL of the cluster being accessed.
  ///
  /// Returns a [String] containing the full URL of a request to the cluster.
  /// Accepts the [endpoint] URL as a [String].
  static Future<String> getBaseUrl(String endpoint) async {
    return "${await _secureStorage.read(key: 'baseUrl').catchError((e) {
      print(e.toString());
    })}$endpoint";
  }

  /// Set the base URL of the cluster being accessed.
  ///
  /// Accepts two [String]s, one for the fully qualified domain name or IP address
  /// and the second for the port.
  static Future setBaseUrl(String _fqdn, String _port) async {
    await _secureStorage.write(key: 'baseUrl', value: "https://$_fqdn:$_port/api2/json").catchError((e) {
      print(e.toString());
    });
  }

  /// Returns `true` if the app has been run and setup complete.
  static Future<bool> hasBeenSetup() async {
    return await (_preferences.get('hasBeenSetup') ?? false);
  }

  /// Sets the boolean value of `hasBeenSetup` in the preferences to the value
  /// of the [bool] that has been passed in.
  static Future setHasBeenSetup(bool status) async {
    await _preferences.setBool('hasBeenSetup', status).catchError((e) {
      print(e.toString());
    });
  }

  static Future<bool> showTemplates() async {
    return await _preferences.get('showTemplates') ?? false;
  }

  static Future setShowTemplates(bool newValue) async {
    await _preferences.setBool('showTemplates', newValue).catchError((e) {
      print(e.toString());
    });
  }

  /// Returns a [String] containing the current access ticket.
  static Future<String> getTicket() async {
    return await _secureStorage.read(key: 'ticket').catchError((e) {
      print(e.toString());
    });
  }

  /// Sets the access ticket to the value of the [String] passed into the method.
  static Future setTicket(String _newTicket) async {
    await _secureStorage.write(key: "ticket", value: _newTicket).catchError((e) {
      print(e.toString());
    });
  }

  /// Returns a [String] containing the CSRFPreventionToken.
  static Future<String> getToken() async {
    return await _secureStorage.read(key: 'token').catchError((e) {
      print(e.toString());
    });
  }

  /// Sets the CSRFPreventionToken to the value of the [String] passed into the method.
  static Future setToken(String _newToken) async {
    await _secureStorage.write(key: 'token', value: _newToken).catchError((e) {
      print(e.toString());
    });
  }

  /// Returns a [Future<String>] containing the username that has been saved in the devices
  /// secured storage.
  static Future<String> getUsername() async {
    return await _secureStorage.read(key: 'username').catchError((e) {
      print(e.toString());
    });
  }

  /// Sets the username saved in the devices secured storage to the value of the [String]
  /// that has ben passed to the method.
  static Future setUsername(String _username) async {
    await _secureStorage.write(key: 'username', value: _username).catchError((e) {
      print(e.toString());
    });
  }

  /// Returns a [Future<String>] containing the authentication realm of the cluster
  /// being accessed.
  static Future<String> getRealm() async {
    return await _secureStorage.read(key: 'realm').catchError((e) {
      print(e.toString());
    });
  }

  /// Sets the authentication realm saved in the devices secured storage to the value of the [String]
  /// that has been passed to the method.
  static Future setRealm(String _realm) async {
    await _secureStorage.write(key: 'realm', value: _realm).catchError((e) {
      print(e.toString());
    });
  }

  static Future<String> getPassword() async {
    return await _secureStorage.read(key: 'password').catchError((e) {
      e.toString();
    });
  }

  static Future setPassword(String _password) async {
    await _secureStorage.write(key: 'password', value: _password).catchError((e) {
      print(e.toString());
    });
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

  static List<VMStat> getVMStatsList() {
    return _vmStatsList;
  }

  static void setVMStatsList(List<VMStat> _list) {
    _vmStatsList = _list;
  }
}