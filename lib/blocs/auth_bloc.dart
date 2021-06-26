import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:randka_malzenska/services/auth_firebase_service.dart';

class AuthBloc {
  final authService = AuthService();
  final fb = FacebookLogin();

  Stream<User?> get currentUser => authService.currentUser;

  loginFacebook() async {
    print('Starting Facebook login');
    final res = await fb.logIn(
      permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ],
    );

    switch (res.status) {
      case FacebookLoginStatus.success:
        //get token
        final FacebookAccessToken? fbToken = res.accessToken;
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken!.token);
        //User credential to sing in with firebase
        final result = await authService.signInWithCrendetail(credential);
        print('${result.user!.displayName} is now logged in');
        break;
      case FacebookLoginStatus.cancel:
        print('uzytkownik wycofal login');
        break;
      case FacebookLoginStatus.error:
        print('${res.error}error achtung');
        break;
    }
  }

  logout() {
    authService.logout();
  }
}
