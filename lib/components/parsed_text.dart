import 'package:flutter/material.dart';

import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:url_launcher/url_launcher.dart';

class UprightParsedText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;

  UprightParsedText({@required this.text, this.style, this.maxLines, this.textAlign = TextAlign.left}) : assert(text != null);

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  String _parseText() {
    String textSpan;
    textSpan = text.replaceAll(new RegExp(r"\s{2,}"), " ").trim();
    textSpan = textSpan.replaceAll(new RegExp(r"\n"), "\n\n");
    textSpan = textSpan.replaceAll("...", "");
    textSpan = textSpan.replaceAll("&amp;", "&");
    return textSpan;
  }

  @override
  Widget build(BuildContext context) {
    return ParsedText(
      text: _parseText(),
      alignment: textAlign,
      maxLines: maxLines ?? text.length,
      style: style ?? Theme.of(context).textTheme.body1.copyWith(fontSize: 18),
      overflow: TextOverflow.ellipsis,
      parse: [
        MatchText(
          type: "url",
          style: TextStyle(
            color: Color(0xFF007CBB),
          ),
          onTap: launchUrl,
        ),
        MatchText(
          pattern: r"^@.+$",
          style: TextStyle(
            color: Color(0xFF007CBB),
          ),
          onTap: (String url) async {
            url = "https://twitter.com/${url.replaceFirst('@', '')}";
            launchUrl(url);
          },
        ),
        MatchText(
          pattern: r"^#.+$",
          style: TextStyle(
            color: Color(0xFF007CBB),
          ),
          onTap: (String url) async {
            url =
                "https://twitter.com/hashtag/${url.replaceFirst('#', '')}?src=hashtag_click";
            launchUrl(url);
          },
        ),
      ],
    );
  }
}
