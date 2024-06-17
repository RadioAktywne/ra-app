import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class CustomPaddingHtmlWidget extends StatelessWidget {
  const CustomPaddingHtmlWidget({
    super.key,    
    required this.style,
    required this.htmlContent,
  });

  final TextStyle style;
  final String htmlContent;

  static const EdgeInsets _textPadding = EdgeInsets.symmetric(horizontal: 7);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _textPadding,
      child: SelectionArea(
        child: DefaultTextStyle(
          style: style,
          child: HtmlWidget(htmlContent),
        ),
      ),
    );
  }
}
