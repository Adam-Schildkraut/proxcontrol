import 'package:flutter/material.dart';
import 'package:Proxcontrol/server_auth_login_screen.dart';

class ServerDetailsLoginScreen extends StatefulWidget {
  @override
  _ServerDetailsLoginScreenState createState() => _ServerDetailsLoginScreenState();
}

class _ServerDetailsLoginScreenState extends State<ServerDetailsLoginScreen> {
  String serverAddress;
  String serverPort;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final image = Container(
      padding: EdgeInsets.only(
        top: screenHeight / 15,
        left: screenWidth / 10,
        right: screenWidth / 10,
        bottom: screenHeight / 25),
      child: Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: screenWidth / 4,
          child: Image.asset('assets/logo.png'),
        ),),
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
      child: TextField(
        onSubmitted: (value) {
          value.replaceAll(new RegExp(r"http://"), '');
          value.replaceAll(new RegExp(r"https://"), '');
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
      child: TextField(
        onSubmitted: (value) {
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
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ServerAuthLoginScreen()));
      },
      padding: EdgeInsets.all(10),
      color: Colors.indigoAccent,
      child: Text('NEXT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Server Connection Details'),
        centerTitle: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          image,

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
                top: screenHeight / 30,
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
}