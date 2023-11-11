import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/ramowka_info.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/day.dart';

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

  static final Uri _url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );
  static const _headers = {'Content-Type': 'application/json'};

  static String get _currentTime =>
      DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.now());

  Future<List<RamowkaInfo>> _fetchRamowka() async {
    final data = await _fetchData();
    final ramowka = _parseRamowka(data, _currentTime, Day.today());

    /// Display Ramowka from the next day if current
    /// list's length is less than [rows] and it's
    /// past 20:00.
    if (ramowka.length < rows && _currentTime.compareTo('20:00') >= 0) {
      final ramowkaTomorrow = _parseRamowka(data, _currentTime, Day.tomorrow());
      for (var i = 0; i <= rows - ramowka.length; i++) {
        try {
          ramowka.add(ramowkaTomorrow[i]);
        } catch (e) {
          break;
        }
      }
    }

    return ramowka;
  }

  Future<Iterable<RamowkaInfo>> _fetchData() async {
    final response = await http
        .get(
          _url,
          headers: _headers,
        )
        .timeout(timeout);

    final jsonData = jsonDecode(response.body) as List<dynamic>;

    return jsonData.map(
      (dynamic data) => RamowkaInfo.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Parse data to a list of [RamowkaInfo] entries from
  /// the current day and which haven't ended yet.
  List<RamowkaInfo> _parseRamowka(
    Iterable<RamowkaInfo> data,
    String currentTime,
    Day day,
  ) =>
      data
          .where(
            (e) =>
                e.day == day &&
                (currentTime.compareTo(e.endTime) <= 0 ||
                    currentTime.compareTo(e.startTime) <= 0),
          )
          .sorted((a, b) => a.startTime.compareTo(b.startTime));

  double get height => rows * rowHeight;

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

/// Empty variant of [RamowkaList] displayed when
/// the data can't be loaded.
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

/// Represents a single [RamowkaList] entry.
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
