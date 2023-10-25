extension RemoveTrailing on String {
  /// Remove all trailing occurrences of a
  /// provided character [char] from the String
  String removeTrailing(String char) {
    assert(char.length == 1);
    var index = length - 1;
    while (index >= 0 && this[index] == char) {
      --index;
    }

    return substring(0, index + 1);
  }
}
