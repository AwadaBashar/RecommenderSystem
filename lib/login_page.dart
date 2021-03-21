import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  // ignore: deprecated_member_use
  
  // set up the AlertDialog
  

  // show the dialog
  
}
  SharedPreferences logindata;
  bool newuser;
  @override
  void initState() {

    super.initState();
    check_if_already_login();
  }

  // ignore: non_constant_identifier_names
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') == true);
    print(newuser);
    if (newuser != false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => FirstScreen()));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();

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
    // ignore: deprecated_member_use
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async{
        signInWithGoogle().then((result) {
          if (result != null) {
            print('result');
            
            Navigator.of(context).push(
              MaterialPageRoute(
                // ignore: missing_return
                builder: (context) {

                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  final User currentUser = _auth.currentUser;
                  logindata.setBool('login', true);
                  logindata.setString('name', currentUser.displayName);
                  logindata.setString('imageUrl', currentUser.photoURL);
                  logindata.setString('email', currentUser.email);
                  
                  if (currentUser.uid!=""){
                      
                  //_launchURL();
                  return FirstScreen();
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
            Image(image: AssetImage("lib/assets/google_logo.png"), height: 35.0),
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