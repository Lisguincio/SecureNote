import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:google_sign_in/google_sign_in.dart';
import 'package:securenote/model/title.dart';
import 'package:securenote/model/user.dart';
import 'package:securenote/view/passwordRestore.dart';
import 'package:securenote/view/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool login =
      false; //Variabile per evitare che il doppio TAP su Login effettui due volte il login
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    rememberEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitetheme.accentColor,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(flex: 1, child: Center(child: AppTitle("Secure", "Note"))),
          Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  color: whitetheme.backgroundColor,
                ),
                padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
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
                        validator: (string) {
                          if (!string.contains("@")) return "Check your Email";
                          return null;
                        },
                      ),

                      //Password
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_obscure,
                        controller: _pass,
                        style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.w100
                        ),
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: !_obscure ? Colors.grey : Colors.blue,
                              ),
                              onPressed: () => setState(() {
                                    _obscure = !_obscure;
                                  })),
                          border: UnderlineInputBorder(),
                        ),
                        validator: (string) {
                          if (string.length < 8) return "Check your Password";
                          return null;
                        },
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              "Entra",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40),
                              textAlign: TextAlign.center,
                            )),
                            FloatingActionButton(
                                backgroundColor: whitetheme.accentColor,
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  if (!login &&
                                      _formKey.currentState.validate()) {
                                    autenticate(
                                        _email.text, _pass.text, context);
                                    login = true;
                                  }
                                }),
                          ]),
                      OutlinedButton(
                          onPressed: () =>
                              Toast.show("Ancora non implementato", context),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          )),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: Text("Registrati",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register())),
                          ),
                          GestureDetector(
                            child: Text("Password\nDimenticata",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                                textAlign: TextAlign.end),
                            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordRestore())),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      )),
    );
  }

  Future<void> googleAutenticate() async {
    /* GoogleSignIn googleSignIn = new GoogleSignIn();
    GoogleSignInAccount signInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await signInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.idToken, 
      accessToken: googleSignInAuthentication.accessToken);
    AuthResult result = await FirebaseAuth.instance.signInWithCredential(credential); */
  }

  Future<void> autenticate(email, password, context) async {
    UserCredential result;
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      print("Email: " + email);
      print("Password: " + password);

      result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Toast.show("Login Success!", context);
      if (result.user.emailVerified) {
        mainUser = result.user;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("rememberEmail", _email.text);
      } else
        throw Exception("This account isn't active, check your email inbox!");
      login = true;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    } catch (e) {
      FirebaseAuth.instance.signOut();
      login = false;
      print(e.message);
      Toast.show(e.message, context, duration: 3);
    }
  }

  void rememberEmail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey("rememberEmail"))
      _email.text = preferences.get("rememberEmail");
  }
}
