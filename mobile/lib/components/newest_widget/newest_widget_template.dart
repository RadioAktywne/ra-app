import 'package:flutter/widgets.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/components/utility/swipeable_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/fetch_data.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Simple main page widget template for displaying
/// newest articles, recordings, etc.
class NewestWidgetTemplate<T> extends HookWidget {
  const NewestWidgetTemplate({
    super.key,
    required this.title,
    required this.fetchData,
    required this.itemBuilder,
    this.shadowColor,
  });

  /// Title of the card.
  final String title;

  /// Function used to fetch newest items.
  ///
  /// Could just be [fetchNewest()] with appropriate args.
  final AsyncValueGetter<Iterable<T>> fetchData;

  /// Function used to build widget entries using the provided data.
  final NewestWidgetTemplateItem<T> Function(BuildContext, T) itemBuilder;

  /// Optional shadow color for the card.
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final items = useState<Iterable<T>>([]);
    final hasError = useState(false);
    final isLoading = useState(true);

    useEffect(
      () {
        isLoading.value = true;
        fetchData().then((value) {
          items.value = value;
          isLoading.value = false;
        }).catchError((_) {
          hasError.value = true;
          isLoading.value = false;
        });

        return;
      },
      [],
    );

    return SwipeableCard(
      items: items.value.map(
        (info) {
          final item = itemBuilder(context, info);
          return SwipeableCardItem(
            thumbnailPath: item.thumbnailPath,
            title: item.title,
            onTap: item.onClick,
          );
        },
      ),
      shadowColor: shadowColor ?? context.colors.highlightYellow,
      header: Padding(
        padding: const EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: RaPageConstraints.headerTextPaddingLeft,
        ),
        child: Text(
          title,
          style: context.textStyles.textSmallGreen,
        ),
      ),
      isLoading: isLoading.value,
      hasError: hasError.value,
    );
  }
}

class NewestWidgetTemplateItem<T> {
  const NewestWidgetTemplateItem({
    required this.thumbnailPath,
    required this.title,
    required this.onClick,
  });

  final String thumbnailPath;
  final String title;
  final void Function() onClick;
}

Future<Iterable<T>> fetchNewest<T>(
    String uriBase, String endpoint, T Function(Map<String, dynamic>) fromJson,
    {int n = 3}) {
  final pageUri = Uri.https(
    uriBase,
    endpoint,
    {
      '_embed': true,
      'page': 1,
      'per_page': n,
    }.valuesToString(),
  );

  return fetchData(pageUri, fromJson);
}
