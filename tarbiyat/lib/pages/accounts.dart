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

  String _getnetimage(its) {
    if (its != '0') {
      return 'https://idaramsb.net/assets/img/itsphoto.php?itsid=$its';
    } else {
      return 'http://innovacos.com/wp-content/uploads/2017/01/profile-silhouette-300x300.jpg';
    }
  }

  void _remloc(getlocno) async {
    _getloc(getlocno);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String itsid5 = prefs.getString('itsid5') ?? '0';
    String itsid4 = prefs.getString('itsid4') ?? '0';
    String itsid3 = prefs.getString('itsid3') ?? '0';
    String itsid2 = prefs.getString('itsid2') ?? '0';

    prefs.remove('itsid');
    prefs.reload();
    if (itsid2 != '0') {
      prefs.setString('itsid', itsid2);
      udata = jsonDecode(itsid2);
      prefs.remove('itsid2');
    }
    if (itsid3 != '0') {
      prefs.setString('itsid2', itsid3);
      prefs.remove('itsid3');
    }
    if (itsid4 != '0') {
      prefs.setString('itsid3', itsid4);
      prefs.remove('itsid4');
    }
    if (itsid5 != '0') {
      prefs.setString('itsid4', itsid5);
      prefs.remove('itsid5');
    }
    prefs.reload();

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Accounts(udata)));
  }

  //get all ids
  List itsidsl = [];
  _getitsids() async {
    String itsids = '[';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
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
    setState(() {});
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
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    _getitsids();
    String itsid = widget.udata['itsid'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Accounts'),
        centerTitle: true,
      ),
      drawer: NavDrawer(widget.udata),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/login');
          },
          child: Icon(Icons.add)),
      body: ListView(
        children: [
          for (var i in itsidsl)
            i['itsid'] == '0'
                ? SizedBox(height: 10.0)
                : Card(
                    margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            child: ClipOval(
                                child: Image.network(_getnetimage(i['itsid']))),
                            radius: 50.0,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(i['fullname'],
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.grey[600])),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      i['itsid'] == itsid
                                          ? SizedBox(width: 10.0)
                                          : ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _getloc(i['itsid']);
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text('Switch',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'KanzalMarjaan',
                                                        fontSize: 20.0,
                                                        color: Colors.white)),
                                              )),
                                      i['itsid'] == itsid
                                          ? SizedBox(width: 10.0)
                                          : ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _remloc(i['itsid']);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.redAccent),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Text('Remove',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'KanzalMarjaan',
                                                        fontSize: 20.0,
                                                        color: Colors.white)),
                                              )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                  )
        ],
      ),
    );
  }
}
