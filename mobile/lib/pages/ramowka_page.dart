import 'package:flutter/material.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/fetch_ramowka.dart';
import 'package:radioaktywne/components/ramowka/ramowka_list.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/ra_progress_indicator.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/day.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

/// Page displaying Ramowka from all days of the week.
class RamowkaPage extends StatelessWidget {
  const RamowkaPage({
    super.key,
    this.timeout = const Duration(seconds: 7),
  });

  /// Fetch function timeout.
  final Duration timeout;

  Future<Map<Day, List<RamowkaInfo>>> _fetchRamowka() async {
    final ramowka = await fetchRamowka();
    final result = <Day, List<RamowkaInfo>>{};

    for (final elem in ramowka) {
      result.update(
        elem.day,
        (dayEntry) {
          dayEntry.add(elem);
          return dayEntry;
        },
        ifAbsent: () => [],
      );
    }

    for (final elem in result.entries) {
      elem.value.sort();
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundLight,
      child: RefreshableFetchWidget(
        onFetch: _fetchRamowka,
        defaultData: const <Day, List<RamowkaInfo>>{},
        loadingBuilder: (_, __) => const RaProgressIndicator(),
        errorBuilder: (_) => const RaErrorPage(),
        hasData: (ramowka) => ramowka.isNotEmpty,
        builder: (context, ramowka) => ListView.separated(
          padding: RaPageConstraints.outerWidgetPagePadding.copyWith(
            top: RaPageConstraints.pagePaddingValue,
            bottom: context.playerPaddingValue,
          ),
          itemCount: Day.values.length,
          itemBuilder: (context, index) {
            final currentDay = Day.byIndex(index);
            final ramowkaForDay = ramowka[currentDay] ?? [RamowkaInfo.empty()];
            return ColorShadowedCard(
              header: Padding(
                padding: const EdgeInsets.only(
                  left: RaPageConstraints.headerTextPaddingLeft,
                ),
                child: Text(
                  currentDay.toL10nString(context),
                  style: context.textStyles.textMedium,
                ),
              ),
              shadowColor: context.shadowColor(index),
              child: RaListWidget(
                scrollPhysics: const NeverScrollableScrollPhysics(),
                itemCount: ramowkaForDay.length,
                items: ramowkaForDay
                    .map(
                      (ramowkaInfo) => RamowkaListItem(
                        info: ramowkaInfo,
                        rowHeight: RaPageConstraints.ramowkaListRowHeight,
                      ),
                    )
                    .toList(),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              const SizedBox(height: RaPageConstraints.pagePaddingValue),
        ),
      ),
    );
  }
}
