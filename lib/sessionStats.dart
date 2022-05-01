// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportband_app/models/bluetoothModel.dart';
import 'package:provider/provider.dart';
import 'package:sportband_app/sessionPage.dart';

class sessionData{
  List sessionHits=[];
  late Duration sessionTime;
  DateTime sessionStart;

  sessionData(this.sessionStart);
}


class recommendation{
  String angleRec;
  String speedRec;

  recommendation(this.angleRec,this.speedRec);
}

late Timer _timer;

late sessionData currentSession;
late recommendation currentRecommendation;

class SessionStats extends StatelessWidget {
  const SessionStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blue = Provider.of<bluetoothModel>(context);
    return Column(children: [
          Row(children: [Text("Sesión del "+currentSession.sessionStart.day.toString()+" de "+getMonthStr(currentSession.sessionStart.month),style: TextStyle(color: Colors.black,fontSize: 24,),)], mainAxisAlignment: MainAxisAlignment.center,),
          Row(children: [Container(height: 36,)],),
          Row(children: [Text("Golpe "+(currentSession.sessionHits.length+1).toString(),style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 36),)],),
          Row(children: [Container(height: 20,)],),
          Row(children: [Text("Recomendación:",style: TextStyle(color: Colors.black,fontSize: 24,))],),
          Row(children: [Container(height: 20,)],),
          Row(children: [Icon(Icons.info,color: Theme.of(context).primaryColor,),Text("Ángulo: "+currentRecommendation.angleRec,style: TextStyle(color: Colors.black,fontSize: 18,),)],mainAxisAlignment: MainAxisAlignment.start,),
          Row(children: [Container(height: 18,)],),
          Row(children: [Icon(Icons.info,color: Theme.of(context).primaryColor,),Text("Velocidad: "+currentRecommendation.speedRec,style: TextStyle(color: Colors.black,fontSize: 18,),)],mainAxisAlignment: MainAxisAlignment.start,),
          Row(children: [Container(height: 80,)],),

        ],);
  }
}

postData(Reading read) async{
  var response = http.post(Uri.parse("https://api.thingspeak.com/update.json"),
    body: {
    "api_key": dotenv.env['APIKEY'],
    "field1": read.axis_X,
    "field2": read.axis_Y,
    "field3": read.axis_Z,
    "field4": read.acc_X,
    "field5": read.acc_Y,
    "field6": read.acc_Z,
  });
  print(response);
}

startSession(){
  DateTime start = DateTime.now();
  currentSession = sessionData(start);
  print("started session at:"+start.toString());
  currentRecommendation=recommendation("", "");
  sessionOngoing = true;
  currentSession.sessionTime= Duration.zero;
}

stopSession(){
  for(Reading hit in currentSession.sessionHits){
    postData(hit);
  }
  sessionOngoing = false;
}

getMonthStr(int month){
  switch(month){
    case 1:
      return "Enero";
    case 2:
      return "Febrero";
    case 3:
      return "Marzo";
    case 4:
      return "Abril";    
    case 5:
      return "Mayo";
    case 6:
      return "Junio";
    case 7:
      return "Julio";
    case 8:
      return "Agosto";
    case 9:
      return "Septiembre";
    case 10:
      return "Octubre";
    case 11:
      return "Noviembre";
    default:
      return "Diciembre";

  }
}