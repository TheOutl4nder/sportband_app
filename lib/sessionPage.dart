// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class sessionData{
  List sessionHits=[];
  late Duration sessionTime;
  DateTime sessionStart;

  sessionData(this.sessionStart);
}

class hit{
  double axis_X;
  double axis_Y;
  double axis_Z;
  double acc_X;
  double acc_Y;
  double acc_Z;

  hit(this.axis_X,this.axis_Y,this.axis_Z,this.acc_X,this.acc_Y,this.acc_Z);
}

late sessionData currentSession;

class SessionPage extends StatefulWidget {
  SessionPage({Key? key}) : super(key: key);

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address="...";
  String _name="...";

  @override
  void initState() {
    super.initState();

    FlutterBluetoothSerial.instance.state.then((value){
      setState(() {
        _bluetoothState = value;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if (await FlutterBluetoothSerial.instance.isEnabled!=null) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sport Band App'),
        ),
        body: Container(
          child: ListView(children: [
            Divider(),
            SwitchListTile(
              title: Text("Enable Bluetooth?"),
              value: _bluetoothState.isEnabled, onChanged: (bool value){
              future() async{
                if(value)
                  await FlutterBluetoothSerial.instance.requestEnable();
                else
                  await FlutterBluetoothSerial.instance.requestDisable();
              }

              future().then((value){
                setState(() {});
              });
            }),
            MaterialButton(
              onPressed: startSession,
              child: Text("Start Session",style: TextStyle(color: Colors.grey[200]),),
              color: Colors.red,)
        ],)
      ));
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