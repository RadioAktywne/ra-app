import 'package:flutter/cupertino.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/build_context.dart';

/// Widget representing three most recent recordings.
class NewestRecordingWidget extends StatelessWidget {
  const NewestRecordingWidget({
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
          id: 0,
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
        SwipeableCardItem(
          id: 1,
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
        SwipeableCardItem(
          id: 2,
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
      ],
      isLoading: true,
      shadowColor: shadowColor ?? defaultShadowColor,
      header: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          'Najnowsze nagrania',
          style: context.textStyles.textSmallGreen,
        ),
      ),
    );
  }
}
