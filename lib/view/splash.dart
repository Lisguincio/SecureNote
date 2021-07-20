import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:securenote/auth.dart';
import 'package:securenote/view/login.dart';
import 'package:securenote/main.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/view/settings.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  

  @override
  initState() {
    initPrefs();
    LocalAuthenticationService(context).loadtypes();

    mainUser = FirebaseAuth.instance.currentUser;
    if(mainUser == null){
       Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      
    }
    else{
      Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()))
            .catchError((err) => print(err));
    }
    /* FirebaseAuth.instance.currentUser().then((currentUser) {
      if (currentUser == null) {
         Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
       } 
      else {
        mainUser = currentUser;
        Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()))
            .catchError((err) => print(err));
      }
    }).catchError((err) => print(err)); */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitetheme.accentColor,
      body: Center(child: AppTitle("Secure", "Note")),
    );
  }
}
