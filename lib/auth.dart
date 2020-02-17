import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';


class LocalAuthenticationService {
 final _auth = LocalAuthentication();

 static List<BiometricType> btype = new List();

 void loadtypes(){
    _auth.getAvailableBiometrics().then((l){btype = l;});
 }

  Future<bool> authenticate() async {
      bool result;
      try {
        result = await _auth.authenticateWithBiometrics(
          localizedReason: 'Sblocca per accedere alla nota',
          useErrorDialogs: false
        );
      } on PlatformException catch (e) {print(e);}
      return result;
  }
 }

 var auth = new LocalAuthenticationService();