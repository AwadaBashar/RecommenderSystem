import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'sign_in.dart';
import 'package:RecommederSystem/request.dart';
import 'dart:convert';
import 'dart:ui';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:youtube_api/youtube_api.dart';
// import 'package:url_launcher/url_launcher.dart';
// ignore: must_be_immutable
class FirstScreen extends StatefulWidget {
  // ignore: unused_field
  

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  SharedPreferences logindata;
  String from_net = '';
  String name;
  String email;
  String imageUrl;

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    //call();
    //getRequest();
    setState(() {
      name = logindata.getString('name');
      imageUrl = logindata.getString('imageUrl');
      email = logindata.getString('email');
      
    });
  }

  Future<String> call() async {
    var data =
        await getData('https://recommender-system-48708.uc.r.appspot.com/');
    var decodedData = jsonDecode(data);
    setState(() {
      from_net = decodedData['query'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 40),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                from_net,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              // ignore: deprecated_member_use
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  logindata.setBool('login', false);
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return LoginPage();
                  }), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              )
            ],
          ),
        ),
      ),
    );
  }
}