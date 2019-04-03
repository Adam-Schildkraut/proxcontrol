import 'package:flutter/material.dart';
import 'package:Proxcontrol/Screens/home_screen.dart';

class ServerAuthForm extends StatefulWidget {
  @override
  _ServerDetailsAuthState createState() => new _ServerDetailsAuthState();
}

class _ServerDetailsAuthState extends State<ServerAuthForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> _realms = ['PAM Authentication', 'Proxmox VE Authentication'];
  String _selectedRealm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 1/12,
              right: MediaQuery.of(context).size.width * 1/12),
          children: <Widget>[
            Hero(
              tag: 'hero',
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: MediaQuery.of(context).size.width * 1/4,
                child: Image.asset('assets/logo.png'),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1/14),

            DropdownButton<String>(
              hint: Text("Please select and Auth Realm"),
              value: _selectedRealm,
              onChanged: (newValue) {
                setState(() {
                  _selectedRealm = newValue;
                });
              },
              items: _realms.map((realm) {
                return DropdownMenuItem(
                  child: new Text(realm),
                  value: realm,
                );
              }).toList(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1/40),

            TextFormField(
              keyboardType: TextInputType.url,
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a username';
                }
              },
              decoration: InputDecoration(
                hintText: 'Username',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1/40),

            TextFormField(
              keyboardType: TextInputType.text,
              autofocus: false,
              obscureText: true,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a password';
                }
              },
              decoration: InputDecoration(
                hintText: 'Password',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1/10),

            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                    // TODO: Get user tokens and stuff from API and store to SharedPreferences
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                            builder: (context) => new HomeScreen()), (
                        Route<dynamic> route) => false);
                }
              },
              padding: EdgeInsets.all(10),
              color: Colors.indigoAccent,
              child: Text('LOGIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}