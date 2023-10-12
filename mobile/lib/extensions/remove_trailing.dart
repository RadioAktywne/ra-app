/// Adds methods to remove all trailing
/// occurrences of a provided character from the String
extension RemoveTrailing on String {
  String removeTrailing(String char) {
    assert(char.length == 1);
    var index = length - 1;
    while (index >= 0 && this[index] == char) {
      --index;
    }

    return substring(0, index + 1);
  }
}
