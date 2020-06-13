import 'dart:io';
import 'dart:typed_data';

import 'package:wc_flutter_share/wc_flutter_share.dart';

class ShareHelper {
  shareOnSocial(
      String shareUrl,
      ) async {
    await WcFlutterShare.share(
        sharePopupTitle: 'Share', text: shareUrl, mimeType: 'text/plain');
  }
}
