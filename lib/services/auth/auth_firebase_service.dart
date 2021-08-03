import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  Stream<User?> get currentUser => _auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
          String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signUpWithEmailAndPassword(
          String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  Future<UserCredential> signInWithCrendetail(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future<void> logout() => _auth.signOut();
}
