import 'package:flutter/material.dart';
import 'package:Proxcontrol/Screens/Login/Forms/server_details.dart';
import 'package:Proxcontrol/Screens/Login/Forms/server_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Proxmox Server Details"),
      ),
      body: ServerDetailsForm(),
    );
  }
}

class LoginPageAuth extends StatefulWidget {
  @override
  _LoginPageAuthState createState() => new _LoginPageAuthState();
}

class _LoginPageAuthState extends State<LoginPageAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Proxmox Server Authentication"),
      ),
      body: new ServerAuthForm(),
    );
  }
}