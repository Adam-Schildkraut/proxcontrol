import 'package:flutter/material.dart';
import 'package:Proxcontrol/server_auth_login_screen.dart';
import 'package:Proxcontrol/Client/client.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class ServerDetailsLoginScreen extends StatefulWidget {
  @override
  _ServerDetailsLoginScreenState createState() => _ServerDetailsLoginScreenState();
}

class _ServerDetailsLoginScreenState extends State<ServerDetailsLoginScreen> {
  String serverAddress;
  String serverPort;
  bool _connecting = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFf45d27),
              Color(0xFFf5851f)
            ],
          ),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(90)
          )
      ),
      child: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/Prox Logo.png',
                height: 100,
                width: 100,
              ),
            ),
            Align(
              alignment: FractionalOffset(0.9, 0.85), 
              child: Text(
                "Connect To Server",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                )
              )
            ),
          ]
        ),
      )
    );

    final serverAddressField = Container(
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
        validator: (value) {
          if (value.isEmpty) {
            return 'You must specify a FQDN or IP.';
          } else if (value.contains('http://')) {
            return 'This should not contan http://';
          } else if (value.contains('https://')) {
            return 'This should not contain https://';
          }
        },
        onSaved: (value) {
          value = value.replaceAll(new RegExp(r"http://"), '');
          value = value.replaceAll(new RegExp(r"https://"), '');
          serverAddress = value;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.dns,
            color: Colors.grey,
          ),
          hintText: 'FQDN or IP Address',
        ),
      ),
    );

    final serverPortField = Container(
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
        validator: (value) {
          if (value.isEmpty) {
            return 'You must specify a port.';
          }
        },
        onSaved: (value) {
          serverPort = value;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.vpn_key,
            color: Colors.grey,
          ),
          hintText: 'API Port',
        ),
      ),
    );

    final nextButton = Center(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GradientButton(
          callback: () {
          if(_formKey.currentState.validate()) {
            _formKey.currentState.save();

            setState(() {
              _connecting = true;
            });

            API.getAuthRealms(serverAddress, serverPort).then((realms) async {
              if (realms != null) {
                await Future.delayed(new Duration(seconds: 2), () {
                  setState(() {
                    _connecting = false;
                  });
                });
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>
                        ServerAuthLoginScreen(authRealms: realms,
                            url: serverAddress,
                            port: serverPort)));
              }
            }).catchError((e) {
              print(e.toString());
              setState(() {
                _connecting = false;
              });
              _showDialog("Connection Error", "An error has occurred while connecting to your server. Please verify your connection details and try again.");
              _formKey.currentState.reset();
            });
          }
        },
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFff9321),
              Color(0xFFffb946)
            ],
          ),
          increaseWidthBy: 180,
          increaseHeightBy: 5,
          child: Text('NEXT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
          )
        ]
      ),
    );

    _buildVerticalLayout() {
      return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            image,
            
            Align(
              alignment: FractionalOffset(0.5, 0.49),
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight / 16,
                    bottom: screenHeight / 24,
                    left: screenWidth / 12,
                    right: screenWidth / 12,
                  ),
                child: serverAddressField
              ),
            ),
                
            Align(
              alignment: FractionalOffset(0.5, 0.6),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: screenHeight / 12,
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 24,
                ),
                child: serverPortField,
              ),
            ),
            
            Align(
              alignment: FractionalOffset(0.5, 0.6),
              child: nextButton,
            ),      
          ],
        ),
      );
    }

    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: _connecting,
          child: _buildVerticalLayout()
      )
    );
  }
}