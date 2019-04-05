import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Proxcontrol/Client/Objects/auth_realms.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ServerAuthLoginScreen extends StatefulWidget {
  final List<AuthRealm> authRealms;
  const ServerAuthLoginScreen({Key key, @required this.authRealms}) : super(key: key);

  @override
  _ServerAuthLoginScreenState createState() => _ServerAuthLoginScreenState(authRealms);
}

class _ServerAuthLoginScreenState extends State<ServerAuthLoginScreen> {
  List<AuthRealm> authRealms;
  _ServerAuthLoginScreenState(this.authRealms);

  String serverRealm;
  String serverUsername;
  String serverPassword;
  bool _connecting = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
      child: TextField(
        onSubmitted: (value) {
          serverUsername = value;
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
      child: TextField(
        obscureText: true,
        onSubmitted: (value) {
          serverPassword = value;
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
        /*
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServerAuthLoginScreen()));
            */
      },
      padding: EdgeInsets.all(10),
      color: Colors.indigoAccent,
      child: Text('LOGIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );

    _buildVerticalLayout() {
      return ListView(
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

    /*
    return Scaffold(
        appBar: AppBar(
            title: Text('Server Connection Details'),
            centerTitle: true),
        body: ModalProgressHUD(
            inAsyncCall: _processing,
            child: OrientationBuilder(
                builder: (context, orientation) {
                  return orientation == Orientation.portrait
                      ? _buildVerticalLayout()
                      : _buildHorizontalLayout();
                }
            )
        )
    );
    */

    return Scaffold(
        appBar: AppBar(
            title: Text('Server Connection Details'),
            centerTitle: true),
        body: _buildVerticalLayout()
    );
  }
}