import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/pages/home.dart';
import 'package:tarbiyat/pages/accounts.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool hasInternet = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String itsid = "";
  String password = "";

  void getData(itsid, password) async {
    hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet) {
      Map udata = {};
      var url = Uri.parse(
          'http://139.59.31.87/horizons/cAuth.php?ITSLogin=$itsid&parameter=its_id&param2=password&value2=$password');
      Response response = await get(url);
      Map data = jsonDecode(response.body);
      if (data['status']) {
        var url1 = Uri.parse(
            'http://139.59.31.87/horizons/cAuth.php?mumindetails=$itsid');
        Response response1 = await get(url1);
        Map data1 = jsonDecode(response1.body);
        String fullname = data1['NewDataSet']['Table']['Fullname'];
        _getloc() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.reload();
          List<String> itsidlist = [];
          String itsidliststring = '[';
          itsidlist.add(
              prefs.getString('itsid1') ?? '{"itsid":"0","fullname":"Empty"}');
          itsidlist.add(
              prefs.getString('itsid2') ?? '{"itsid":"0","fullname":"Empty"}');
          itsidlist.add(
              prefs.getString('itsid3') ?? '{"itsid":"0","fullname":"Empty"}');
          itsidlist.add(
              prefs.getString('itsid4') ?? '{"itsid":"0","fullname":"Empty"}');
          itsidlist.add(
              prefs.getString('itsid5') ?? '{"itsid":"0","fullname":"Empty"}');
          String itsidcurrent = '{"itsid":"$itsid","fullname":"$fullname"}';
          int step1 = 0;
          for (var l = 0; l < itsidlist.length; l++) {
            Map itsdet = jsonDecode(itsidlist[l]);
            if (itsid == itsdet['itsid']) {
              step1 = 1;
            }
          }
          //if the user already exists
          if (step1 == 1) {
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
            udata = jsonDecode(itsidlist[0]);
          } else {
            if (itsidlist[(itsidlist.length - 1)] ==
                '{"itsid":"0","fullname":"Empty"}') {
              for (var m = (itsidlist.length - 1); m > 0; m--) {
                if (itsidlist[m] == '{"itsid":"0","fullname":"Empty"}' &&
                    itsidlist[(m - 1)] != '{"itsid":"0","fullname":"Empty"}') {
                  itsidlist[m] = itsidlist[(m - 1)];
                  itsidlist[(m - 1)] = '{"itsid":"0","fullname":"Empty"}';
                  prefs.setString('itsid' + (m + 1).toString(), itsidlist[m]);
                }
              }
              prefs.setString('itsid1', itsidcurrent);
              udata = jsonDecode(itsidcurrent);
            } else {
              return showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Accounts full"),
                  content: Text(
                      "The system has reached the maximum amount of accounts on a single device. Kindly remove one or more accounts to add more."),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                Accounts(jsonDecode(itsidlist[0]))));
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            }
          }
        }

        _getloc();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home(udata)),
            (route) => route.isFirst);
      } else {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Invalid Details"),
            content: Text("ITS ID/Password seems to be incorrect."),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('iMSB for Students')),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'ITS Number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value == null || value.isEmpty || value.length != 8) {
                      return 'Please enter a valid ITS Number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    itsid = value!;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: TextFormField(
                  decoration: InputDecoration(hintText: 'Password'),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value!;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    getData(itsid, password);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
