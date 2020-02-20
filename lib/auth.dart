import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:flutter/services.dart';
import 'package:securenote/view/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

List<BiometricType> btype = new List();

class LocalAuthenticationService {
  var context;
  LocalAuthenticationService(this.context);

 final _auth = LocalAuthentication();

 void loadtypes(){
    _auth.getAvailableBiometrics().then((l){btype = l;});
 }

  Future<bool> authenticate() async {
      bool result;
      try {
        if(passKey == "fingerprint"){
          return await biometricAuth();
        }
        else
          return await patternAuth();
        
      } on PlatformException catch (e) {print(e);}
      return result;
  }

  Future<bool> biometricAuth()async{
    return await _auth.authenticateWithBiometrics(
      localizedReason: "Sblocca per accedere alla nota", 
      useErrorDialogs: false);
  }

  Future<bool>patternAuth()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String string = preferences.getString("pattern");
    bool result;
    await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Inserire Pattern"),
          content: LimitedBox(
            maxHeight: 50,
            child: PatternLock(
              onInputComplete: (s){
                if(s.toString() == string){
                  result = true;
                  Toast.show("Pattern Corretto!", context);
                }
                else{
                  result = false;
                  Toast.show("Pattern Errato!", context);
                }
                Navigator.pop(context);
                
              }
            )
          ),
        );
    });
    return result;
  }

 }