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
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF4d4d4d),
            ),
          ),
          Align(
            alignment: FractionalOffset(0.5, 0.05),
            child: Image(
              image: AssetImage("assets/onboardingBackgroundImage.jpg")
            ),
          ),
          PageView(
            children: <Widget>[
              Walkthrougth(titleTextContent: "Welcome to Proxcontrol", descriptionTextContent: "Take control of your Proxmox cluster today. With everything you need to manage your installation, Proxcontrol is the perfect mobile companion app.", showDone: false, currentPage: currentIndexPage,),
              Walkthrougth(titleTextContent: "VM Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Proxcontrol has you covered.", showDone: false, currentPage: currentIndexPage),
              Walkthrougth(titleTextContent: "LXC Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.", showDone: false, currentPage: currentIndexPage),
              Walkthrougth(titleTextContent: "Cluster Management", descriptionTextContent: "With the ablity to Start/Stop/Restart, Migrate, Create, and Delete your Containers, Procontrol has you covered.", showDone: true, currentPage: currentIndexPage),
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
              MaterialPageRoute(builder: (context) => ServerDetailsLoginScreen()
              )
            );
          },
        );
      }
    }
  }

class Walkthrougth extends StatelessWidget {
  final String titleTextContent;
  final String descriptionTextContent;
  final bool showDone;
  final int currentPage;
  Walkthrougth({Key key, @required this.titleTextContent, @required this.descriptionTextContent, @required this.showDone, @required this.currentPage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
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
          Container(
            alignment: FractionalOffset(0.5, 0.6),
            child: FittedBox(
              child: getIconFromPage(currentPage, context)
            )
          ),
          //Title Container
          Container(
            alignment: FractionalOffset(0.5, 0.5),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 50,
                    bottom: MediaQuery.of(context).size.height / 20,
                    left: MediaQuery.of(context).size.width / 24,
                    right: MediaQuery.of(context).size.width / 24
                  ),
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
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3.5,
                    bottom: MediaQuery.of(context).size.height / 20,
                    left: MediaQuery.of(context).size.width / 16,
                    right: MediaQuery.of(context).size.width / 16
                  ),
                  alignment: FractionalOffset(0.5, 0.75),
                  child: Text(
                    descriptionTextContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pink[200], 
                      fontSize: 18.0
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

  getIconFromPage(int currentPage, BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    switch(currentPage) {
      case 0:
        return Icon(Icons.dns, color: Colors.grey.withOpacity(0.4), size: height / 10);
      case 1:
        return Icon(Icons.equalizer, color: Colors.grey.withOpacity(0.4), size: height / 10);
      case 2:
        return Icon(Icons.layers, color: Colors.grey.withOpacity(0.4), size: height / 10);
      case 3:
        return Icon(Icons.input, color: Colors.grey.withOpacity(0.4), size: height / 10);
      default:
        return Icon(Icons.edit, color: Colors.grey.withOpacity(0.4), size: height / 10);
    }
  }
}
