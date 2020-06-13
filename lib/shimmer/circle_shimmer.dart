import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CircleShimmer extends StatelessWidget {
  final double height;
  final double width;

  CircleShimmer({this.height = 88, this.width = 88});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color(0xFF333333),
      highlightColor: Color.fromRGBO(51, 51, 51, 0),
      child: Container(
        width: this.width,
        height: this.height,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(10000.0)),
      ),
    ); // shimmer
  }
}
