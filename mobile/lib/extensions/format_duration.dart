extension FormatDuation on Duration {
  String formattedMinsAndSecs() {
    return '${inMinutes.toString().padLeft(2, "0")}:${(inSeconds % 60).toString().padLeft(2, "0")}';
  }
}
