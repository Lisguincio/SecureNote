import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pattern_lock/pattern_lock.dart';
import 'package:flutter/services.dart';
import 'package:securenote/view/settings.dart';

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
          //return await biometricAuth();
          return await patternAuth();
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
    bool result;
    await showDialog<bool>(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Inserire Pattern"),
          content: LimitedBox(
            maxHeight: 50,
            child: PatternLock(
              onInputComplete: (string){
                //Se il codice è corretto
                Navigator.pop(context);
                result = true;
              }
            )
          ),
        );
    });
    return result;
  }

 }