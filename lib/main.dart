
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: _MainPageState(),
  ));
}

class _MainPageState extends StatefulWidget {
  const _MainPageState({Key? key}) : super(key: key);

  @override
  State<_MainPageState> createState() => _MainPageStateState();
}

class _MainPageStateState extends State<_MainPageState> {
  int chosenTime = 5;

  bool started = false;
  int minutes = 0, seconds = 12;
  String digitMinutes = '00', digitSeconds = '00';
  Timer? timer;
  bool isVisibleTimer = false;

  late FixedExtentScrollController scrollController;
  var _currentHorizontalIntValue = 10;

  //stop timer
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  //start timer
  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      int localSeconds = seconds;
      int localMinutes = _currentHorizontalIntValue - 1;

      if (localSeconds <= 0) {
        localMinutes--;
        localSeconds = 59;
      } else {
        localSeconds--;
      }

      setState(() {
        minutes = localMinutes;
        seconds = localSeconds;
        digitSeconds = (seconds >= 10) ? '$seconds' : '0$seconds';
        digitMinutes = (minutes >= 10) ? '$minutes' : '0$minutes';
      });
    });
  }

  //reset timer
  void reset() {
    timer!.cancel();
    setState(() {
      minutes = chosenTime;
      seconds = 0;

      digitMinutes = '00';
      digitSeconds = '00';
    });
  }

  @override
  void dispose() {
    scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          buildPicker('Pick work time'),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                isVisibleTimer = !isVisibleTimer;
                start();
                // (started) ? start() : stop();
              });
            },
            child: Icon(Icons.not_started_sharp),
          )
        ],
      )),
    );
  }

  Widget buildPicker(var title) => Container(
        child: Column(
          children: [
            Text(title),
            Visibility(
              visible: !isVisibleTimer,
              child: Center(
                child: NumberPicker(
                  value: _currentHorizontalIntValue,
                  minValue: 5,
                  maxValue: 60,
                  step: 5,
                  itemHeight: 100,
                  axis: Axis.horizontal,
                  onChanged: (value) =>
                      setState(() => _currentHorizontalIntValue = value),
                ),
              ),
            ),
            Visibility(
              visible: isVisibleTimer,
                child: Center(

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('$digitMinutes:$digitSeconds', style: TextStyle(
                  fontSize: 50,

                ),),
              ),
            ))
          ],
        ),
      );
}
