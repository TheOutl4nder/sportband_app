// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sportband_app/models/bluetoothModel.dart';
import 'package:provider/provider.dart';
import 'package:sportband_app/sessionStats.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

bool sessionOngoing=false;

class SessionPage extends StatefulWidget {
  
  SessionPage({Key? key}) : super(key: key);
  
  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ListView(children: [
        Row(children: [Icon(Icons.sports_baseball,size: 128,color: Theme.of(context).primaryColor,)], mainAxisAlignment: MainAxisAlignment.center, ),
        Row(children: [Text("Sport Band App",style: TextStyle(color: Color(0xFFD2D7DB),fontSize: 20,),)], mainAxisAlignment: MainAxisAlignment.center,),
        Row(children: [Container(height: 36,)],),
        Row(children: [Container(height: 20,)],),
        Container(child: !sessionOngoing?
        Row(children: [MaterialButton(onPressed: ()=>setState(() {startSession();_stopWatchTimer.onExecute.add(StopWatchExecute.reset);_stopWatchTimer.onExecute.add(StopWatchExecute.start);}),child: Text("Iniciar Entrenamiento",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20)),)],mainAxisAlignment: MainAxisAlignment.center,):
        Column(children: [SessionStats(),Row(children: [Icon(Icons.timer,size: 60,color: Theme.of(context).primaryColor,),StreamBuilder<int>(stream: _stopWatchTimer.rawTime, initialData: _stopWatchTimer.rawTime.value, builder: (context,snapshot){
          final value = snapshot.data;
          final displayTime = StopWatchTimer.getDisplayTime(value!,);
          return Text(displayTime, style: TextStyle(fontSize: 36,));
        })],mainAxisAlignment: MainAxisAlignment.spaceEvenly,)]),
          
        )
        
      ],padding: EdgeInsets.all(40.0),),
    );
  }
}