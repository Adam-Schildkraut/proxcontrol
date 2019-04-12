import 'package:flutter/material.dart';
import 'package:Proxcontrol/server_auth_login_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:Proxcontrol/client/data_handler.dart';
import 'package:Proxcontrol/client/client.dart';

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
      child: Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: screenWidth / 4,
          child: Image.asset('assets/logo.png')),
      ),
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

    final nextButton = RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)),
      onPressed: () async {
        if(_formKey.currentState.validate()) {
          _formKey.currentState.save();

          setState(() {
            _connecting = true;
          });
          await DataHandler.init();
          await DataHandler.setBaseUrl(serverAddress, serverPort);
          await Client.requestAuthRealms().then((responseStatus) async {
            if (responseStatus) {
              await Future.delayed(new Duration(seconds: 2), () {
                setState(() {
                  _connecting = false;
                });
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      ServerAuthLoginScreen()));
            } else {
              setState(() {
                _connecting = false;
              });
              _showDialog("Connection Error", "An error has occurred while connecting to your server. Please verify your connection details and try again.");
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
      child: Text('NEXT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
    );

    _buildVerticalLayout() {
      return Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight / 15,
                  left: screenWidth / 10,
                  right: screenWidth / 10,
                  bottom: screenHeight / 25),
              child: image,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 30),
              child: serverAddressField,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 12,
                  right: screenWidth / 12,
                  top: screenHeight / 20,
                  bottom: screenHeight / 20),
              child: serverPortField,
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
        //shrinkWrap: true,
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
                child: serverAddressField,
              ),

              Padding(
                padding: EdgeInsets.only(
                    right: screenWidth / 18,
                    top: screenHeight / 30,
                    bottom: screenHeight / 20),
                child: serverPortField,
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
          inAsyncCall: _connecting,
          child: _buildVerticalLayout())
    );
  }
}