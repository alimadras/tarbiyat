import 'package:flutter/material.dart';
import 'dactions.dart';
import 'package:tarbiyat/models/dbhelper.dart';

class ActionCard extends StatelessWidget {
  final Daction action;
  final itsid;
  final Function change;
  ActionCard({required this.action, required this.itsid, required this.change});

  Color _getColour(i) {
    Color colour = i == 'امامة'
        ? Colors.amber
        : i == 'اداء'
            ? Colors.greenAccent
            : i == 'No'
                ? Colors.redAccent
                : i == 'قضاء'
                    ? Colors.grey
                    : i == 'Yes'
                        ? Colors.greenAccent
                        : Colors.grey;
    return colour;
  }

  @override
  Widget build(BuildContext context) {
    var btns = action.buttons.split(',');
    var yesbtn = 1;
    var rid = action.id;
    for (var k in btns) {
      if (k == 'Change') yesbtn = 0;
    }
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(action.text,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 6.0),
            yesbtn == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var i in btns)
                        ElevatedButton(
                          onPressed: () {
                            if (i == 'Change')
                              DBHelper.instance.updateRaw(
                                  "update answers set status = ? where rid = ? and date(adatetime) = DATE('now') and its = ?",
                                  [0, rid, itsid]);
                            change();
                          },
                          style:
                              ElevatedButton.styleFrom(primary: _getColour(i)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(i,
                                style: TextStyle(
                                    fontFamily: 'KanzalMarjaan',
                                    fontSize: 20.0,
                                    color: Colors.grey[800])),
                          ),
                        )
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var i in btns)
                        ElevatedButton(
                          onPressed: () {
                            DBHelper.instance.insert('answers', {
                              'rid': action.id,
                              'its': itsid,
                              'buttons': '$i',
                              'status': 1
                            });
                            change();
                          },
                          style:
                              ElevatedButton.styleFrom(primary: _getColour(i)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(i,
                                style: TextStyle(
                                    fontFamily: 'KanzalMarjaan',
                                    fontSize: 20.0,
                                    color: Colors.grey[800])),
                          ),
                        )
                    ],
                  )
          ])),
    );
  }
}
