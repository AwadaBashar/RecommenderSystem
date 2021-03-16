import 'package:flutter/material.dart';

import 'first_screen.dart';
// ignore: must_be_immutable
class MyLayout extends StatelessWidget {
  var myController;
  MyLayout(con){
    myController=con;
  }
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[TextField(controller: myController,),FlatButton(
    child: Text("Continue"),
    onPressed:  () {
      return FirstScreen(myController.text);},
  )
            ]));
  }
}