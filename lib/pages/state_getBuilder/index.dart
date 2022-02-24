import 'package:flutter/material.dart';
import 'package:flutter_app/pages/state_getBuilder/controller.dart';
import 'package:flutter_app/pages/state_getBuilder/traffic_led.dart';
import 'package:get/get.dart';

class TrafficLedPage extends StatelessWidget {
  TrafficLedPage({Key? key}) : super(key: key);
  final TrafficLightController lightController = TrafficLightController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('红绿灯'),
      ),
      body: Center(
        child: Container(
          width: 240,
          height: 100,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF303030),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF808080),
                offset: Offset(2, 4),
                blurRadius: 6.0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<TrafficLightController>(
                id: 'green',
                init: lightController,
                builder: (state) => TrafficLed(
                  ledColor: (state.currentLight == TrafficLight.green
                      ? Colors.green
                      : Colors.black),
                  secondsLeft: state.counter,
                  showSeconds: state.currentLight == TrafficLight.green,
                ),
              ),
              GetBuilder<TrafficLightController>(
                id: 'yellow',
                init: lightController,
                builder: (state) => TrafficLed(
                  ledColor: (state.currentLight == TrafficLight.yellow
                      ? Colors.yellow[600]!
                      : Colors.black),
                  secondsLeft: state.counter,
                  showSeconds: state.currentLight == TrafficLight.yellow,
                ),
              ),
              GetBuilder<TrafficLightController>(
                id: 'red',
                init: lightController,
                builder: (state) => TrafficLed(
                  ledColor: (state.currentLight == TrafficLight.red
                      ? Colors.red[600]!
                      : Colors.black),
                  secondsLeft: state.counter,
                  showSeconds: state.currentLight == TrafficLight.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
