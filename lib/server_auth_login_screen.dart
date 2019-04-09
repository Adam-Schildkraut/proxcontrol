import 'dart:async';
import 'package:Proxcontrol/Client/client.dart';
import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/Objects/auth_realm.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:Proxcontrol/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Proxcontrol/Client/Objects/node.dart';
import 'package:Proxcontrol/Client/Objects/vm.dart';

class ServerAuthLoginScreen extends StatefulWidget {
  final List<AuthRealm> authRealms;
  final String url;
  final String port;
  const ServerAuthLoginScreen({Key key, @required this.authRealms, @required this.url, @required this.port}) : super(key: key);

  @override
  _ServerAuthLoginScreenState createState() => _ServerAuthLoginScreenState(authRealms, url, port);
}

class _ServerAuthLoginScreenState extends State<ServerAuthLoginScreen> {
  List<AuthRealm> authRealms;
  String url;
  String port;
  _ServerAuthLoginScreenState(this.authRealms, this.url, this.port);
  final _formKey = GlobalKey<FormState>();

  String serverRealm;
  String serverUsername;
  String serverPassword;
  bool _processing = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    void _showDialog(String title, String message) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: new Text(message),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    
    final image = Container(
      child: Hero(
        tag: 'logo',
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: screenWidth / 4,
            child: Image.asset('assets/logo.png')),
      ),
    );

    final realmSelector = FormField(
      validator: (value) {
        if (value.isEmpty) {
          return 'Please select an Authentication Realm';
        }
      },
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
              hasFloatingPlaceholder: true),
          isEmpty: serverRealm == '',
          child: new DropdownButtonHideUnderline(
              child: new DropdownButton(
                  isDense: true,
                  hint: Text('Select an Authentication Realm'),
                  value: serverRealm,
                  items: authRealms.map((AuthRealm value) {
                    return new DropdownMenuItem(
                      value: value.realm,
                      child: Text(value.realm),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    setState(() {
                      serverRealm = value;
                      state.didChange(value);
                    });
                  }
              )
          ),
        );
      },
    );

    final serverUsernameField = Container(
      height: 45,
      padding: EdgeInsets.only(
          top: 2,left: 16, right: 16, bottom: 4
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(50)
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5
            )
          ]
      ),
      child: TextFormField(
        onSaved: (value) {
          serverUsername = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'You must enter a username.';
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.person,
            color: Colors.grey,
          ),
          hintText: 'Username',
        ),
      ),
    );

    final serverPasswordField = Container(
      height: 45,
      padding: EdgeInsets.only(
          top: 2,left: 16, right: 16, bottom: 4
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(50)
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 5
            )
          ]
      ),
      child: TextFormField(
        obscureText: true,
        onSaved: (value) {
          serverPassword = value;
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'You must enter a password.';
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.vpn_key,
            color: Colors.grey,
          ),
          hintText: 'Password',
        ),
      ),
    );

    final nextButton = RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          setState(() {
            _processing = true;
          });

          Client client = new Client(url, port);
          client.login(serverUsername, serverPassword, serverRealm).then((response) async {
            if (response.contains("AUTH_FAIL")) {
              await Future.delayed(new Duration(seconds: 1), () {
                setState(() {
                  _processing = false;
                });
              });
              _showDialog("Authenticaion Error", "The username and password you provided were invalid. Please try again.");
              _formKey.currentState.reset();
            } else if (response.contains("UNKNOWN_ERROR")) {
              await Future.delayed(new Duration(seconds: 5), () {
                setState(() {
                  _processing = false;
                });
              });
              _showDialog("Unknown Error", "An unknown error has occured. Please try again later. If this problem persists please contact your System Administrator");
              _formKey.currentState.reset();
            } else if (response.contains("AUTH_SUCCESS")) {
              await Future.delayed(new Duration(seconds: 1), () {
                setState(() {
                  _processing = false;
                });
              });
              SharedPreferences preferences = await SharedPreferences.getInstance();
              await preferences.setBool('seen', true);

              List<Node> nodes = new List<Node>();
              List<VM> vms = new List<VM>();

              await client.getNodes().then((response) {
                nodes = response;
              });

              await client.getAllVMs().then((response) {
                vms = response;
              });

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(client: client, nodes: nodes, vms: vms)));
            }
          });
        }
      },
      padding: EdgeInsets.all(10),
      color: Colors.indigoAccent,
      child: Text('LOGIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );

    _buildVerticalLayout() {
      return Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight / 40,
                  left: screenWidth / 10,
                  right: screenWidth / 10,
                  bottom: screenHeight / 25),
              child: image,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12),
              child: realmSelector,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 30),
              child: serverUsernameField,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 30,
                  bottom: screenHeight / 20),
              child: serverPasswordField,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 20,
                  bottom: screenHeight / 30),
              child: nextButton,
            ),
          ],
        ),
      );
    }

    _buildHorizontalLayout() {
      return GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    left: screenWidth / 10,
                    right: screenWidth / 10),
                child: image,
              ),
            ],
          ),

          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth / 18,
                    top: screenHeight / 5),
                child: serverUsernameField,
              ),

              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth / 18,
                    top: screenHeight / 30,
                    bottom: screenHeight / 20),
                child: serverPasswordField,
              ),

              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth / 18,
                    top: screenHeight / 20,
                    bottom: screenHeight / 30),
                child: nextButton,
              ),
            ],
          )
        ],
      );
    }
    
    return Scaffold(
        appBar: AppBar(
            title: Text('Server Connection Details'),
            centerTitle: true),
        body: ModalProgressHUD(
            inAsyncCall: _processing,
            child: _buildVerticalLayout()
        )
    );
  }
}