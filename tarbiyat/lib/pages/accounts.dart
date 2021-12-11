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
      prefs.setString('itsid1', itsid2);
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
  }

  //get all ids
  List itsidsl = [];
  _getitsids() async {
    String itsids = '[';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    itsids += prefs.containsKey('itsid1')
        ? prefs.getString('itsid1')! + ','
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
    List<String> itsidlist = [];
    String itsidliststring = '[';
    itsidlist
        .add(prefs.getString('itsid1') ?? '{"itsid":"0","fullname":"Empty"}');
    itsidlist
        .add(prefs.getString('itsid2') ?? '{"itsid":"0","fullname":"Empty"}');
    itsidlist
        .add(prefs.getString('itsid3') ?? '{"itsid":"0","fullname":"Empty"}');
    itsidlist
        .add(prefs.getString('itsid4') ?? '{"itsid":"0","fullname":"Empty"}');
    itsidlist
        .add(prefs.getString('itsid5') ?? '{"itsid":"0","fullname":"Empty"}');

    for (int i = 0; i < itsidlist.length; i++) {
      Map itsdet = jsonDecode(itsidlist[i]);
      String itstemp = '';
      int j = i + 1;
      if (itsid == itsdet['itsid']) {
        itstemp = itsidlist[0];
        itsidlist[0] = itsidlist[i];
        itsidlist[i] = itstemp;
        prefs.setString('itsid1', itsidlist[0]);
        prefs.setString('itsid' + j.toString(), itsidlist[i]);
      }
    }
    for (var k = 0; k < itsidlist.length; k++) {
      itsidliststring += itsidlist[k] + ',';
    }
    itsidliststring = itsidliststring.substring(0, itsidliststring.length - 1);
    itsidliststring += ']';

    udata = jsonDecode(itsidlist[0]);
    itsidsl = jsonDecode(itsidliststring);
    // return showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: Text("Success"),
    //     content: Text("Account switched"),
    //     actions: <Widget>[
    //       ElevatedButton(
    //         onPressed: () {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Accounts(udata)));
    //         },
    //         child: Text("OK"),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    if (widget.udata['itsid'] == '0') {
      Future(() {
        Navigator.popAndPushNamed(context, '/login');
      });
    } else {
      _getitsids();
    }
  }

  @override
  Widget build(BuildContext context) {
    String itsid = widget.udata['itsid'];
    if (itsidsl.length == 0) {
      _getitsids();
    }
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
