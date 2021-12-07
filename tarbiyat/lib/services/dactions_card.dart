import 'package:flutter/material.dart';
import 'dactions.dart';

class ActionCard extends StatelessWidget {
  final Daction action;
  final VoidCallback delete;
  ActionCard({required this.action, required this.delete});

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
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(action.text,
                style: TextStyle(fontSize: 18.0, color: Colors.grey[600])),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var i in btns)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: _getColour(i)),
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
