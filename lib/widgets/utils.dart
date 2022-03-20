import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openLink({required String url}) => launchUrl(url);

  static Future launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static void openEmail({String? toEmail, required String subject, required String body}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await launchUrl(url);
  }
}
class DottedText extends Text {
  const DottedText(
      String data, {
        Key? key,
        TextStyle? style,
        TextAlign? textAlign,
        TextDirection? textDirection,
        Locale? locale,
        bool? softWrap,
        TextOverflow? overflow,
        double? textScaleFactor,
        int? maxLines,
        String? semanticsLabel,
      }) : super(
    '\u2022 $data',
    key: key,
    style: style,
    textAlign: textAlign,
    locale: locale,
    softWrap: softWrap,
    overflow: overflow,
    textScaleFactor: textScaleFactor,
    maxLines: maxLines,
    semanticsLabel: semanticsLabel,
  );
}
