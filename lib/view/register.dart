import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/theme.dart';
import 'package:securenote/view/login.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

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
        Expanded(child: Center(child: AppTitle("Secure","Note"))),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //mainAxisSize: MainAxisSize.max,
                children: <Widget>[

                  TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    controller: _username,
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.w100
                    ),
                    decoration: InputDecoration(
                      hintText: "Username",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (string){
                      if(string.isEmpty && string.contains(" ")) return "Check your Username";
                      return null;
                    },
                  ),
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

                  //Password
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _password,
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.w100
                    ),
                    decoration: InputDecoration(
                      hintText: "Password",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (string){
                      if(string.length < 8) return "Check your Password";
                      return null;
                    },
                  ),

                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _confirm,
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.w100
                    ),
                    decoration: InputDecoration(
                      hintText: "Conferma Password",
                      border: UnderlineInputBorder(),
                    ),
                    validator: (string){
                      if(string != _password.text) return "Password don't match";
                      return null;
                    },
                  ),
                  //Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: Text("Registrati", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40), textAlign: TextAlign.center,)),
                      FloatingActionButton(
                        backgroundColor: whitetheme.accentColor,
                        child: Icon(Icons.arrow_forward, size: 40, color: Colors.black,),
                        onPressed: (){
                          if(!regist && _formKey.currentState.validate()){
                            register(_username.text, _email.text, _password.text, context);
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

  Future<void>register(username, email, password, context)async{
    FirebaseUser user;
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      print("Username" + username);
      print("Email: "+email);
      print("Password: "+password);

      FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((r){user = r.user; user.sendEmailVerification();});
      Toast.show("Check your mail inbox!", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
    } catch (e) {
      print(e.message);
      Toast.show(e.message, context,duration: 3);
      regist = false;
    }
  }
}