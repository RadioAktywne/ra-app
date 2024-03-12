import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/ramowka_info.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/day.dart';
import 'package:radioaktywne/resources/fetch_data.dart';

/// Widget representing a list of Ramowka entries.
class RamowkaList extends HookWidget {
  const RamowkaList({
    super.key,
    required this.timeout,
    this.rows = 7,
    this.rowHeight = 22.0,
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  double get height => rows * rowHeight;

  static final Uri _url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );
  static const _headers = {'Content-Type': 'application/json'};

  static String get _currentTime =>
      DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.now());

  static bool _timeChecks(RamowkaInfo e) =>
      _currentTime.compareTo(e.startTime) <= 0 ||
      _currentTime.compareTo(e.endTime) <= 0;

  Future<List<RamowkaInfo>> _fetchRamowka() async {
    final data = await fetchData(
      _url,
      RamowkaInfo.fromJson,
      timeout: timeout,
      headers: _headers,
    );

    final ramowka = _parseRamowka(
      data,
      Day.today(),
      additionalChecks: _timeChecks,
    );

    return _completeRamowka(data, ramowka);
  }

  /// Adds [RamowkaInfo] entries from the next day
  /// if it's past 20:00, or empty [RamowkaInfo] elements
  /// to complete [ramowka] to [rows] number of elements.
  List<RamowkaInfo> _completeRamowka(
    Iterable<RamowkaInfo> data,
    List<RamowkaInfo> ramowka,
  ) {
    final ramowkaTomorrow =
        (ramowka.length < rows && _currentTime.compareTo('20:00') >= 0)
            ? _parseRamowka(data, Day.tomorrow())
            : <RamowkaInfo>[];

    final times = rows - ramowka.length;
    for (var i = 0; i < times; i++) {
      try {
        ramowka.add(ramowkaTomorrow[i]);
      } catch (_) {
        ramowka.add(RamowkaInfo.empty());
      }
    }

    return ramowka;
  }

  /// Parse data to a list of current and future
  /// [RamowkaInfo] entries from the current day.
  List<RamowkaInfo> _parseRamowka(
    Iterable<RamowkaInfo> data,
    Day day, {
    bool Function(RamowkaInfo)? additionalChecks,
  }) =>
      data
          .where((e) => e.day == day)
          .where(additionalChecks ?? (e) => true)
          .sorted((a, b) => a.startTime.compareTo(b.startTime));

  @override
  Widget build(BuildContext context) {
    final ramowka = useState(<RamowkaInfo>[]);
    final ramowkaFuture = useMemoized(_fetchRamowka);
    final snapshot = useFuture(ramowkaFuture);

    /// Called only on the first time the widget
    /// is rendered, because of the empty list argument.
    useEffect(
      () {
        ramowkaFuture.then((e) => ramowka.value = e);
        // nothing to dispose of
        return;
      },
      [],
    );

    return RefreshIndicator(
      color: context.colors.highlightGreen,
      backgroundColor: context.colors.backgroundDark,
      displacement: 0,
      onRefresh: () async => ramowka.value = await _fetchRamowka(),
      child: snapshot.connectionState == ConnectionState.waiting
          ? _RamowkaListWaiting(height: height)
          : _decideRamowkaVariant(ramowka.value),
    );
  }

  /// Decides, which variant of [RamowkaList] to render
  /// based on the contents of [ramowka] future.
  Widget _decideRamowkaVariant(List<RamowkaInfo> ramowka) {
    if (ramowka.isEmpty) {
      return _RamowkaListNoData(height: height);
    }

    return RaListWidget(
      rows: rows,
      rowHeight: rowHeight,
      items: ramowka
          .map(
            (ramowkaInfo) => _RamowkaListItem(
              info: ramowkaInfo,
              rowHeight: rowHeight,
            ),
          )
          .toList(),
    );
  }
}

/// Variant of the [RamowkaList] containing
/// a waiting animation.
///
/// Displayed when the widget is waiting
/// for the data.
class _RamowkaListWaiting extends StatelessWidget {
  const _RamowkaListWaiting({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return RaListWidget(
      rows: 1,
      rowHeight: height,
      items: [
        Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              color: context.colors.highlightGreen,
              backgroundColor: context.colors.backgroundDark,
            ),
          ),
        ),
      ],
    );
  }
}

/// Empty variant of [RamowkaList].
///
/// Displayed when the data can't be loaded.
class _RamowkaListNoData extends StatelessWidget {
  const _RamowkaListNoData({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return RaListWidget(
      rows: 1,
      rowHeight: height,
      items: [
        Center(
          child: Text(
            'Wystąpił błąd podczas pobierania danych',
            style: context.textStyles.textSmall,
          ),
        ),
      ],
    );
  }
}

/// A single [RamowkaList] entry widget.
class _RamowkaListItem extends StatelessWidget {
  const _RamowkaListItem({
    required this.info,
    required this.rowHeight,
  });

  final RamowkaInfo info;
  final double rowHeight;

  /// Calculates aspect ratio from screen width and this
  /// widget's single row height used for max text length.
  double aspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.width / rowHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              // TODO: Navigation to this Audycja
              onTap: () {},
              splashColor: context.colors.highlightGreen.withOpacity(0.3),
              radius: 25,
              child: AspectRatio(
                aspectRatio: aspectRatio(context),
                child: Text(
                  info.title,
                  style: context.textStyles.textSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Text(
            info.startTime,
            style: context.textStyles.textSmall,
          ),
        ],
      ),
    );
  }
}
