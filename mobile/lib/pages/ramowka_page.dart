import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:radioaktywne/components/ra_list_widget.dart';
import 'package:radioaktywne/components/ramowka/fetch_ramowka.dart';
import 'package:radioaktywne/components/utility/color_shadowed_card.dart';
import 'package:radioaktywne/components/utility/refreshable_fetch_widget.dart';
import 'package:radioaktywne/extensions/extensions.dart';
import 'package:radioaktywne/models/ramowka_info.dart';
import 'package:radioaktywne/pages/ra_error_page.dart';
import 'package:radioaktywne/resources/day.dart';
import 'package:radioaktywne/resources/ra_page_constraints.dart';

class RamowkaPage extends HookWidget {
  const RamowkaPage({super.key, this.timeout = const Duration(seconds: 7)});

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
    return Padding(
      padding: RaPageConstraints.outerWidgetPagePadding,
      child: RefreshableFetchWidget(
        onFetch: _fetchRamowka,
        defaultData: const <Day, List<RamowkaInfo>>{},
        loadingBuilder: (context, snapshot) => const Placeholder(),
        errorBuilder: (context) => const RaErrorPage(),
        hasData: (elem) => elem.isNotEmpty,
        builder: (context, ramowka) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final item = ramowka[Day.byIndex(index)] ?? [RamowkaInfo.empty()];
              return ColorShadowedCard(
                header: Text(
                  item[index].day.toL10nString(context),
                  style: context.textStyles.textMedium,
                ),
                shadowColor: context.colors.highlightBlue,
                child: RaListWidget(
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  rows: item.length,
                  items: item
                      .map(
                        (ramowkaInfo) => Text(
                          ramowkaInfo.title,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyles.textSmall,
                        ) as Widget,
                      )
                      .toList(),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemCount: Day.values.length,
          );
        },
      ),
    );
  }
}
