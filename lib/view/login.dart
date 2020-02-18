import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:securenote/main.dart';
import 'package:securenote/theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _pass = new TextEditingController();
  TextEditingController _email = new TextEditingController();

  bool _obscure = false; //Variabile per il toggle del visualizza password

  bool login = false; //Variabile per evitare che il doppio TAP su Login effettui due volte il login

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: SafeArea(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Center(child: AppTitle("Secure","Note"))),
        Expanded(flex: 2, child: 
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top:Radius.circular(50)),
              color: whitetheme.backgroundColor,
            ),
            padding: EdgeInsets.fromLTRB(40,20,40,20),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[

                  
                  //Email
                  Expanded(
                    flex: 1,
                    child: TextFormField(
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
                  ),

                  //Password
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_obscure,
                      controller: _pass,
                      style: TextStyle(
                        fontSize: 20,
                        //fontWeight: FontWeight.w100
                      ),
                      decoration: InputDecoration(
                        hintText: "Password",
                        suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye), onPressed: ()=>setState((){_obscure = !_obscure;})),
                        border: UnderlineInputBorder(),
                      ),
                      validator: (string){
                        if(string.length < 8) return "Check your Password";
                        return null;
                      },
                    ),
                  ),
                  
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(child: Text("Entra", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,)),
                        FloatingActionButton(
                          backgroundColor: whitetheme.accentColor,
                          child: Icon(Icons.arrow_forward, size: 40, color: Colors.black,),
                          onPressed: (){
                            if(!login && _formKey.currentState.validate()){
                              autenticate(_email.text, _pass.text, context);
                              login = true;
                            }
                          }
                        ),
                      ]
                    )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: Text("Registrati", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 18)),
                        onTap: null,
                      ),
                      GestureDetector(
                        child: Text("Password\nDimenticata", style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.end),
                        onTap: null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ),
      ],
    ) 
    
    /*Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(40),
          child: Center(
            child: AppTitle("Secure","Note"),
          ),
        ),

        Form(
          key: _formKey ,
          child: Column(
            children: <Widget>[


              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: "Email"
                  ),
                  validator: (string){
                    if(!string.contains("@")) return "Check your Email";
                    return null;
                  },
                )
              ),

              SizedBox(height: 10),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(50))
                ),
                child: TextFormField(
                  enableSuggestions: false,
                  controller: _pass,
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  decoration: InputDecoration.collapsed(

                    hintText: "Password"
                  ),
                  validator: (string){
                    if(string.isEmpty) return "Password can't be empty";
                    return null;
                  },
                )
              ),

              SizedBox(height: 20),

              GestureDetector(
                child: Container(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: whitetheme.accentColor.withGreen(150),
                    border: Border.all(),
                    borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(child: Text("Login"))
                ),
                onTap: (){
                  if(!login && _formKey.currentState.validate()){
                    autenticate(_email.text, _pass.text, context);
                    login = true;
                  }
                },
              ),

            ],
          ),
        )
      ]
      )*/
        ),
      );
  }

  Future<void>autenticate(email, password, context)async{
    AuthResult result;
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      print("Email: "+email);
      print("Password: "+password);

      result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      Toast.show("Login Success!", context);
      mainUser = result.user; 
      login = true;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
    } catch (e) {
      login = false;
      print(e.message);
      Toast.show(e.message, context,duration: 3);
    }
  }
}