import 'package:flutter/material.dart';
import 'package:tarbiyat/pages/home.dart';
import 'package:tarbiyat/pages/login.dart';
import 'package:tarbiyat/pages/accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('resource://drawable/idara_logo', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      defaultColor: Colors.blueAccent,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    ),
    NotificationChannel(
      channelKey: 'scheduled_channel',
      channelName: 'Scheduled Notifications',
      defaultColor: Colors.blueAccent,
      importance: NotificationImportance.High,
      locked: true,
    ),
  ]);
  Map udata = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String getcurrentuser = prefs.getString('itsid1') ?? '0';
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
