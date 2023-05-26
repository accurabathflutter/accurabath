import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:for_practice_the_app/utils/general_utils.dart';
import 'package:for_practice_the_app/utils/shared_pref_helper.dart';
import 'package:url_launcher/url_launcher.dart';

enum Share {
  facebook,
  twitter,
  whatsapp,
  whatsapp_personal,
  whatsapp_business,
  share_system,
  share_instagram,
  share_telegram
}

String SerialKey =
    SharedPrefHelper.instance.getLoginUserData().details[0].serialKey;
bool isMsgDefault = true;

String AIMSerialKey = /*AIM:*/ "A9GM-IP9S-FQT5-3N7D";
String AIMClientMsg =
    "Hello sir ji any finalization about HYDRAULIC BALER, Twinshaft Shredder,etc..\n" +
        "Please let us know if any updates.\n" +
        "Thanks"; /* & Regards\n" +
        "Utsav Patel\n" +
        "Aim Industries\n" +
        "WWW.AIMBALERS.COM";*/

class ShareMsg {
  static msg(BuildContext context, String mobileNumber) {
    return showCommonDialogWithTwoOptions(
        context,
        "Do you have Two Accounts of WhatsApp ?" +
            "\n" +
            "Select one From below Option !",
        positiveButtonTitle: "WhatsApp",
        onTapOfPositiveButton: () {
          Navigator.pop(context);
          onButtonTap(Share.whatsapp_personal, mobileNumber);
        },
        negativeButtonTitle: "Business",
        onTapOfNegativeButton: () {
          Navigator.pop(context);

          _launchWhatsAppBuz(mobileNumber);
          //onButtonTap(Share.whatsapp_business,model);
        });
  }
}

Future<void> onButtonTap(Share share, String MobileNumber) async {
  print("slkdjf" + SerialKey);

  if (SerialKey.toLowerCase().toString() ==
          AIMSerialKey.toLowerCase().toString() ||
      SerialKey.toLowerCase().toString() ==
          "TEST-0000-SI0F-0208".toLowerCase().toString()) {
    isMsgDefault = false;
  }

  String msg = "_";
  /*= isMsgDefault == true ? "_" : AIMClientMsg*/;

  String url = 'https://pub.dev/packages/flutter_share_me';

  String response;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  switch (share) {
    case Share.facebook:
      response = await flutterShareMe.shareToFacebook(url: url, msg: msg);
      break;
    case Share.twitter:
      response = await flutterShareMe.shareToTwitter(url: url, msg: msg);
      break;

    case Share.whatsapp_business:
      response = await flutterShareMe.shareToWhatsApp4Biz(msg: msg);
      break;
    case Share.share_system:
      response = await flutterShareMe.shareToSystem(msg: msg);
      break;
    case Share.whatsapp_personal:
      response = await flutterShareMe.shareWhatsAppPersonalMessage(
          message: msg,
          phoneNumber:
              MobileNumber.length == 10 ? "+91" + MobileNumber : MobileNumber);
      break;
    case Share.share_telegram:
      response = await flutterShareMe.shareToTelegram(msg: msg);
      break;
  }
  debugPrint(response);
}

void _launchWhatsAppBuz(String MobileNo) async {
  if (SerialKey.toLowerCase().toString() ==
          AIMSerialKey.toLowerCase().toString() ||
      SerialKey.toLowerCase().toString() ==
          "TEST-0000-SI0F-0208".toLowerCase().toString()) {
    isMsgDefault = false;
  }

  String msg = "Hello";
  /*= isMsgDefault == true ? "_" : AIMClientMsg*/;
  print("sdjfdffddf" + AIMClientMsg.length.toString());

  //String Mobi = MobileNo.length == 10 ? "+91" + MobileNo : MobileNumber;
  await launch(
      "https://wa.me/${MobileNo.length == 10 ? "+91" + MobileNo : MobileNo}?text=$msg");
}
