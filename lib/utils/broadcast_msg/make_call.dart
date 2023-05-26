import 'package:url_launcher/url_launcher.dart';

class MakeCall {
  static callto(String mobileNumber) async {
    return await _makePhoneCall(mobileNumber);
  }
}

Future<void> _makePhoneCall(String phoneNumber) async {
  // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
  // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
  // such as spaces in the input, which would cause `launch` to fail on some
  // platforms.
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  await launch(launchUri.toString());
}
