import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SplashCarousel extends StatefulWidget {
  final List<Widget> widgets;
  final double height;

  const SplashCarousel({
    Key key,
    @required this.widgets,
    this.height,
  })  : assert(widgets != null),
        super(key: key);

  @override
  _SplashCarouselState createState() => _SplashCarouselState(widgets, height);
}

class _SplashCarouselState extends State<SplashCarousel> {
  int _current = 0;
  List<Widget> _widgets;
  double _height;

  _SplashCarouselState(this._widgets, this._height);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _widgets
            .asMap()
            .map((index, widget) => MapEntry(
                index,
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Container(
                    width: 6.0,
                    height: 6.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _current == index ? Colors.black : Colors.blueGrey),
                  ),
                )))
            .values
            .toList(),
      ),
      SizedBox(
        height: 4,
      ),
      CarouselSlider(
        items: _widgets,
        height: _height,
        viewportFraction: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
    ]);
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }
}
