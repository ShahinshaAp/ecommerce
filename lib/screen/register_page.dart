// ignore_for_file: avoid_print, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:ecommerce_app/widgets/custom_btn.dart';
import 'package:ecommerce_app/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Container(
              child: Text(error),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close'))
            ],
          );
        });
  }

  Future<String> _createAccount() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _registerEmail, password: _registerPassword);
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

  void submitForm() async {
    setState(() {
      _registerFormLoading = true;
    });
    String _createAccountFeedBack = await _createAccount();
    if (_createAccountFeedBack != null) {
      _alertDialogBuilder(_createAccountFeedBack);
      setState(() {
        _registerFormLoading = false;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _registerFormLoading = false;
  String _registerEmail = "";
  String _registerPassword = "";

  FocusNode _passwordFocusnode;

  @override
  void initState() {
    super.initState();
    _passwordFocusnode = FocusNode();
    print('initstate');
  }

  @override
  void dispose() {
    _passwordFocusnode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          width: double.infinity,
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 22),
                  child: Text('Create A New Account',
                      textAlign: TextAlign.center,
                      style: Constants.boldHeading),
                ),
              ),
              Column(
                children: [
                  CustomInput(
                      hinttext: 'Email',
                      onChanged: (value) {
                        _registerEmail = value;
                      },
                      onSubmitted: (value) {
                        _passwordFocusnode.requestFocus();
                      },
                      textInputAction: TextInputAction.next),
                  CustomInput(
                      hinttext: 'Password',
                      onChanged: (value) {
                        _registerPassword = value;
                      },
                      onSubmitted: (value) {
                        submitForm();
                      },
                      focusNode: _passwordFocusnode,
                      isPasswordField: true),
                  CustomBtn(
                    text: 'Sign Up',
                    onpressed: () {
                      submitForm();
                    },
                    isLoading: _registerFormLoading,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                ),
                child: CustomBtn(
                  text: 'Back To Login',
                  onpressed: () {
                    Navigator.of(context).pop();
                  },
                  outlineBtn: true,
                ),
              )
            ],
          ),
        )));
  }
}
