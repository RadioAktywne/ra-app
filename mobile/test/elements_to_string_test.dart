import 'package:flutter_test/flutter_test.dart';
import 'package:radioaktywne/extensions/extensions.dart';

void main() {
  // lists
  test(
    'See if list of ints gets properly converted to'
    'list of strings',
    () {
      final list = [1, 2, 3];
      expect(['1', '2', '3'], list.elementsToString());
    },
  );
  test(
    'See if list of dynamic gets properly converted to'
    'list of strings',
    () {
      final list = [1, '2', true];
      expect(['1', '2', 'true'], list.elementsToString());
    },
  );
  // maps
  test(
    'See if map of int to int gets properly'
    'converted to map of int to strings',
    () {
      final map = {1: 1, 2: 2};
      expect(
        {1: '1', 2: '2'},
        map.valuesToString(),
      );
    },
  );
  test(
    'See if map of dynamic to dynamic gets properly'
    'converted to map of dynamic to strings',
    () {
      final map = {1: 1, true: false, '3': 'three'};
      expect({1: '1', true: 'false', '3': 'three'}, map.valuesToString());
    },
  );
  test(
    'See if map of dynamic to dynamic gets properly'
    'converted to map of string to dynamic',
    () {
      final map = {1: 1, true: false, '3': 'three'};
      expect({'1': 1, 'true': false, '3': 'three'}, map.keysToString());
    },
  );
  test(
    'See if map of dynamic to dynamic gets properly'
    'converted to map of string to string',
    () {
      final map = {1: 1, true: false, '3': 'three'};
      expect({'1': '1', 'true': 'false', '3': 'three'}, map.itemsToString());
    },
  );
}
