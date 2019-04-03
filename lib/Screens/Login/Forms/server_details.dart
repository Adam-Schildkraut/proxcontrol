import 'package:flutter/material.dart';
import 'package:Proxcontrol/Screens/Login/login_screen.dart';

class ServerDetailsForm extends StatefulWidget {
  @override
  _ServerDetailsFormState createState() => new _ServerDetailsFormState();
}

class _ServerDetailsFormState extends State<ServerDetailsForm> {
  final _formKey = GlobalKey<FormState>();

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

            TextFormField(
              keyboardType: TextInputType.url,
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid FQDN/IP';
                }
              },
              decoration: InputDecoration(
                hintText: 'FQDN or IP Address',
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 1/40),

            TextFormField(
              keyboardType: TextInputType.number,
              autofocus: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter a valid port number';
                }
              },
              decoration: InputDecoration(
                hintText: 'API Port',
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
                  // TODO: Get Auth Realms from Server
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context) => new LoginPageAuth()));
                }
              },
              padding: EdgeInsets.all(10),
              color: Colors.indigoAccent,
              child: Text('NEXT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}