// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, duplicate_ignore, sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print

import 'package:ecommerce_app/screen/constants.dart';
import 'package:ecommerce_app/screen/register_page.dart';
import 'package:ecommerce_app/widgets/custom_btn.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              ElevatedButton(
                child: Text("Close Dialog"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    // Set the form to loading state
    setState(() {
      _loginFormLoading = true;
    });

    // Run the create account method
    String _loginFeedback = await _loginAccount();

    // If the string is not null, we got error while create account.
    if (_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      // Set the form to regular state [not loading].
      setState(() {
        _loginFormLoading = false;
      });
    }
  }

  bool _loginFormLoading = false;

  // Form Input Field Values
  String _loginEmail = "";
  String _loginPassword = "";

  // Focus Node for input fields
  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        // ignore: avoid_unnecessary_containers
        body: SafeArea(
            child: Container(
          width: double.infinity,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Welcome User, \n Login to your account',
                      textAlign: TextAlign.center,
                      style: Constants.boldHeading),
                ),
              ),
              Column(
                children: [
                  CustomInput(
                    hinttext: 'Email',
                    onChanged: (value) {
                      _loginEmail = value;
                    },
                    onSubmitted: (value) {
                      _passwordFocusNode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  CustomInput(
                    hinttext: 'Password',
                    onChanged: (value) {
                      _loginPassword = value;
                    },
                    focusNode: _passwordFocusNode,
                    isPasswordField: true,
                    onSubmitted: (value) {
                      _submitForm();
                    },
                  ),
                  CustomBtn(
                    text: 'Login',
                    onpressed: () {
                      _submitForm();
                    },
                    isLoading: _loginFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24,
                ),
                child: CustomBtn(
                  text: 'Create New Account',
                  onpressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  outlineBtn: true,
                ),
              )
            ],
          ),
        )));
  }
}
