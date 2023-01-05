String tz1Shortner(String tz1) => tz1.length > 3
    ? ("${tz1.substring(0, 3)}...${tz1.substring(tz1.length - 3, tz1.length)}")
    : tz1;

extension StringHelper on String {
  /// Shortens tz1 address to tz1...qfz format
  String tz1Short() {
    if (length > 4) {
      return ("${substring(0, 4)}...${substring(length - 4, length)}");
    } else {
      return this;
    }
  }

  get isValidWalletAddress =>
      (startsWith("tz1") || startsWith("tz2") || startsWith("tz3")) &&
      length == 36;

  get removeTrailing0 => replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

String relativeDate(DateTime d) {
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}

extension DecimalsRoundUp on num {
  String roundUpDollar() => this < 0.01
      ? r"<$0.01"
      : this >= 100
          ? r"$ " + toStringAsFixed(0)
          : r"$ " + toStringAsFixed(2);
}
