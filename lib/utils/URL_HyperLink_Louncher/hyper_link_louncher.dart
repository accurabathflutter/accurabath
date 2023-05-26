/* */

import 'package:url_launcher/url_launcher.dart';

class HyperLinkLouncher {
  static openLink(String url) async {
    return await _launchURL(url);
  }
}

_launchURL(String pdfURL) async {
  var url123 = pdfURL;
  if (await canLaunch(url123)) {
    await launch(url123);
  } else {
    throw 'Could not launch $url123';
  }
}
