import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../model/title.dart';
import '../theme.dart';
import 'login.dart';

class PasswordRestore extends StatefulWidget {
  @override
  _PasswordRestoreState createState() => _PasswordRestoreState();
}

class _PasswordRestoreState extends State<PasswordRestore> {

  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirm = new TextEditingController();
  bool regist  =false;

  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Center(child: AppTitle("Recupera","Password"))),
        Expanded(flex: 5, child: 
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top:Radius.circular(50)),
              color: whitetheme.backgroundColor,
            ),
            padding: EdgeInsets.fromLTRB(40,0,40,0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  Text("Inserisci qui la tua email, ti verrà inviata una mail per il reset della password!", 
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,),

                  //Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _email,
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.w100
                    ),
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (string){
                      if(!string.contains("@")) return "Check your Email";
                      return null;
                    },
                  ),

                  //Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Recupera", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,)),
                      FloatingActionButton(
                        backgroundColor: whitetheme.accentColor,
                        child: Icon(Icons.arrow_forward, size: 40, color: Colors.black,),
                        onPressed: (){
                          if(!regist && _formKey.currentState.validate()){
                            recover(_email.text, context);
                            regist = true;
                          }
                        }
                      ),
                    ]
                  ),
                ],
              ),
            ),
          )
        ),
      ],
    ) 
        ),
      );
  }

  Future<void>recover(email, context)async{
    User user;
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      
      print("Email: "+email);
      

      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Toast.show("Check your mail inbox!", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    } catch (e) {
      print(e.message);
      Toast.show(e.message, context,duration: 3);
      regist = false;
    }
  }
}