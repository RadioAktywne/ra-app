import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:radioaktywne/components/color_shadowed_card.dart';
import 'package:radioaktywne/extensions/extensions.dart';

/// Widget representing Ramówka
class RamowkaWidget extends StatelessWidget {
  const RamowkaWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: ColorShadowedCard(
        shadowColor: context.colors.highlightBlue,
        header: SizedBox(
          height: 31,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ramówka',
                style: context.textStyles.textMedium,
              ),
              IconButton(
                // TODO: nagivation to Ramowka page
                onPressed: () {},
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.menu),
                iconSize: 28,
                color: context.colors.highlightGreen,
                splashColor: context.colors.highlightGreen,
              ),
            ],
          ),
        ),
        child: const RamowkaList(),
      ),
    );
  }
}

class RamowkaList extends StatefulWidget {
  const RamowkaList({
    super.key,
    this.rows = 7,
    this.rowHeight = 22.0,
  });

  /// Number of rows
  final int rows;

  /// Single row's height
  final double rowHeight;

  @override
  State<RamowkaList> createState() => _RamowkaListState();
}

class _RamowkaListState extends State<RamowkaList>
    with AutomaticKeepAliveClientMixin {
  Future<void>? _ramowkaFuture;
  var _ramowka = <RamowkaInfo>[];
  static final Uri _url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _ramowkaFuture = Future<void>(_updateRamowka);
    super.initState();
  }

  Future _updateRamowka() async {
    // TODO: + parse data for entries from current day only
    // TODO: + try switching code to hooks
    final response = await http.get(
      _RamowkaListState._url,
      headers: {'Content-Type': 'application/json'},
    );

    //! PROD
    final jsonData = jsonDecode(response.body) as List<dynamic>;

    //! DEBUG
    // final jsonData = jsonDecode(_MockJson.audycjeData(10)) as List<dynamic>;

    setState(
      () {
        _ramowka = jsonData
            .map(
              (dynamic data) =>
                  RamowkaInfo.fromJson(data as Map<String, dynamic>),
            )
            .sorted((a, b) => a.startTime.compareTo(b.startTime))
            .map(
              (element) => RamowkaInfo(
                title: element.title,
                startTime: RamowkaInfo.parseTime(element.startTime),
                day: element.day,
              ),
            )
            .where((e) => e.day == Day.today())
            .toList();

        /// Adds empty elements to fill the list up to the number of rows
        for (var i = _ramowka.length; i < widget.rows; i++) {
          _ramowka.add(RamowkaInfo.empty());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: widget.rows * widget.rowHeight,
      child: FutureBuilder(
        future: _ramowkaFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.done
                ? RefreshIndicator(
                    color: context.colors.highlightGreen,
                    backgroundColor: context.colors.backgroundDark,
                    displacement: 0,
                    onRefresh: _updateRamowka,
                    child: ListView.builder(
                      itemCount: _ramowka.length,
                      itemBuilder: (context, index) => _RamowkaListItem(
                        index: index,
                        info: _ramowka[index],
                        rowHeight: widget.rowHeight,
                      ),
                    ),
                  )
                : Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: context.colors.highlightGreen,
                        backgroundColor: context.colors.backgroundDark,
                      ),
                    ),
                  ),
      ),
    );
  }
}

class _RamowkaListItem extends StatelessWidget {
  const _RamowkaListItem({
    required this.index,
    required this.info,
    required this.rowHeight,
  });

  final int index;
  final double rowHeight;
  final RamowkaInfo info;

  /// Calculates aspect ratio from screen width and
  /// this widget's single row height
  double aspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.width / rowHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: rowHeight,
      color: index.isEven
          ? context.colors.backgroundDarkSecondary
          : context.colors.backgroundDark.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio(context),
              child: Text(
                info.title,
                style: context.textStyles.textSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Text(
              info.startTime,
              style: context.textStyles.textSmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Information about single Ramowka entry
class RamowkaInfo {
  const RamowkaInfo({
    required this.title,
    required this.startTime,
    required this.day,
  });

  /// Creates empty RamowkaInfo object
  RamowkaInfo.empty()
      : title = '',
        startTime = '',
        day = Day.none;

  RamowkaInfo.fromJson(Map<String, dynamic> jsonData)
      : title = parseTitle(
          (jsonData['title'] as Map<String, dynamic>)['rendered'].toString(),
        ),
        startTime =
            (jsonData['acf'] as Map<String, dynamic>)['start_time'].toString(),
        day = Day.fromString(
          (jsonData['acf'] as Map<String, dynamic>)['day'].toString(),
        );

  final String title;
  final String startTime;
  final Day day;

  static String parseTime(String time) {
    final start = time[0] == '0' ? 1 : 0;
    final end = time.length - 3;
    return time.substring(start, end);
  }

  static String parseTitle(String title) {
    return title.replaceAll('&#8217;', "'");
  }

  @override
  String toString() {
    return '''
    Ramowka(
      title: `$title`, 
      startTime: `$startTime`, 
      day: `$day`
    )
    ''';
  }
}

enum Day {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  none;

  static Day fromString(String s) {
    try {
      return Day.values.byName(s);
    } catch (e) {
      return Day.none;
    }
  }

  static Day today() {
    try {
      return Day.fromString(
        DateFormat('EEEE').format(DateTime.now()).toLowerCase(),
      );
    } catch (e) {
      return none;
    }
  }
}

abstract class _MockJson {
  static String audycjeData(int times) {
    assert(times >= 0 && times <= 24);
    final res = StringBuffer('[');
    for (var i = 0; i < times; ++i) {
      res.write(
        '''
        {
          "title": {
            "rendered": "Audycja $i"
          },
          "acf": {
            "start_time": "$i:00:00",
            "day": "${Day.today().name}"
          }
        }
        ''',
      );
      if (i != times - 1) {
        res.write(',');
      }
    }
    res.write(']');

    // print("res=$res");
    return res.toString();
  }
}
