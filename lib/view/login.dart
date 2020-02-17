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

  bool login = false; //Variabile per evitare che il doppio TAP su Login effettui due volte il login

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whitetheme.accentColor,
        body: SafeArea(
    child: Column(
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
      )
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