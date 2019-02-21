import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleAuth = new GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton.icon(
          icon: Icon(FontAwesomeIcons.google),
          label: Text("Continue With Google"),
          textColor: Colors.white,
          elevation: 2.0,
          key: ValueKey("Google"),
          onPressed: () {
            googleAuth.signIn().then((result) {
              result.authentication.then((googleKey) {
                FirebaseAuth.instance
                    .signInWithGoogle(
                      idToken: googleKey.idToken,
                        accessToken: googleKey.accessToken)
                    .then((signedInUser) {
                  print('Signed in as ${signedInUser.displayName}');
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                }).catchError((e) {
                  print(e);
                });
              }).catchError((e) {
                print(e);
              });
            }).catchError((e) {
              print(e);
            });
          },
          color: Color(0xFFDD4B39),
        ),
      ),
    );
  }
}