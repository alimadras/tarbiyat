import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/services/menu.dart';
import 'dart:convert';

class accounts extends StatefulWidget {
  const accounts({Key? key}) : super(key: key);

  @override
  _accountsState createState() => _accountsState();
}

class _accountsState extends State<accounts> {
  Map udata = {};

  //check login
  Future<void> _checkloc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itsid = prefs.getString('itsid') ?? '0';
    if (itsid != '0') {
      udata = jsonDecode(itsid);
      print(udata['itsid']);
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  //get all ids
  Map itsidsl = {};
  Future<void> _getitsids() async {
    String itsids = '[';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itsids += prefs.containsKey('itsid') ? prefs.getString('itsid')! + ',' : '';
    itsids +=
        prefs.containsKey('itsid2') ? prefs.getString('itsid2')! + ',' : '';
    itsids +=
        prefs.containsKey('itsid3') ? prefs.getString('itsid3')! + ',' : '';
    itsids +=
        prefs.containsKey('itsid4') ? prefs.getString('itsid4')! + ',' : '';
    itsids +=
        prefs.containsKey('itsid5') ? prefs.getString('itsid5')! + ',' : '';
    itsids += ']';
    itsidsl = jsonDecode(itsids);
  }

  @override
  Widget build(BuildContext context) {
    _checkloc();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Accounts'),
        centerTitle: true,
      ),
      drawer: NavDrawer(),
      body: ListView(
        children: [
          for (var i in itsidsl.keys)
            Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(itsidsl[i].itsid,
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.grey[600])),
                  ]),
            )
        ],
      ),
    );
  }
}
