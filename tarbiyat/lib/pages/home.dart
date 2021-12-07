import 'package:flutter/material.dart';
import 'package:tarbiyat/services/dactions.dart';
import 'package:tarbiyat/services/dactions_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/services/menu.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:tarbiyat/pages/login.dart';

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

  List<Daction> actions = [
    Daction(text: 'Fajr Namaz', buttons: 'امامة,اداء,قضاء,No'),
    Daction(text: 'Siwaak', buttons: 'No,Yes'),
    Daction(text: 'Gusul/Nazafat', buttons: 'Yes,No'),
    Daction(text: 'Waledain Salaam', buttons: 'Yes,No'),
    Daction(text: 'Tilawat al Quran', buttons: 'Yes,No'),
    Daction(text: 'Zohr Asr Namaz', buttons: 'امامة,اداء,قضاء,No'),
    Daction(text: 'Homework', buttons: 'Yes,No'),
    Daction(text: 'Maghrib Isha Namaz', buttons: 'امامة,اداء,قضاء,No'),
    Daction(text: 'Wazifatul Layl', buttons: 'Yes,No'),
    Daction(text: 'Siwaak', buttons: 'Yes,No')
  ];

  @override
  void initState() {
    super.initState();
    if (widget.udata['itsid'] == '0') {
      Future(() {
        Navigator.popAndPushNamed(context, '/login');
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
                      child: Image.network(
                          'https://idaramsb.net/assets/img/itsphoto.php?itsid=$itsid'),
                      color: Colors.amber,
                      padding: EdgeInsets.all(5.0))),
              Container(
                  color: Colors.pinkAccent, padding: EdgeInsets.all(20.0)),
              Container(color: Colors.grey, padding: EdgeInsets.all(20.0)),
            ],
          ),
          for (var i in actions) ActionCard(action: i, delete: () {}),
        ],
      ),
    );
  }
}
