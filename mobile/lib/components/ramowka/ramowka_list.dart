import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/ramowka_info.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/resources/day.dart';

/// List of Ramowka entries.
class RamowkaList extends StatefulWidget {
  const RamowkaList({
    super.key,
    required this.timeout,
    this.rows = 7,
    this.rowHeight = 22.0,
    this.dDataSource,
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  /// Optional external data source to fill
  /// the list, pulled from the radioaktywne.pl api on default.
  final Future<void>? dDataSource;

  @override
  State<RamowkaList> createState() => _RamowkaListState();
}

class _RamowkaListState extends State<RamowkaList> {
  Future<void>? _ramowkaFuture;
  List<RamowkaInfo> _ramowka = [];

  static final Uri _url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );
  static const _headers = {'Content-Type': 'application/json'};

  static String get _currentTime =>
      DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.now());

  Future _updateRamowka() async {
    /// Debug: you can plug external data source in to test the widget
    if (widget.dDataSource != null) {
      return;
    }

    final data = await _fetchData();
    final currentTime = _currentTime;

    setState(
      () {
        _ramowka = _parseRamowka(data, currentTime, Day.today());

        /// Display Ramowka from the next day if current
        /// list's length is less than [rows] and it's
        /// past 20:00.
        if (_ramowka.length < widget.rows &&
            currentTime.compareTo('20:00') >= 0) {
          final ramowkaTomorrow =
              _parseRamowka(data, currentTime, Day.tomorrow());
          for (var i = 0; i <= widget.rows - _ramowka.length; i++) {
            _ramowka.add(ramowkaTomorrow[i]);
          }
        }
      },
    );
  }

  Future<Iterable<RamowkaInfo>> _fetchData() async {
    final response = await http
        .get(
          _url,
          headers: _headers,
        )
        .timeout(widget.timeout);

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

  @override
  void initState() {
    _ramowkaFuture = widget.dDataSource ?? Future<void>(_updateRamowka);
    super.initState();
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
  /// based on the contents of [_ramowka] future.
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

/// Empty variant of [RamowkaList] displayed when
/// the data can't be loaded.
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

/// Variant of the [RamowkaList] containing
/// a waiting animation.
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
