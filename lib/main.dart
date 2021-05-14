import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int touchedIndex, doubleClick;
  double heightCont = 0;
  Color colorCont;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/ConEg.png',
              height: 50,
              width: 50,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 500,
                width: 500,
                child: PieChart(
                  PieChartData(
                      pieTouchData: //TODO - Manipulate Variables
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          //Check clicks
                          final desiredTouch = pieTouchResponse.touchInput
                                  is! PointerExitEvent &&
                              pieTouchResponse.touchInput is! PointerUpEvent;

                          if (desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            //Not clicks and section is not null
                            touchedIndex = pieTouchResponse
                                .touchedSection.touchedSectionIndex;
                          } else if (!desiredTouch &&
                              pieTouchResponse.touchedSection != null) {
                            if (doubleClick ==
                                pieTouchResponse
                                    .touchedSection.touchedSectionIndex) {
                              heightCont = 0;
                              doubleClick = null;
                            } else {
                              doubleClick = pieTouchResponse
                                  .touchedSection.touchedSectionIndex;
                              //There's a click and section is not null
                              colorCont = pieTouchResponse
                                  .touchedSection.touchedSection.color
                                  .withOpacity(0.6);
                              heightCont = 500;
                            }
                          } else {
                            touchedIndex = -1;
                          }
                        });
                      }),
                      startDegreeOffset: 180,
                      sections: showingSections(),
                      centerSpaceRadius: 0),
                  swapAnimationDuration: Duration(milliseconds: 500),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.center,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  height: heightCont,
                  width: 800,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: colorCont,
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: const Color(0xff0293ee).withOpacity(opacity),
              value: 25,
              title: 'Test',
              radius: 200,
              showTitle: true,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: const Color(0xfff8b250).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 200,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff90672d)),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: const Color(0xff845bef).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 200,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: const Color(0xff13d38e).withOpacity(opacity),
              value: 25,
              title: '',
              radius: 200,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            return null;
        }
      },
    );
  }
}
