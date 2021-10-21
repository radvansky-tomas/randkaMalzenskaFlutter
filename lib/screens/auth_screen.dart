import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:randka_malzenska/models/preferences_key.dart';
import 'package:randka_malzenska/providers/auth.dart';
import 'package:randka_malzenska/screens/registration/registry_marriage_status_screen.dart';
import 'package:randka_malzenska/screens/step/step_course_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: AuthCard(),
            ),
          ),
        ));
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  late StreamSubscription<User?> loginStateSubscription;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    var authBloc = Provider.of<Auth>(context, listen: false);

    loginStateSubscription = authBloc.currentUser.listen((user) {
      if (user != null) {
        _initializePreferences().whenComplete(() {
          String userRelationshipStatus = prefs.getString(
                  user.uid + PreferencesKey.userRelationshipStatus) ??
              '';

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => userRelationshipStatus == ''
                  ? RegistryStatusScreen(user)
                  : StepCourseScreen(user)));
        });
      }
    });
  }

  _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    loginStateSubscription.cancel();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
          backgroundColor: Colors.grey[100],
          title: Text('Wystąpił błąd!',
              style: TextStyle(
                color: Colors.black,
              )),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 21, 74, 118))),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OK',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            )
          ]),
    );
  }

  Future<void> _loginFace() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .loginFacebook(context: context);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loginGoogle() async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .signInWithGoogle(context: context);
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email']!, _authData['password']!);
        // Log user in
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email']!, _authData['password']!);
        // Sign user up
      }
    } catch (error) {
      var errorMessage = 'Autoryzacja nie powiodła się';
      if (error.toString().contains('user-not-found')) {
        errorMessage = 'Nie ma użytkownika z takim emailem';
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'Niepoprawne hasło';
      } else if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'Email jest już wykorzystywany';
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'Hasło jest za słabe';
      }
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Randka małżeńska',
              style: TextStyle(color: Colors.white, fontSize: 19),
            ),
            SizedBox(
              height: 50.0,
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'email',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54)),
                focusColor: Colors.white,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Nieprawidłowy email!';
                }
                return null;
              },
              onSaved: (value) {
                _authData['email'] = value!;
              },
            ),
            TextFormField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'hasło',
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54)),
                focusColor: Colors.white,
              ),
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value!.isEmpty || value.length < 5) {
                  return 'Hasło jest za krótkie!';
                }
              },
              onSaved: (value) {
                _authData['password'] = value!;
              },
            ),
            if (_authMode == AuthMode.Signup)
              TextFormField(
                style: TextStyle(color: Colors.white),
                enabled: _authMode == AuthMode.Signup,
                decoration: InputDecoration(
                  labelText: 'potwierdź hasło',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54)),
                  focusColor: Colors.white,
                ),
                obscureText: true,
                validator: _authMode == AuthMode.Signup
                    ? (value) {
                        if (value != _passwordController.text) {
                          return 'Hasła nie są jednakowe!';
                        }
                      }
                    : null,
              ),
            SizedBox(
              height: 20.0,
            ),
            OutlinedButton(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _authMode == AuthMode.Login ? 'Zaloguj' : 'Zarejestruj się',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2, color: Colors.white),
              ),
              onPressed: _submit,
            ),
            TextButton(
              child: Text(
                '${_authMode == AuthMode.Login ? 'Zarejestruj się' : 'Zaloguj'}',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: _switchAuthMode,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: Image.asset('assets/images/FacebookLogo.png'),
                  iconSize: 50,
                  onPressed: _loginFace,
                ),
                IconButton(
                  icon: Image.asset('assets/images/GoogleLogo.png'),
                  iconSize: 50,
                  onPressed: _loginGoogle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() => Container(
        color: Colors.grey,
        height: 1.5,
        width: 55,
      );
  Widget heightSpacer(double myHeight) => SizedBox(height: myHeight);

  Widget widthSpacer(double myWidth) => SizedBox(width: myWidth);
}
