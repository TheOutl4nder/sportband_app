import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:sportband_app/login.dart';
import 'package:sportband_app/models/bluetoothModel.dart';
import 'package:sportband_app/models/statsModel.dart';
import 'package:sportband_app/sessionPage.dart';
import 'dart:io';
import 'dart:convert';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sportband_app/sessionStats.dart';

FlutterReactiveBle ble = FlutterReactiveBle();
final info=NetworkInfo();
late HttpServer server;

void main() async{
  await dotenv.load(fileName: ".env");
  startServer();
  runApp(
    MyApp(),
  );
}

const mainColor=Color(0xFFF85F6A);

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [ChangeNotifierProvider(create: (_)=>bluetoothModel(ble)),ChangeNotifierProvider(create: (_)=>statsModel())],
    child: MaterialApp(home: LoginPage(),theme: ThemeData(primaryColor: mainColor,),),); 
  }
}

startServer()async{
  var ip = await info.getWifiIP();
  try{
    server = await HttpServer.bind(ip, 8080);
  }
  catch(e){
    print(e);
  }
  showToastMessage("Server is running on: "+server.address.toString()+":8080");
  await for (var request in server){
    var parsed;
    if(request.method=='POST'){
      var reqSets=await utf8.decoder.bind(request).join();
      var params = Uri(query: reqSets).queryParameters;
      print(params);
      Reading read = generateReading(params.entries.toString());
      //Reading recievedReading = Reading(parsed['AxisX'] as double, parsed['AxisY'] as double, parsed['AxisZ'] as double, parsed['AccX'] as double, parsed['AccY'] as double, parsed['AccZ'] as double);
      add(read);
    }
    request.response
    ..headers.contentType = new ContentType("text", "plain",charset: "utf-8")
    ..write("Hello World")
    ..close();
  }
}

void showToastMessage(String message){
  Fluttertoast.showToast(
    msg: message, //message to show toast
    toastLength: Toast.LENGTH_SHORT, //duration for message to show
    gravity: ToastGravity.BOTTOM, //where you want to show, top, bottom
    timeInSecForIosWeb: 1, //for iOS only
    //backgroundColor: Colors.red, //background Color for message
    textColor: Colors.white, //message text color
    fontSize: 16.0 //message font size
  );
}

Reading generateReading(String parameters){
  
  return Reading(0, 0, 0, 0, 0, 0);
}

