import 'package:flutter/material.dart';

class ServerAuthLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Server Authentication Details'),
        centerTitle: true),
      body: Center(
        child: Text("Login form will go here."),
      ),
    );
  }
}