import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
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
        
      } on PlatformException catch (e) {print(e);}
      return result;
  }

  Future<bool> biometricAuth()async{
    return await _auth.authenticateWithBiometrics(
      localizedReason: "Sblocca per accedere alla nota", 
      useErrorDialogs: false);
  }

}