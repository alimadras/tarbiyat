import 'package:flutter/material.dart';
import 'package:tarbiyat/pages/home.dart';
import 'package:tarbiyat/pages/login.dart';
import 'package:tarbiyat/pages/accounts.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/login': (context) => Login(),
      '/accounts': (context) => accounts(),
    },
  ));
}
