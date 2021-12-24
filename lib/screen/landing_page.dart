import 'package:ecommerce_app/screen/home_page.dart';
import 'package:ecommerce_app/screen/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key key}) : super(key: key);
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error} '),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, streamsnapshot) {
                  if (streamsnapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: ${streamsnapshot.error} '),
                      ),
                    );
                  }

                  if (streamsnapshot.connectionState ==
                      ConnectionState.active) {
                    User _user = streamsnapshot.data;

                    if (_user == null) {
                      return const LoginPage();
                    } else {
                      return const HomePage();
                    }
                  }

                  return const Scaffold(
                    body: Center(
                      child: Text(' checking Authentication '),
                    ),
                  );
                }
                );
          }
          return const Scaffold(
            body: Center(
              child: Text(' processing '),
            ),
          );
        }
        );
  }
}
