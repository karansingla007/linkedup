import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

///This is just an abstraction class of the [SvgPicture] library
///So that this library can be easily changed if needed
class ImageLoader {
  static Widget asset(
    String assetName, {
    double height,
    double width,
    Color color,
  }) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      color: color,
    );
  }

  static Widget networkSvg(
    String assetName, {
    double height,
    double width,
    Color color,
  }) {
    return SvgPicture.network(
      assetName,
      height: height,
      width: width,
      color: color,
      fit: BoxFit.cover,
    );
  }

//  static ImageProvider network(url) {
//    return AdvancedNetworkImage(url, useDiskCache: true, retryLimit: 3);
//  }

  static Widget network(
    url, {
    BorderRadius borderRadius,
    bool isShowShimmer = true,
    BoxFit fit = BoxFit.cover,
  }) {
    if (url == null) {
      return Container();
    }

    return TransitionToImage(
      loadFailedCallback: () {
        return Container();
      },
      loadingWidget: isShowShimmer
          ? Shimmer.fromColors(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey, borderRadius: borderRadius),
              ),
              baseColor: Color(0xFF333333),
              highlightColor: Colors.white10,
            )
          : Container(
              color: Colors.transparent,
            ),
      placeholder: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: borderRadius,
        ),
      ),
      borderRadius: borderRadius,
      fit: fit,
      image: AdvancedNetworkImage(
        url,
        useDiskCache: true,
        retryLimit: 3,
        printError: true,
      ),
    );
  }

  static Future<void> preCache(
      {@required String url, @required context}) async {
    return await precacheImage(
      AdvancedNetworkImage(
        url,
        retryLimit: 3,
        useDiskCache: true,
      ),
      context,
    );
  }
}
