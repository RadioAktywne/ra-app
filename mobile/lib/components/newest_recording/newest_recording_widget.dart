import 'package:flutter/widgets.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/themes.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Widget representing three most recent recordings.
class NewestRecordingWidgetMock extends StatelessWidget {
  const NewestRecordingWidgetMock({
    super.key,
    this.shadowColor,
  });

  /// Shadow color for the card.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final defaultShadowColor = context.colors.highlightGreen;

    return SwipeableCard(
      items: [
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'wersja alpha',
          onTap: () {},
        ),
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'nie zawiera',
          onTap: () {},
        ),
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'stron nagrań',
          onTap: () {},
        ),
      ],
      shadowColor: shadowColor ?? defaultShadowColor,
      header: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: RaPageConstraints.headerTextPaddingLeft,
        ),
        child: Text(
          'Najnowsze nagrania',
          style: context.textStyles.textSmallGreen,
        ),
      ),
    );
  }
}
