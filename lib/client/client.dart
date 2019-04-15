import 'package:Proxcontrol/client/data_handler.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';
import 'package:Proxcontrol/client/objects/auth_details.dart';
import 'package:Proxcontrol/client/objects/auth_realm.dart';
import 'package:Proxcontrol/client/objects/vm.dart';
import 'package:Proxcontrol/client/objects/node.dart';
import 'package:Proxcontrol/client/objects/vm_stat.dart';

class Client extends DataHandler {

  static Future<int> login() async {
    int _status;

    Map<String, dynamic> body = {'username': "${await DataHandler.getUsername()}@${await DataHandler.getRealm()}", 'password': await DataHandler.getPassword()};

    HttpClient client = new HttpClient();
    client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
    IOClient ioClient = new IOClient(client);

    final response = await ioClient.post(await DataHandler.getBaseUrl("/access/ticket"),
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

      await DataHandler.setTicket(details.ticket);
      await DataHandler.setToken(details.csrfprevetionToken);
    } else {
      _status = -1;
    }

    print("Login Method Completed - Retuning Login status: $_status");
    return _status;
  }

  static Future<bool> requestAuthRealms() async {
    return new Future.sync(() async {
      HttpClient client = new HttpClient();
      client.badCertificateCallback =((X509Certificate cert, String host, int port) => true);
      IOClient ioClient = new IOClient(client);

      var response = await ioClient.get(await DataHandler.getBaseUrl("/access/domains")).timeout(Duration(seconds: 10));
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
          await DataHandler.getBaseUrl(endpoint),
          headers: {"Accept": "application/json", "Cookie" : "PVEAuthCookie=" + await DataHandler.getTicket(), "CSRFPreventionToken": await DataHandler.getToken()});
      ioClient.close();

      return response;
    });
  }

  static Future<bool> requestVMS() {
    return new Future.sync(() async {
      bool _received;
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

          qemu.sort((a, b) => a.vmid.compareTo(b.vmid));
          lxc.sort((a, b) => a.vmid.compareTo(b.vmid));

          DataHandler.setVMList(qemu);
          DataHandler.setContainerList(lxc);
          print("VMs and Containers received");
          _received = true;
        } else _received = false;
      }).catchError((e) {
        print(e.toString());
        _received = false;
      });
      return _received;
    });
  }

  static Future<bool> requestNodes() {
    return new Future.sync(() async {
      bool _received;
      await _get("/cluster/resources?type=node").then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          DataHandler.setNodesList(data['data'].map<Node>((j) => Node.fromJson(j)).toList());
          print("Nodes received");
          _received = true;
        } else _received = false;
      }).catchError((e) {
        print(e.toString());
        _received = false;
      });
      return _received;
    });
  }

  static Future<bool> requestVMStats(String _node, int _vmid, String _timeFrame, String _consolidationType) {
    return new Future.sync(() async {
      bool _received;
      await _get("/nodes/$_node/qemu/$_vmid/rrddata?timeframe=$_timeFrame&cf=$_consolidationType").then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          DataHandler.setVMStatsList(data['data'].map<VMStat>((j) => VMStat.fromJson(j)).toList());
          print("VM Stats for $_vmid received");
          _received = true;
        } else _received = false;
      }).catchError((e) {
        print(e.toString());
        _received = false;
      });
      return _received;
    });
  }
}