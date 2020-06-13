import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  final double screenHeight;
  final double heightOfSingleElement;
  final double widthOfSingleElement;

  ShimmerList(
      {@required this.screenHeight,
      this.heightOfSingleElement = 100,
      this.widthOfSingleElement = 300});

  buildWidget(totalBoxes) {
    List<Widget> boxWidgetList = List();
    for (int i = 0; i < totalBoxes; i++) {
      boxWidgetList.add(
        Container(
          height: this.heightOfSingleElement,
          width: this.widthOfSingleElement,
          color: Colors.black12,
        ),
      );
      boxWidgetList.add(
        SizedBox(
          height: 10.0,
        ),
      );
    }

    double remainingBoxHeight =
        screenHeight - ((heightOfSingleElement + 10) * totalBoxes);

    if (remainingBoxHeight > 0) {
      boxWidgetList.add(
        Container(
          height: remainingBoxHeight,
          width: this.widthOfSingleElement,
          color: Colors.black12,
        ),
      );
    }

    return boxWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    double totalBoxesDouble = (screenHeight / ((heightOfSingleElement + 10)));
    int totalBoxesInt = totalBoxesDouble.toInt();
    List<Widget> boxWidget = buildWidget(totalBoxesInt);

    return Shimmer.fromColors(
      baseColor: Color(0xFF333333),
      highlightColor: Color.fromRGBO(51, 51, 51, 0),
      direction: ShimmerDirection.ltr,
      child: Column(
        children: boxWidget,
      ),
    );
  }
}
