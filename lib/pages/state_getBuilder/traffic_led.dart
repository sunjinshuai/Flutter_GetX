import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TrafficLed extends StatelessWidget {
  final Color ledColor;
  final int secondsLeft;
  final bool showSeconds;
  final double ledSize;
  const TrafficLed({
    Key? key,
    required this.ledColor,
    required this.secondsLeft,
    required this.showSeconds,
    this.ledSize = 60.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: ledSize,
        height: ledSize,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(ledSize / 2),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF505050),
              offset: Offset(1, -1),
              blurRadius: 0.2,
            )
          ],
        ),
        child: Offstage(
          child: Text(
            '$secondsLeft',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: this.ledColor,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          offstage: !showSeconds,
        ),
      ),
    );
  }
}
