import 'package:firebase_auth_flutter/services/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_flutter/authenticate/auth_login_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    // print(user);
    return (user == null)
        ? Login()
        : Home(); // insteading of calling home here use Future.delayed or builder
  }
}
