// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportband_app/models/bluetoothModel.dart';

class sessionData{
  List sessionHits=[];
  late Duration sessionTime;
  DateTime sessionStart;

  sessionData(this.sessionStart);
}

late sessionData currentSession;

class SessionPage extends StatelessWidget {
  const SessionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Smartband App"),),
      body: ListView(children: [
        Row(children: [Icon(Icons.sports_baseball)], mainAxisAlignment: MainAxisAlignment.center,)
        
      ],),
    );
  }
}

postData() async{
  var response = http.post(Uri.parse("https://api.thingspeak.com/update.json"),
    body: {
    "api_key": dotenv.env['APIKEY'],
    "field1": "75"
  });
  print(response);
}

startSession(){
  DateTime start = DateTime.now();
  currentSession = sessionData(start);
  print("started session at:"+start.toString());
}