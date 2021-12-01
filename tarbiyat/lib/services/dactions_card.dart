import 'package:flutter/material.dart';
import 'dactions.dart';

class ActionCard extends StatelessWidget {
  final Daction action;
  final VoidCallback delete;
  ActionCard({required this.action, required this.delete});

  Color _getColour(i) {
    Color colour = i == 'Imamat'
        ? Colors.amber
        : i == 'Adaa'
            ? Colors.greenAccent
            : i == 'No'
                ? Colors.redAccent
                : i == 'Qadhaa'
                    ? Colors.redAccent
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
                              fontSize: 14.0, color: Colors.grey[800])),
                    ),
                  )
              ],
            )
          ])),
    );
  }
}
