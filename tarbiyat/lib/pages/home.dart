import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:tarbiyat/services/dactions.dart';
import 'package:tarbiyat/services/dactions_card.dart';
import 'package:tarbiyat/services/menu.dart';
import 'package:tarbiyat/services/local_notification.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tarbiyat/pages/accounts.dart';
import 'package:tarbiyat/models/dbhelper.dart';
import 'package:tarbiyat/services/utlities.dart';

class Home extends StatefulWidget {
  final Map udata;
  Home(this.udata);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool hasInternet = false;
  //get quran data
  Future<void> getQuran() async {
    DateTime now = DateTime.now();
    String today = DateFormat('d/M/y').format(now);
    String monthstart = '01/' + DateFormat('M/y').format(now);
    String itsid = widget.udata['itsid'];
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet) {
      var url = Uri.parse(
          'http://139.59.31.87/horizons/quranjson.php?itsID=$itsid&from=$monthstart&to=$today');
      Response response = await get(url);

      Map data =
          jsonDecode(response.body.replaceAll('[', '').replaceAll(']', ''));
      print(data['result']);
    } else {
      print('No Internet');
    }
  }

  List<Daction> tactions = [];

  _getroutine() async {
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
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('Allow Notifications'),
                    content:
                        Text('Our app would like to send you notifications'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            AwesomeNotifications()
                                .requestPermissionToSendNotifications()
                                .then((_) => Navigator.pop(context));
                          },
                          child: Text('Allow',
                              style: TextStyle(color: Colors.blueAccent))),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Don\'t Allow',
                              style: TextStyle(color: Colors.grey)))
                    ]));
      }
    });
    AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Notification created on ${notification.channelKey}')));
    });
    AwesomeNotifications().actionStream.listen((notification) {
      if (notification.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => Accounts(widget.udata)),
          (route) => route.isFirst);
    });
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
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String itsid = widget.udata['itsid'];
    getQuran();
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
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        cancelSched();
                      },
                      child: Text('Cancel')),
                  color: Colors.amber,
                  padding: EdgeInsets.all(20.0)),
              Container(
                  child: ElevatedButton(
                      onPressed: () {
                        createNot();
                      },
                      child: Text('Notify')),
                  color: Colors.pinkAccent,
                  padding: EdgeInsets.all(20.0)),
              Container(
                  child: ElevatedButton(
                      onPressed: () async {
                        NotificationWeekAndTime? pickedSchedule =
                            await pickSchedule(context);

                        if (pickedSchedule != null) {
                          createSched(pickedSchedule);
                        }
                      },
                      child: Text('Schedule')),
                  color: Colors.grey,
                  padding: EdgeInsets.all(20.0)),
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
                    btnstring is String
                        ? actions[j] = Daction(
                            id: i.id,
                            text: i.text,
                            buttons: 'Change,$btnstring')
                        : actions[j] = tactions[m];
                  });
                }),
        ],
      ),
    );
  }
}
