import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/services/authservice.dart';
import 'package:health/src/pages/home_page.dart';
import 'package:health/startpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sign_in extends StatefulWidget {
  @override
  _sign_inState createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  bool isAuth = false;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      handleSignIn(account);
    });
    googleSignIn
        .signInSilently(suppressErrors: false) //signing in automatically
        .then((account) async {
      handleSignIn(account);
    }).catchError((err) {});
  }

  handleSignIn(GoogleSignInAccount? account) {
    if (account != null) {
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  buildUnauthScreen() {
    return Scaffold(  backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary,
            ])),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 225, bottom: 225, left: 35, right: 35),
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 40),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Pocket',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: 'Doc',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue.shade400)),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/google_signin_button.png',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
    AuthService().signout(context);
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? HomePage() : StartScreen();
  }
}