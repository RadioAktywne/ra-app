import 'package:flutter/cupertino.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/themes.dart';

/// TODO: This is still a dummy widget, needs implementing fetching logic
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
      // TODO: Change this for array of real SwipeableCardItems
      items: [
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
        SwipeableCardItem(
          thumbnailPath: '',
          title: 'Lorem Ipsum',
          onTap: () {},
        ),
      ],
      isLoading: false, // TODO: Change this to a real value
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
