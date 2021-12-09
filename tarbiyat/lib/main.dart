import 'package:flutter/material.dart';
import 'package:tarbiyat/pages/home.dart';
import 'package:tarbiyat/pages/login.dart';
import 'package:tarbiyat/pages/accounts.dart';
import 'package:tarbiyat/services/local_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map udata = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getcurrentuser = prefs.getString('itsid') ?? '0';
  if (getcurrentuser == '0') {
    udata = {"itsid": "0"};
  } else {
    udata = jsonDecode(getcurrentuser);
  }
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(udata),
      '/login': (context) => Login(),
      '/accounts': (context) => Accounts(udata),
    },
  ));
}
