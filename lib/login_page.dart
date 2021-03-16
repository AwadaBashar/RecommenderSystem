import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'sign_in.dart';

import 'first_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();
  showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed:  () {print("aaa");
      return FirstScreen(myController.text);},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: TextField(
          controller: myController,
        ),
    actions: [
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  SharedPreferences logindata;
  bool newuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') == true);
    print(newuser);
    if (newuser != false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => FirstScreen(myController)));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();

  }
void _launchURL() async{
  var _url="https://accounts.google.com/o/oauth2/v2/auth?scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube.readonly&response_type=code&state=security_token%3D138r5719ru3e1%26url%3Dhttps%3A%2F%2Foauth2.example.com%2Ftoken&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&client_id=799910629191-osm5ra0sk2ko49neeptrma6q1dibq7d0.apps.googleusercontent.com";
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async{
        signInWithGoogle().then((result) {
          if (result != null) {
            print('result');
            
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {

                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  final User currentUser = _auth.currentUser;
                  logindata.setBool('login', true);
                  logindata.setString('name', currentUser.displayName);
                  logindata.setString('imageUrl', currentUser.photoURL);
                  logindata.setString('email', currentUser.email);
                  
                  if (currentUser.uid!=""){
                      
                  _launchURL();
                  return FirstScreen(myController);
                  }
                },
              ),
            );
          }
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
