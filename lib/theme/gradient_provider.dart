import 'package:flutter/material.dart';

class GradientProvider extends ChangeNotifier {
   bool isSwitched = false;

    final Gradient gradient1 = LinearGradient(
    colors: [Color(0xFF87CEEB), Color(0xFF98FF98)], // Sky blue to mint
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

    final Gradient gradient2 =  LinearGradient(
    colors: [
      Color(0xFF5DE0E6),
      Color(0xFF004AAD),
    ], // Orange gradients
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  Gradient get currentGradient => isSwitched? gradient2 : gradient1;

  void toggleSwitch(bool value){
    isSwitched  = value;
    notifyListeners();
  }
}