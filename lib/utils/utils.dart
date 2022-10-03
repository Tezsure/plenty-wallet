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
