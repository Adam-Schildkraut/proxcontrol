import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:Proxcontrol/screens/main_lists/main_lists_screen.dart';
import 'package:Proxcontrol/client/objects/auth_realm.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

class ServerAuthLoginScreen extends StatefulWidget {
  @override
  _ServerAuthLoginScreenState createState() => _ServerAuthLoginScreenState();
}

class _ServerAuthLoginScreenState extends State<ServerAuthLoginScreen> {
  List<AuthRealm> authRealms;
  final _formKey = GlobalKey<FormState>();

  String serverRealm;
  String serverUsername;
  String serverPassword;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    authRealms = DataHandler.getAuthRealms();
  }

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
        if (value == null) {
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
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          setState(() {
            _processing = true;
          });

          await DataHandler.setRealm(serverRealm);
          await DataHandler.setUsername(serverUsername);
          await DataHandler.setPassword(serverPassword);
          await DataHandler.setDefaults();

          await Client.login().then((responseCode) async {
            if (responseCode == 200) {
              await Future.delayed(new Duration(seconds: 1), () {
                setState(() {
                  _processing = false;
                });
              });
              await DataHandler.setHasBeenSetup(true);
              await Client.requestVMS();
              await Client.requestNodes();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()));
            } else if (responseCode == 401) {
              await Future.delayed(new Duration(seconds: 1), () {
                setState(() {
                  _processing = false;
                });
              });
              _showDialog("Authenticaion Error", "The username and password you provided were invalid. Please try again.");
              _formKey.currentState.reset();
            } else if (responseCode == -1) {
              await Future.delayed(new Duration(seconds: 5), () {
                setState(() {
                  _processing = false;
                });
              });
              _showDialog("Unknown Error", "An unknown error has occured. Please try again later. If this problem persists please contact your System Administrator");
              _formKey.currentState.reset();
            }
          }).catchError((e) {
            print(e.toString());
          }).timeout(new Duration(seconds: 10), onTimeout: () {
            _showDialog("Connection Timed Out", "Your connection has timed out after 10 seconds of no activity. Please check your connection settings and try again.");
            _formKey.currentState.reset();
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

    /*
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
    */
    
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