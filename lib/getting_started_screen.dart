import 'package:Proxcontrol/server_details_login_screen.dart';
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';

void main() => runApp(GettingStartedScreen());

class GettingStartedScreen extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<GettingStartedScreen> {
  int currentIndexPage;
  int pageLength;

  @override
  void initState() {
    currentIndexPage = 0;
    pageLength = 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            children: <Widget>[
              Walkthrougth(titleTextContent: "Welcome to Proxcontrol", descriptionTextContent: "Take control of your Proxmox cluster today. With everything you need to manage your installation, Proxcontrol is the perfect mobile companion app.", showDone: false,),
              Walkthrougth(titleTextContent: "VM Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Proxcontrol has you covered.", showDone: false,),
              Walkthrougth(titleTextContent: "LXC Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.", showDone: false,),
              Walkthrougth(titleTextContent: "Cluster Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.", showDone: true,),
            ],
            onPageChanged: (value) {
              setState(() => currentIndexPage = value);
            },
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.9),
            child: new DotsIndicator(
              numberOfDot: pageLength,
              position: currentIndexPage,
              dotColor: Colors.black87,
              dotActiveColor: Colors.amber
            ),
          ),
          Align(
            alignment: FractionalOffset(0.92, 0.92),
            child: Container(
              child: getDoneButton(currentIndexPage, pageLength, context)
            )
          )
        ],
      )
    );
  }

    getDoneButton(int currentPageIndex, int amountOfPages, BuildContext context) {
      //if you are on the last page, make the done button visible
      currentPageIndex++;
      if (currentPageIndex == amountOfPages) {
        return FlatButton(
          child: Text(
            'DONE', 
            style: TextStyle(
              fontSize: 15
            )
          ),
          textColor: Colors.orange[200],
          color: Colors.transparent,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ServerDetailsLoginScreen()));
          },
        );
      }
    }
  }

class Walkthrougth extends StatelessWidget {
  final String titleTextContent;
  final String descriptionTextContent;
  final bool showDone;
  Walkthrougth({Key key, @required this.titleTextContent, @required this.descriptionTextContent, @required this.showDone}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      //background colour:
      decoration: BoxDecoration(color: Color.fromARGB(64, 252, 233, 205)),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: FractionalOffset(0.5, 0.15),
              child: FittedBox(
                child: Image(
                image: AssetImage('assets/Prox Logo.png'),        
                width: MediaQuery.of(context).size.width / 4,
                height: MediaQuery.of(context).size.height / 4,
              ),
            ),
          ),
          //Title Container
          Container(
            padding: EdgeInsets.all(5.0),
            alignment: FractionalOffset(0.5, 0.5),
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: FractionalOffset(0.5, 0.45),
                  child: Text(
                    titleTextContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.orange[200], 
                      fontSize: 40.0,
                    ),
                  ),
                ),
                //Description Container
                Container(
                  alignment: FractionalOffset(0.5, 0.75),
                  child: Text(
                    descriptionTextContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pink[200], 
                      fontSize: 20.0
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}