// ignore_for_file: file_names
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:sportband_app/sessionStats.dart';

class Reading{
    double axis_X;
    double axis_Y;
    double axis_Z;
    double acc_X;
    double acc_Y;
    double acc_Z;

    Reading(this.axis_X,this.axis_Y,this.axis_Z,this.acc_X,this.acc_Y,this.acc_Z);
}

class bluetoothModel with ChangeNotifier{


  final flutterReactiveBle = FlutterReactiveBle();

  FlutterReactiveBle _ble;
  StreamSubscription? _subscription;
  late StreamSubscription<ConnectionStateUpdate> _connection;
  late Reading _currentReading;
  late String _recAng;
  late String _recSpe;

  bluetoothModel(this._ble){

    _connectBLE();
  }

  void _connectBLE(){
    notifyListeners();
    _subscription?.cancel();
    _subscription = _ble.scanForDevices(
        withServices: [Uuid.parse("1234")]).listen((device) async {
      if (device.name == 'HC-05') {
        print('Smartband found!');
        if (_connection != null) {
          try {
            await _connection.cancel();
          } on Exception catch (e, _) {
            print("Error disconnecting from a device: $e");
            notifyListeners();
          }
        }
          _connection = _ble
            .connectToDevice(
          id: device.id,
        )
            .listen((connectionState) async {
          // Handle connection state updates
          print('connection state:');
          print(connectionState.connectionState);
          if (connectionState.connectionState ==
              DeviceConnectionState.connected) {
            final characteristic = QualifiedCharacteristic(
                serviceId: Uuid.parse("181A"),
                characteristicId: Uuid.parse("1234"),
                deviceId: device.id);
            _ble.subscribeToCharacteristic(characteristic).listen((data) {
              // code to handle incoming data
              print(data);
              //we multiply it by 1000000 on the other end so to retore it to original val we divide.
              List ddata=[];
              for(int val in data){
                ddata.add(val/1000000);
              }
              _currentReading = Reading(ddata[0], ddata[1], ddata[2], ddata[3], ddata[4], ddata[5]);
              _recAng = generateRecommendation(_currentReading);
              _recSpe = generateRecommendation(_currentReading);
              currentRecommendation = recommendation(_recAng, _recSpe);
              notifyListeners();

            }, onError: (dynamic error) {
              // code to handle errors
              print('error subscribing characteristic!');
              print(error.toString());
              notifyListeners();

            });

           // print('disconnected');
          }
        }, onError: (dynamic error) {
          // Handle a possible error
          print('error connecting!');
          print(error.toString());
          notifyListeners();

        });
      }
    }, onError: (error) {
      print('error scanning!');
      print(error.toString());
      notifyListeners();

    });
  }

  generateRecommendation(Reading reading){
    return "Very good!";
  }

  
}