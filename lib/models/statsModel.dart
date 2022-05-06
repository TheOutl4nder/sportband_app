import 'package:flutter/cupertino.dart';
import 'package:sportband_app/models/bluetoothModel.dart';

class statsModel extends ChangeNotifier{
  int HitCount=0;
  String axisRec="";
  String accRec="";

  statsModel();

  void addHit(Reading r){
    HitCount++;
    axisRec=generateRecommendation(r);
    accRec=generateRecommendation(r);
    notifyListeners();
  }
}