import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/services/menu.dart';
import 'dart:convert';
import 'package:tarbiyat/pages/login.dart';

class Accounts extends StatefulWidget {
  final Map udata;
  Accounts(this.udata);
  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  Map udata = {};

  // //check login
  // _checkloc() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String itsid = prefs.getString('itsid') ?? '0';
  //   if (itsid != '0') {
  //     udata = jsonDecode(itsid);
  //     // print(udata['itsid']);
  //   } else {
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  //get all ids
  List itsidsl = [];
  Future<void> _getitsids() async {
    String itsids = '[';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    itsids += prefs.containsKey('itsid')
        ? prefs.getString('itsid')! + ','
        : '{"itsid":"0","fullname":"Empty"},';
    itsids += prefs.containsKey('itsid2') || prefs.getString('itsid2') == '0'
        ? prefs.getString('itsid2')! + ','
        : '{"itsid":"0","fullname":"Empty"},';
    itsids += prefs.containsKey('itsid3') || prefs.getString('itsid3') == '0'
        ? prefs.getString('itsid3')! + ','
        : '{"itsid":"0","fullname":"Empty"},';
    itsids += prefs.containsKey('itsid4') || prefs.getString('itsid4') == '0'
        ? prefs.getString('itsid4')! + ','
        : '{"itsid":"0","fullname":"Empty"},';
    itsids += prefs.containsKey('itsid5') || prefs.getString('itsid5') == '0'
        ? prefs.getString('itsid5')! + ','
        : '{"itsid":"0","fullname":"Empty"},';
    itsids = itsids.substring(0, itsids.length - 1);
    itsids += ']';
    print(itsids);
    itsidsl = jsonDecode(itsids);
  }

  _getloc(itsid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    String itsid5 = prefs.getString('itsid5') ?? '0';
    String itsid4 = prefs.getString('itsid4') ?? '0';
    String itsid3 = prefs.getString('itsid3') ?? '0';
    String itsid2 = prefs.getString('itsid2') ?? '0';
    String itsid1 = prefs.getString('itsid') ?? '0';
    Map mitsid5 = itsid5 != '0' ? jsonDecode(itsid5) : {"itsid": "0"};
    Map mitsid4 = itsid4 != '0' ? jsonDecode(itsid4) : {"itsid": "0"};
    Map mitsid3 = itsid3 != '0' ? jsonDecode(itsid3) : {"itsid": "0"};
    Map mitsid2 = itsid2 != '0' ? jsonDecode(itsid2) : {"itsid": "0"};
    Map mitsid1 = itsid1 != '0' ? jsonDecode(itsid1) : {"itsid": "0"};
    String itsidloc = itsid1;
    if (itsid == mitsid5['itsid'] ||
        itsid == mitsid4['itsid'] ||
        itsid == mitsid3['itsid'] ||
        itsid == mitsid2['itsid'] ||
        itsid == mitsid1['itsid']) {
      if (itsid == mitsid5['itsid']) {
        itsidloc = itsid5;
        prefs.setString('itsid', itsidloc);
        prefs.setString('itsid5', itsid1);
        prefs.reload();
      }
      if (itsid == mitsid4['itsid']) {
        itsidloc = itsid4;
        prefs.setString('itsid', itsidloc);
        prefs.setString('itsid4', itsid1);
        prefs.reload();
      }
      if (itsid == mitsid3['itsid']) {
        itsidloc = itsid3;
        prefs.setString('itsid', itsidloc);
        prefs.setString('itsid3', itsid1);
        prefs.reload();
      }
      if (itsid == mitsid2['itsid']) {
        itsidloc = itsid2;
        prefs.setString('itsid', itsidloc);
        prefs.setString('itsid2', itsid1);
        prefs.reload();
      }
      udata = jsonDecode(itsidloc);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Success"),
          content: Text("Account switched"),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Accounts(udata)));
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.udata['itsid'] == 0) {
      Future(() {
        Navigator.popAndPushNamed(context, '/login');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String itsid = widget.udata['itsid'];
    _getitsids();

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Accounts'),
        centerTitle: true,
      ),
      drawer: NavDrawer(widget.udata),
      body: ListView(
        children: [
          for (var i in itsidsl)
            Card(
              margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(i['itsid'],
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.grey[600])),
                  ]),
            )
        ],
      ),
    );
  }
}
