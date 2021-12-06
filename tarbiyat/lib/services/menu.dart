import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavDrawer extends StatelessWidget {
  final Map udata;
  NavDrawer(this.udata);

  void _remloc(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('itsid');
    Navigator.pushReplacementNamed(context, '/login');
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
                    image: NetworkImage(
                        'https://idaramsb.net/assets/img/itsphoto.php?itsid=$itsid'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {},
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
            onTap: () => {Navigator.pushReplacementNamed(context, '/accounts')},
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
