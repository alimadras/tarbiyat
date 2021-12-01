import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String itsid = "";
  String password = "";

  void getData(itsid, password) async {
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
        String itsid5 = prefs.getString('itsid5') ?? '0';
        String itsid4 = prefs.getString('itsid4') ?? '0';
        String itsid3 = prefs.getString('itsid3') ?? '0';
        String itsid2 = prefs.getString('itsid2') ?? '0';
        String itsid1 = prefs.getString('itsid') ?? '0';
        String itsidloc = '{"itsid":"$itsid","fullname":"$fullname"}';
        if (itsidloc == itsid5) {
          prefs.setString('itsid', itsidloc);
          prefs.setString('itsid5', itsid1);
        }
        if (itsidloc == itsid4) {
          prefs.setString('itsid', itsidloc);
          prefs.setString('itsid4', itsid1);
        }
        if (itsidloc == itsid3) {
          prefs.setString('itsid', itsidloc);
          prefs.setString('itsid3', itsid1);
        }
        if (itsidloc == itsid2) {
          prefs.setString('itsid', itsidloc);
          prefs.setString('itsid2', itsid1);
        }
        if (itsid5 == '0') {
          if (itsid5 == '0' && itsid4 != '0') {
            itsid5 = itsid4;
            prefs.setString('itsid5', itsid5);
            itsid4 = '0';
          }
          if (itsid4 == '0' && itsid3 != '0') {
            itsid4 = itsid3;
            prefs.setString('itsid4', itsid4);
            itsid3 = '0';
          }
          if (itsid3 == '0' && itsid2 != '0') {
            itsid3 = itsid2;
            prefs.setString('itsid3', itsid3);
            itsid2 = '0';
          }
          if (itsid2 == '0' && itsid1 != '0') {
            itsid2 = itsid1;
            prefs.setString('itsid2', itsid2);
            itsid1 = '0';
          }
          prefs.setString('itsid', itsidloc);
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
                    Navigator.of(ctx).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          );
        }
      }

      _getloc();
      Navigator.pushReplacementNamed(context, '/');
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
