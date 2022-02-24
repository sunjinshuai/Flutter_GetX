import 'dart:async';
import 'package:get/get.dart';

enum TrafficLight { green, red, yellow }

class TrafficLightController extends GetxController {
  late TrafficLight _currentLight;
  get currentLight => _currentLight;

  int _counter = 0;
  get counter => _counter;

  late Timer _downcountTimer;

  @override
  void onInit() {
    _counter = 20;
    _currentLight = TrafficLight.green;
    super.onInit();
  }

  @override
  void onReady() {
    _downcountTimer = Timer.periodic(Duration(seconds: 1), decreament);
    super.onReady();
  }

  void decreament(Timer timer) {
    _counter--;
    if (_counter == 0) {
      switch (_currentLight) {
        case TrafficLight.green:
          _currentLight = TrafficLight.yellow;
          _counter = 3;
          update(['green', 'yellow']);
          break;
        case TrafficLight.yellow:
          _currentLight = TrafficLight.red;
          _counter = 10;
          update(['red', 'yellow']);
          break;
        case TrafficLight.red:
          _currentLight = TrafficLight.green;
          _counter = 20;
          update(['red', 'green']);
          break;
      }
    } else {
      switch (_currentLight) {
        case TrafficLight.green:
          update(['green']);
          break;
        case TrafficLight.yellow:
          update(['yellow']);
          break;
        case TrafficLight.red:
          update(['red']);
          break;
      }
    }
  }

  @override
  void onClose() {
    _downcountTimer.cancel();
    super.onClose();
  }
}
