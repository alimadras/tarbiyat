import 'package:flutter/material.dart';
import 'package:tarbiyat/services/dactions.dart';
import 'package:tarbiyat/services/dactions_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/services/menu.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tarbiyat/pages/login.dart';
import 'package:tarbiyat/models/dbhelper.dart';
import 'package:tarbiyat/services/local_notification.dart';

class Home extends StatefulWidget {
  final Map udata;
  Home(this.udata);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //get quran data
  Future<void> getQuran() async {
    DateTime now = DateTime.now();
    String today = DateFormat('d/M/y').format(now);
    String monthstart = '01/' + DateFormat('M/y').format(now);
    String itsid = widget.udata['itsid'];
    var url = Uri.parse(
        'http://139.59.31.87/horizons/quranjson.php?itsID=$itsid&from=$monthstart&to=$today');
    Response response = await get(url);

    Map data =
        jsonDecode(response.body.replaceAll('[', '').replaceAll(']', ''));
    print(data['result']);
  }

  List<Daction> tactions = [];

  _getroutine() async {
    // actions = [];
    // int insertest = await DBHelper.instance.insert(
    //     {'cdate': '2021-12-08', 'title': '', 'buttons': '', 'status': 1});
    // print(insertest);
    List<Map<String, dynamic>> routine =
        await DBHelper.instance.queryAll('routine');
    print(routine);
    List<Map> answers = await DBHelper.instance.queryRaw(
        "SELECT * from answers where status = 1 and date(adatetime) = date('now') and its = ?",
        [widget.udata['itsid']]);
    print(answers);
    for (var i = 0; i < routine.length; i++) {
      int cr = 1;
      String answer = '';
      for (var j = 0; j < answers.length; j++) {
        if (answers[j]['rid'] == routine[i]['id']) {
          cr = 0;
          answer = answers[j]['buttons'];
        }
      }
      tactions.add(Daction(
          id: routine[i]['id'],
          text: routine[i]['title'],
          buttons: routine[i]['buttons']));
      if (cr == 1) {
        actions.add(Daction(
            id: routine[i]['id'],
            text: routine[i]['title'],
            buttons: routine[i]['buttons']));
      } else {
        actions.add(Daction(
            id: routine[i]['id'],
            text: routine[i]['title'],
            buttons: "Change," + answer));
      }
    }
    setState(() {});
  }

  List<Daction> actions = [];

  // [

  //   Daction(text: 'Fajr Namaz', buttons: 'امامة,اداء,قضاء,No'),
  //   Daction(text: 'Siwaak', buttons: 'No,Yes'),
  //   Daction(text: 'Gusul/Nazafat', buttons: 'Yes,No'),
  //   Daction(text: 'Waledain Salaam', buttons: 'Yes,No'),
  //   Daction(text: 'Tilawat al Quran', buttons: 'Yes,No'),
  //   Daction(text: 'Zohr Asr Namaz', buttons: 'امامة,اداء,قضاء,No'),
  //   Daction(text: 'Homework', buttons: 'Yes,No'),
  //   Daction(text: 'Maghrib Isha Namaz', buttons: 'امامة,اداء,قضاء,No'),
  //   Daction(text: 'Wazifatul Layl', buttons: 'Yes,No'),
  //   Daction(text: 'Siwaak', buttons: 'Yes,No')
  // ];

  @override
  void initState() {
    super.initState();
    if (widget.udata['itsid'] == '0') {
      Future(() {
        Navigator.popAndPushNamed(context, '/login');
      });
    } else {
      setState(() {
        _getroutine();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String itsid = widget.udata['itsid'];

    return Scaffold(
      appBar: AppBar(
        title: Text('iMSB for Students'),
        centerTitle: true,
      ),
      drawer: NavDrawer(widget.udata),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                  child: Container(
                      child: itsid == '0'
                          ? SizedBox(width: 10.0)
                          : Image.network(
                              'https://idaramsb.net/assets/img/itsphoto.php?itsid=$itsid'),
                      color: Colors.amber,
                      padding: EdgeInsets.all(5.0))),
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        NotificationApi.showNotification(
                            title: 'Sarah Abs',
                            body: 'Hey there wachha doing?',
                            payload: 'sarab.abs');
                      },
                      child: Text('Notify')),
                  color: Colors.pinkAccent,
                  padding: EdgeInsets.all(20.0)),
              Container(color: Colors.grey, padding: EdgeInsets.all(20.0)),
            ],
          ),
          for (var i in actions)
            ActionCard(
                action: i,
                itsid: itsid,
                change: (btnstring) {
                  var m = 0;
                  for (var l = 0; l < tactions.length; l++) {
                    if (i.id == tactions[l].id) {
                      m = l;
                      print('it got here?');
                    }
                  }
                  print(m);
                  setState(() {
                    var j = actions.indexOf(i);
                    // actions.remove(i);
                    btnstring is String
                        ? actions[j] = Daction(
                            id: i.id,
                            text: i.text,
                            buttons: 'Change,$btnstring')
                        : actions[j] = tactions[m];
                    //actions = [];
                    //_getroutine();
                  });
                }),
        ],
      ),
    );
  }
}
