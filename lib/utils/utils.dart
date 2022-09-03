String tz1Shortner(String tz1) => tz1.length > 3
    ? ("${tz1.substring(0, 3)}...${tz1.substring(tz1.length - 3, tz1.length)}")
    : tz1;

extension StringShortner on String {
  /// Shortens tz1 address to tz1...qfz format
  String tz1Short() {
    if (length > 3) {
      return ("${substring(0, 3)}...${substring(length - 3, length)}");
    } else {
      return this;
    }
  }

  /// Shortens tz1 address to tz1KpKTX1.....DZ format
  String addressShortner() {
    if (length > 9) {
      return ("${substring(0, 9)}.....${substring(length - 2, length)}");
    } else {
      return this;
    }
  }
}
