import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


void main() async {

  Map _data = await _getEarthQuakeData();
  List _earthQuakeData = _data['features'];

  var format = new DateFormat('MMMM d, y h:mm a');

 print(_earthQuakeData[0]['properties']['time']);

  runApp(new MaterialApp(
    title: 'Earthquake Data',
    home: new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text('EARTHQUAKE DATA',
          style: new TextStyle(
              color: Colors.white
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: _earthQuakeData.length,
            padding: EdgeInsets.all(2.5),
            itemBuilder: (BuildContext context, int position) {
              return Column(
                children: <Widget>[
                  new Divider(height: 5.5),
                  new ListTile(
                    title: new Text(format.format((_formatDate(_earthQuakeData[position]['properties']['time'])))),
                    subtitle: Text(_earthQuakeData[position]['properties']['place']),
                    leading: CircleAvatar(
                      backgroundColor: Colors.amberAccent.shade400,
                      child: Text("${_earthQuakeData[position]['properties']['mag']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.9
                      ),),
                    ),
                    onTap: () => _getMoreInfo(context, _earthQuakeData[position]['properties']['title']),
                  )
                ],
              );
            }),
      ),

      ),
    ),
  );
}

Future _getEarthQuakeData() async {
  String uri = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(uri);
  return json.decode(response.body);

}

void _getMoreInfo(BuildContext context, String details) {
  var alert = new AlertDialog(
    title: Text('Earthquake Details'),
    content: Text(details) ,
    actions: <Widget>[
      FlatButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
      )
    ],
  );

  showDialog(context: context, builder: (context) => alert);
  
}

DateTime _formatDate(int time) {
  DateTime date = new DateTime.fromMillisecondsSinceEpoch(time * 1000);
  return date;
}