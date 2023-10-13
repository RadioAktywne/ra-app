import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:radioaktywne/components/color_shadowed_card.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';

/// Widget representing Ramówka
///
/// Consists of a [ColorShadowedCard] with a header and
/// a list of entries in Ramowka.
class RamowkaWidget extends StatelessWidget {
  const RamowkaWidget({
    super.key,
    this.dataSource,
    this.timeout = const Duration(seconds: 7),
  });

  /// Asynchronous source of data in the widget.
  ///
  /// On default, the data is pulled from the radioaktywne.pl api.
  /// If specified, the data will be pulled from the specified source.
  final Future<void>? dataSource;

  /// Timeout for the fetching function.
  final Duration timeout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: ColorShadowedCard(
        shadowColor: context.colors.highlightBlue,
        header: Padding(
          padding: const EdgeInsets.only(left: 3),
          child: SizedBox(
            height: 31,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // TODO: (optional) nagivation to Ramowka page
                onTap: () {},
                highlightColor: Colors.transparent,
                splashColor: context.colors.highlightGreen.withOpacity(0.3),
                radius: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      // TODO: nagivation to Ramowka page
                      onTap: () {
                        // print("Tapped Ramowka");
                      },
                      child: Text(
                        'Ramówka',
                        style: context.textStyles.textMedium,
                      ),
                    ),
                    GestureDetector(
                      // TODO: nagivation to Ramowka page
                      onTap: () {
                        // print("Clicked button");
                      },
                      child: Icon(
                        Icons.menu,
                        size: 28,
                        color: context.colors.highlightGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        child: RamowkaList(
          timeout: timeout,
          dataSource: dataSource,
        ),
      ),
    );
  }
}

/// List of Ramowka entries.
class RamowkaList extends StatefulWidget {
  const RamowkaList({
    super.key,
    required this.timeout,
    this.rows = 7,
    this.rowHeight = 22.0,
    this.dataSource,
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  /// Optional source of the data to fill
  /// the list, pulled from the radioaktywne.pl api on default.
  final Future<void>? dataSource;

  @override
  State<RamowkaList> createState() => _RamowkaListState();
}

class _RamowkaListState extends State<RamowkaList> {
  Future<void>? _ramowkaFuture;
  var _ramowka = <RamowkaInfo>[];
  static final Uri _url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );

  @override
  void initState() {
    _ramowkaFuture = widget.dataSource ?? Future<void>(_updateRamowka);
    super.initState();
  }

  Future _updateRamowka() async {
    /// Debug: you can plug external data source in to test the widget
    if (widget.dataSource != null) {
      return;
    }

    final response = await http.get(
      _RamowkaListState._url,
      headers: {'Content-Type': 'application/json'},
    ).timeout(widget.timeout);
    final jsonData = jsonDecode(response.body) as List<dynamic>;
    final currentTime =
        DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.now());

    final data = jsonData.map(
      (dynamic data) => RamowkaInfo.fromJson(data as Map<String, dynamic>),
    );

    setState(
      () {
        _ramowka = data
            .where(
              (e) =>
                  e.day == Day.today() &&
                  (currentTime.compareTo(e.endTime) <= 0 ||
                      currentTime.compareTo(e.startTime) <= 0),
            )
            .sorted((a, b) => a.startTime.compareTo(b.startTime))
            .toList();

        /// Display Ramowka from the next day if current
        /// list's length is less than [rows] and it's
        /// past 20:00.
        if (_ramowka.length < widget.rows &&
            currentTime.compareTo('20:00') >= 0) {
          final ramowkaTomorrow = data
              .where(
                (e) =>
                    e.day == Day.tomorrow() &&
                    (currentTime.compareTo(e.endTime) <= 0 ||
                        currentTime.compareTo(e.startTime) <= 0),
              )
              .sorted((a, b) => a.startTime.compareTo(b.startTime));
          for (var i = 0; i <= widget.rows - _ramowka.length; i++) {
            _ramowka.add(ramowkaTomorrow[i]);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.rows * widget.rowHeight;
    return FutureBuilder(
      future: _ramowkaFuture,
      builder: (context, snapshot) => RefreshIndicator(
        color: context.colors.highlightGreen,
        backgroundColor: context.colors.backgroundDark,
        displacement: 0,
        onRefresh: _updateRamowka,
        child: snapshot.connectionState == ConnectionState.waiting
            ? _RamowkaWaiting(height: height)
            : _decideRamowkaVariant(height),
      ),
    );
  }

  /// Decides, which variant of [RamowkaList] to render
  /// based on the contents of [_ramowka].
  Widget _decideRamowkaVariant(double height) {
    if (_ramowka.isNotEmpty) {
      return RaListWidget(
        rows: widget.rows,
        rowHeight: widget.rowHeight,
        items: _ramowka
            .map(
              (ramowkaInfo) => _RamowkaListItem(
                info: ramowkaInfo,
                rowHeight: widget.rowHeight,
              ),
            )
            .toList(),
      );
    } else {
      return _RamowkaNoData(height: height);
    }
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

/// Empty variant of [RamowkaList]
class _RamowkaNoData extends StatelessWidget {
  const _RamowkaNoData({required this.height});

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

/// Variant of the [RamowkaWidget] containing
/// a waiting animation
class _RamowkaWaiting extends StatelessWidget {
  const _RamowkaWaiting({required this.height});

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

/// Information about single [RamowkaList] entry.
class RamowkaInfo {
  const RamowkaInfo({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.day,
  });

  /// Creates an empty [RamowkaInfo] object.
  RamowkaInfo.empty()
      : title = '',
        startTime = '',
        endTime = '',
        day = Day.today();

  /// Creates a [RamowkaInfo] object from a given Json map.
  RamowkaInfo.fromJson(Map<String, dynamic> jsonData)
      : title = parseTitle(
          (jsonData['title'] as Map<String, dynamic>)['rendered'].toString(),
        ),
        startTime = parseTime(
          (jsonData['acf'] as Map<String, dynamic>)['start_time'].toString(),
        ),
        endTime = parseTime(
          (jsonData['acf'] as Map<String, dynamic>)['end_time'].toString(),
        ),
        day = Day.fromString(
          (jsonData['acf'] as Map<String, dynamic>)['day'].toString(),
        );

  final String title;
  final String startTime;
  final String endTime;
  final Day day;

  /// Parses time string to the required format
  static String parseTime(String time) =>
      time.removeTrailing('0').removeTrailing(':');

  /// Parses title string to the required format
  static String parseTitle(String title) => title
      .replaceAll('&#8217;', "'")
      .replaceFirst('(Replay)', ' - powtórka')
      .replaceFirst('(Live)', '');

  @override
  String toString() {
    return '''
    Ramowka(
      title: `$title`, 
      startTime: `$startTime`, 
      endTime: `$endTime`,
      day: `$day`
    )
    ''';
  }
}

/// Days of the week
enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  static Day fromString(String s) => values.byName(s.toLowerCase());

  static Day today() =>
      fromString(DateFormat.EEEE().format(DateTime.now()).toLowerCase());

  static Day tomorrow() => Day.values[(today().index + 1) % 7];
}
