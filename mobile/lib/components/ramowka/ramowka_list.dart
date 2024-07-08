import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/fetch_ramowka.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/resources/day.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Widget representing a list of Ramowka entries.
class RamowkaList extends StatelessWidget {
  const RamowkaList({
    super.key,
    this.timeout = const Duration(seconds: 7),
    this.rows = 7,
    this.rowHeight = RaPageConstraints.ramowkaListRowHeight,
  });

  /// Timeout for the fetching function.
  final Duration timeout;

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  double get height => rows * rowHeight;

  static String get _currentTime =>
      DateFormat(DateFormat.HOUR24_MINUTE).format(DateTime.now());

  static bool _timeChecks(RamowkaInfo e) =>
      _currentTime.compareTo(e.startTime) <= 0 ||
      _currentTime.compareTo(e.endTime) <= 0;

  Future<List<RamowkaInfo>> _fetchRamowka() async {
    try {
      final data = await fetchRamowka(timeout: timeout);

      final ramowka = _parseRamowka(
        data,
        Day.today(),
        additionalChecks: _timeChecks,
      );

      return _completeRamowka(data, ramowka);
    } on TimeoutException catch (_) {
      return [];
    }
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
          .where(additionalChecks ?? (_) => true)
          .sorted();

  @override
  Widget build(BuildContext context) {
    return RefreshableFetchWidget(
      defaultData: const <RamowkaInfo>[],
      onFetch: _fetchRamowka,
      hasData: (ramowka) => ramowka.isNotEmpty,
      loadingBuilder: (context, snapshot) =>
          _RamowkaListWaiting(height: height),
      errorBuilder: (context) => _RamowkaListNoData(height: height),
      builder: (context, ramowkaInfoList) => RaListWidget(
        rows: rows,
        rowHeight: rowHeight,
        items: ramowkaInfoList
            .map(
              (ramowkaInfo) => RamowkaListItem(
                info: ramowkaInfo,
                rowHeight: rowHeight,
              ),
            )
            .toList(),
      ),
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
    return SizedBox(
      height: height,
      child: const RaProgressIndicator(),
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
            context.l10n.dataLoadError,
            style: context.textStyles.textSmallGreen,
          ),
        ),
      ],
    );
  }
}

/// A single [RamowkaList] entry widget.
class RamowkaListItem extends StatelessWidget {
  const RamowkaListItem({
    super.key,
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
                  style: context.textStyles.textSmallWhite,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ),
          Text(
            info.startTime,
            style: context.textStyles.textSmallWhite,
          ),
        ],
      ),
    );
  }
}
