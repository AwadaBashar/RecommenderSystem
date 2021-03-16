import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  var _accessToken;

  FirstScreen( access) {
    this._accessToken = access;
  }

  @override
  _FirstScreenState createState() => _FirstScreenState(_accessToken);
}

class _FirstScreenState extends State<FirstScreen> {
  SharedPreferences logindata;
  String from_net = '';
  String name;
  String email;
  String imageUrl;
  var access;
    _FirstScreenState (x){
    access=x;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    //call();
    //getRequest();
print(access.text);
    setState(() {
      print(access.text);
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
// GET https://youtube.googleapis.com/youtube/v3/activities?mine=true&key=[YOUR_API_KEY] HTTP/1.1

// Authorization: Bearer [YOUR_ACCESS_TOKEN]
// Accept: application/json
 Future<List> getRequest() async {
  
    Response res = await http.get('https://youtube.googleapis.com/youtube/v3/activities?mine=true&key=AIzaSyBBfBAyyKcmflKe00yobh3PozQFf0bAzZ4',headers:{'Authorization':'Bearer '+access.text,'Accept':'application/json'});
    
      if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
        
      print(body);
      }
      else if(res.statusCode==401){
        print('false 401 ok');
      }
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
              TextField(controller: access),
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
              RaisedButton(onPressed:() async{
                print(access.text);
                print('Bearer '+access.text);
                var json1=await http.get('https://youtube.googleapis.com/youtube/v3/subscriptions?part=snippet%2CcontentDetails&mine=true&key=AIzaSyBBfBAyyKcmflKe00yobh3PozQFf0bAzZ4',headers:{'Authorization': 'Bearer ' +access.text,'Accept':'application/json'});
                var responseData = json.decode(json1.body); 
                print(json1.statusCode);
                //access.dispose();
              },color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'get token',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
              SizedBox(height: 40),
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
