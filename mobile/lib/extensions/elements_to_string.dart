extension ElementsToString<T> on Iterable<T> {
  Iterable<String> elementsToString() => map((elem) => elem.toString());
}

extension ToString<K, V> on Map<K, V> {
  Map<String, V> keysToString() {
    final newMap = <String, V>{};
    forEach(
      (key, value) => newMap.putIfAbsent(key.toString(), () => value),
    );
    return newMap;
  }

  Map<K, String> valuesToString() {
    final newMap = <K, String>{};
    forEach(
      (key, value) => newMap.putIfAbsent(key, () => value.toString()),
    );
    return newMap;
  }

  Map<String, String> itemsToString() {
    final newMap = <String, String>{};
    forEach(
      (key, value) =>
          newMap.putIfAbsent(key.toString(), () => value.toString()),
    );
    return newMap;
  }
}
