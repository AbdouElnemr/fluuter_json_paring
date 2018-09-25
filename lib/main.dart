import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map _quackes;
List _features;

void main() async {
  _quackes = await getQuackes();
  _features = _quackes['features'];
  print(_quackes);
  runApp(new MaterialApp(
    title: "Quacke",
    home: new Quackes(),
  ));
}

class Quackes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Quackes"),
          centerTitle: true,
          backgroundColor: Colors.deepOrange,
        ),
        body: new Center(
          child: new ListView.builder(
            itemCount: _features.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (BuildContext context, int position) {
              if (position.isOdd)
                return new Divider(
                  height: 3.0,
                  color: Colors.green,
                );
              final index = position ~/ 2;
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(
                  _features[index]['properties']['time'] * 1000,
                  isUtc: true));

              return new ListTile(
                title: new Text(
                  "At : $date",
                  style: new TextStyle(
                    fontSize: 16.0,
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: new Text(
                  "${_features[index]['properties']['place']}",
                  style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                leading: new CircleAvatar(
                  backgroundColor: Colors.green,
                  child: new Text(
                    "${_features[index]['properties']['mag']}",
                    style: new TextStyle(
                        fontSize: 17.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                onTap: (){
                  _showAlert(context, "${_features[index]['properties']['title']}");
                },
              );
            },
          ),
        ));
  }
}

void _showAlert(BuildContext context, String message) {
  showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text("Quackes"),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: new Text("OK"))
        ],
      ));
}

Future<Map> getQuackes() async {
  String apiUrl =
      "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}
