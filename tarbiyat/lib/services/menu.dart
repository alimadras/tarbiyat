import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarbiyat/pages/accounts.dart';
import 'package:tarbiyat/pages/home.dart';

class NavDrawer extends StatelessWidget {
  final Map udata;
  NavDrawer(this.udata);

  void _remloc(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('itsid1');
    prefs.reload();
    String itsid5 = prefs.getString('itsid5') ?? '0';
    String itsid4 = prefs.getString('itsid4') ?? '0';
    String itsid3 = prefs.getString('itsid3') ?? '0';
    String itsid2 = prefs.getString('itsid2') ?? '0';
    if (itsid2 != '0') {
      prefs.setString('itsid1', itsid2);
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
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    String itsid = udata['itsid'];
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.amber,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: itsid == '0'
                        ? NetworkImage(
                            'http://innovacos.com/wp-content/uploads/2017/01/profile-silhouette-300x300.jpg')
                        : NetworkImage(
                            'https://idaramsb.net/assets/img/itsphoto.php?itsid=$itsid'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Home'),
            onTap: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Home(udata)))
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Manage Accounts'),
            onTap: () => {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Accounts(udata)),
                  (route) => route.isFirst)
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              _remloc(context);
            },
          ),
        ],
      ),
    );
  }
}
