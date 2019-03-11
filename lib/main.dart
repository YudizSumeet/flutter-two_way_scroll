import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(ScrollDemo());

class ScrollDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      home: TwoWayScroll(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TwoWayScroll extends StatefulWidget {
  @override
  _TwoWayScrollState createState() => _TwoWayScrollState();
}

class _TwoWayScrollState extends State<TwoWayScroll> {
  ScrollController _scrollControllerForward, _scrollControllerReverse;
  bool _isForwardScrolled;
  List<String> _imagesList, _titleList;
  int _midPoint;

  @override
  void initState() {
    Map<String, String> _itemMap = {
      "TOY": "images/toy.jpeg",
      "VACATION": "images/vacation.jpeg",
      "HOBBY": "images/hobby.jpeg",
      "GARAGE": "images/garage.jpeg",
      "DINNING AREA": "images/dinning_area.jpeg",
      "HOME": "images/home.jpeg",
      "TRAVEL": "images/travel.jpeg",
      "ACCESORIES": "images/accesories.jpeg",
      "INTERIOR": "images/interior.jpeg",
      "WRIST BAND": "images/wrist_band.jpeg",
    };
    _titleList = _itemMap.keys.toList();
    _imagesList = _itemMap.values.toList();
    _midPoint = _itemMap.length ~/ 2;
    _scrollControllerForward = new ScrollController();
    _scrollControllerReverse = new ScrollController();

    _scrollControllerForward.addListener(() {
      if (_isForwardScrolled)
        _scrollControllerReverse.jumpTo(_scrollControllerForward.offset);
    });

    _scrollControllerReverse.addListener(() {
      if (!_isForwardScrolled)
        _scrollControllerForward.jumpTo(_scrollControllerReverse.offset);
    });
    super.initState();
  }


  @override
  void dispose() {
    _scrollControllerForward.dispose();
    _scrollControllerReverse.dispose();
  }

  Widget _getListView({@required scrollController, isReverse = false}) {
    return NotificationListener(
        onNotification: (t) {
          if (t is UserScrollNotification) _isForwardScrolled = !isReverse;
        },
        child: Container(
          color: Colors.black,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: ListView.builder(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height / 2),
              reverse: isReverse,
              controller: scrollController,
              itemBuilder: (context, pos) {
                return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: <Widget>[
                        SizedBox.expand(
                          child: Image.asset(
                            _imagesList[isReverse ? pos : pos + _midPoint],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black12,
                                Colors.black26,
                                Colors.black38,
                                Colors.black,
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            _titleList[isReverse ? pos : pos + _midPoint],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                letterSpacing: 2.0,
                                fontFamily: "Alegreya"),
                          ),
                        )
                      ],
                    ));
              },
              itemCount: _midPoint,
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: <Widget>[
            Expanded(
                child: _getListView(scrollController: _scrollControllerForward)),
            Expanded(
                child: _getListView(
                    scrollController: _scrollControllerReverse, isReverse: true)),
          ],
        ));
  }
}

class CustomScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}