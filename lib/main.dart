import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:sportband_app/models/bluetoothModel.dart';
import 'package:sportband_app/sessionPage.dart';

FlutterReactiveBle ble = FlutterReactiveBle();

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<bluetoothModel>(create: (_)=>bluetoothModel(ble),
    child: MaterialApp(home: SessionPage(),),);
  }
}

