import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
Map _data;
List _features;
var format = new DateFormat('yyyy-MM-dd');
void main()async{
   _data = await getQuakes();
_features = _data['features'];
print(_data['features'][2]['properties']['time']);
   print(new DateFormat.yMMMd().format(new DateTime(_data['features'][2]['properties']['time'])));
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Dhul Gariir"),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
      body: Center(
          child: Container(
            alignment: Alignment.center,
            child: ListView.builder(

                padding:  EdgeInsets.all(8.0),
                itemCount: _features.length,
                itemBuilder: (BuildContext context,int position){
                  if(position.isOdd) return Divider(height: 5.0);
                  final index = position ~/2;// we are dividing position by 2 and returning an integer result

                  var format = new DateFormat.yMMMMd("en_US").add_jm();
                  var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']*1000,isUtc: true));

                  return Column(
                    children: <Widget>[
                      Divider(height: 5.5),
                      ListTile(

                        title: Text("$date",
                      style: TextStyle(fontSize: 17.9),),
                        subtitle: Text(_data['features'][position]['properties']['place'],
                          style: TextStyle(fontSize: 17.9,
                              color: Colors.deepOrange,
                              fontStyle: FontStyle.italic),),
                        leading: CircleAvatar(
                          backgroundColor: Colors.greenAccent,
                          child: Text(_data['features'][position]['properties']['mag'].toString(),
                              style:TextStyle(fontSize: 20.6,
                                  color: Colors.white)),
                        ),
                        onTap: () => _showonTapMessage(context,_data['features'][position]['properties']['title']),

                      ),

                    ],
                  );

                }),

          )

      ),

    ),
  ));
}
void _showonTapMessage(BuildContext context,String message){
  var alert = AlertDialog(

    title:Text("Dhul Gariir") ,
    content: Text(message),
    actions: <Widget>[
      FlatButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('Ok'),
      )],
  );
  //showDialog(context: context,child: alert);
  showDialog(context: context,builder: (context)=>alert);
}

Future<Map> getQuakes() async {
  String apiUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiUrl);
  return json.decode(response.body);
}