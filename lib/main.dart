import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sport Band App'),
        ),
        body: Row(children: [
          MaterialButton(
            onPressed: postData,
            child: Text("Send data",style: TextStyle(color: Colors.grey[200]),),
            color: Colors.red,)
        ],)
      ),
    );
  }
}

postData() async{
  var response = http.post(Uri.parse("https://api.thingspeak.com/update.json"),
    body: {
    "api_key": dotenv.env['APIKEY'],
    "field": "100"
  });
  print(response);
}