import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:leancode_hooks/leancode_hooks.dart';
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
        child: RamowkaList(),
      ),
    );
  }
}

class RamowkaList extends HookWidget {
  const RamowkaList({
    super.key,
    this.rows = 7,
  });

  static Uri url = Uri.parse(
    'https://radioaktywne.pl/wp-json/wp/v2/event?_embed=true&page=1&per_page=100',
  );

  /// Number of rows
  final int rows;

  /// Single row's height
  static const double _rowHeight = 22;

  /// Calculates aspect ratio from screen width and
  /// this widget's single row height
  static double aspectRatio(BuildContext context) =>
      MediaQuery.of(context).size.width / _rowHeight;

  Future<List<RamowkaInfo>> updateRamowka() async {
    // TODO: add empty elements to fill the list to 7 *rows* elements

    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    final jsonData = jsonDecode(response.body) as List<dynamic>;
    final ramowka = <RamowkaInfo>[];
    for (final data in jsonData) {
      ramowka.add(RamowkaInfo.fromJson(data as Map<String, dynamic>));
    }

    print(ramowka);

    return Future<List<RamowkaInfo>>(
      () => jsonData
          .map(
            (dynamic data) =>
                RamowkaInfo.fromJson(data as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ramowka = useState(List<RamowkaInfo>.empty());
    return SizedBox(
      height: rows * _rowHeight,
      child: RefreshIndicator(
        color: context.colors.highlightGreen,
        backgroundColor: context.colors.backgroundDark,
        displacement: 0,
        onRefresh: () async {
          ramowka.value = await updateRamowka();
        },
        child: ListView.builder(
          itemCount: ramowka.value.length,
          itemBuilder: (context, index) =>
              _RamowkaListItem(index: index, info: ramowka.value[index]),
        ),
      ),
    );
  }
}

class _RamowkaListItem extends StatelessWidget {
  const _RamowkaListItem({
    required this.index,
    required this.info,
  });

  final int index;
  final RamowkaInfo info;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      color: index.isEven
          ? context.colors.backgroundDarkSecondary
          : context.colors.backgroundDark.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AspectRatio(
              aspectRatio: RamowkaList.aspectRatio(context),
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
  });

  /// Creates empty RamowkaInfo object
  RamowkaInfo.empty()
      : title = '',
        startTime = '';

  // TODO: add JSON parsing
  RamowkaInfo.fromJson(Map<String, dynamic> jsonData)
      : title = parseTitle(jsonData['title']['rendered'].toString()),
        startTime = parseTime(jsonData['acf']['start_time'].toString());

  final String title;
  final String startTime;

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
    return title; //'RamowkaInfo(title: $title, startTime: $startTime)';
  }
}
