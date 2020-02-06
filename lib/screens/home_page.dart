import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<AnimatedCircularChartState> _chatkey =
      GlobalKey<AnimatedCircularChartState>();

  final _chatSize = const Size(250.0, 250.0);

  Color labelColor = Colors.blue;

  List<CircularStackEntry> _generateChartData(int min, int second) {
    double temp = second * 0.6;
    double adjustedSeconds = second + temp;

    double tempmin = min * 0.6;
    double adjustedMinutes = min + tempmin;

    Color dialColor = Colors.blue;

    labelColor = dialColor;

    List<CircularStackEntry> data = [
      CircularStackEntry(
        [CircularSegmentEntry(adjustedSeconds, dialColor)]
      )
    ];
    if(min > 0) {
      labelColor = Colors.green;
      data.removeAt(0);
      data.add(CircularStackEntry(
        [CircularSegmentEntry(adjustedSeconds, dialColor)]));
      data.add(CircularStackEntry(
        [CircularSegmentEntry(adjustedMinutes, Colors.green)]));
    }
    return data;
  }

  Stopwatch watch = Stopwatch();
  Timer timer;

  String elapsedTime = '';

  updataTime(Timer timer) {
    if(watch.isRunning) {
      var milliseconds = watch.elapsedMilliseconds;
      int hundreds = (milliseconds / 10).truncate();
      int seconds = (milliseconds / 100).truncate();
      int minutes = (seconds / 60).truncate();
      setState(() {
        elapsedTime = transformMilliSeconds(watch.elapsedMicroseconds);
        if(seconds > 59) {
          seconds = seconds - (59 * minutes);
          seconds = seconds - minutes;
        }
        List<CircularStackEntry> data = _generateChartData(minutes, seconds);
        _chatkey.currentState.updateData(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _labelStyle = Theme.of(context).textTheme.title.merge(TextStyle(color: labelColor));

    return Scaffold(
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              child: AnimatedCircularChart(
                  size: _chatSize,
                  initialChartData: _generateChartData(0, 0),
                  key: _chatkey,
                chartType: CircularChartType.Radial,
                edgeStyle: SegmentEdgeStyle.round,
                percentageValues: true,
                holeLabel: elapsedTime,
                labelStyle: _labelStyle,
              ),
            ),

            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.green,
                        onPressed: startWatch,
                        child: Icon(Icons.play_arrow),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: stopWatch,
                        child: Icon(Icons.stop),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            Expanded(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FloatingActionButton(
                        backgroundColor: Colors.blue,
                        onPressed: resetWatch,
                        child: Icon(Icons.refresh),
                      ),

                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  startWatch() {
    watch.start();
    timer = Timer.periodic(Duration(milliseconds: 1000), updataTime);
  }

  stopWatch() {
    watch.stop();
    setTime();
  }

  resetWatch() {
    watch.reset();
    setTime();
  }

  setTime() {
    var timeSoFar = watch.elapsedMilliseconds;
    setState(() {
      elapsedTime = transformMilliSeconds(timeSoFar);
      List<CircularStackEntry> data = _generateChartData(0, 0);
      _chatkey.currentState.updateData(data);
    });
  }

  transformMilliSeconds(int milliseconds) {
    //Thanks to Andrew
    int hundreds = (milliseconds / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

}

